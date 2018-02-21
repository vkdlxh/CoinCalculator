//
//  BFCoinManager.swift
//  BFCoinManager
//
//  Created by jaeeun on 2018/01/30.
//  Copyright © 2018年 leejaeeun. All rights reserved.
//

import Foundation
import PubNub

protocol BFCoinManagerDataChanged : AnyObject {
    func coinDataDidLoad(_ context:BFContext)
    func coinDataChanged(channel: Channel, productCode: String, data:Any)
}

final class BFCoinManager {
    
    open private(set) var context         : BFContext
    
//    private var requestAPi                : BFCoinAPI
    open private(set) var realtimeApi     : BFCoinRealtimeAPI
    open private(set) var realtimeClient  : PubNub
    open var contextLoaded = false
    
    private var observers = Array<BFCoinManagerDataChanged>()
    
    
    //var context : Dictionary?
    static let shared: BFCoinManager = BFCoinManager()
    
    private init() {
        
        //setup realtime client
//        self.requestAPi = BFCoinAPI()
        self.realtimeClient = BFCoinRealtimeAPI.setupClient()
        self.realtimeApi = BFCoinRealtimeAPI(self.realtimeClient)
        self.context = BFContext()
    }
    
    //MARK: Observer
    open func addObserver(_ observer: BFCoinManagerDataChanged) {
        for item in observers {
            if item === observer {
                return
            }
        }
        
        //登録する
        observers.append(observer)
    }
    
    open func removeObserver(_ observer: BFCoinManagerDataChanged) {
        
        for (index, item) in observers.enumerated() {
            if item === observer {
                //解除する
                observers.remove(at: index)
                break
            }
        }
    }
    
    open func removeAllObserver() {
        observers.removeAll()
    }
    
    private func loadNotification(_ ctx: BFContext) {
        
        for observer in observers {
            //通知する
            observer.coinDataDidLoad(ctx)
        }
        
    }
    
    private func realtimeNotification(channel:Channel, productCode: String, data: Any) {
        
        for observer in observers {
            //通知する
            observer.coinDataChanged(channel: channel, productCode: productCode, data: data)
        }
    }
    
    //MARK: Start
    func start() {
        
        self.keepAliveCountUp()
        
        //Request
        BFCoinAPI.requestMarkets { (markets) in
            self.context.markets = markets
            self.keepAliveCountDown()
        }
        
        waitKeepAlive()
        
        for market in self.context.markets {
            self.keepAliveCountUp()
            BFCoinAPI.requestBoard(market.productCode, completion: { (board) in
                self.keepAliveCountDown()
                
                if let productCode = market.productCode {
                    self.context.boards.append([productCode:board])
                }
                
            })
            
            self.keepAliveCountUp()
            BFCoinAPI.requestTicker(market.productCode, completion: { (ticker) in
                self.keepAliveCountDown()
                
                self.context.tickers.append(ticker)
                
            })
            
            self.keepAliveCountUp()
            BFCoinAPI.requestExecutions(market.productCode,
                                        before: nil,
                                        after: nil,
                                        count: BFContext.maxExecutionCount,
                                        completion: { (executions) in
                                            
                                            self.keepAliveCountDown()
                
                                            if let productCode = market.productCode {
                                                self.context.executions[productCode] = executions
                                            }
                
            })
 
            self.keepAliveCountUp()
            BFCoinAPI.requestBoardState(market.productCode, completion: { (boardState) in
                self.keepAliveCountDown()
                
                if let productCode = market.productCode {
                    self.context.boardStates[productCode] = boardState
                }
            })
            
            self.keepAliveCountUp()
            BFCoinAPI.requestHealth(nil, completion: { (health) in
                self.keepAliveCountDown()
                
                if let productCode = market.productCode {
                    self.context.healths[productCode] = health
                }
            })
        }
        
        waitKeepAlive()
        
        //1時間前チャット。データ量が多い。。
/*
        BFCoinAPI.requestChats(Date(timeIntervalSinceNow: -60*60*1), completion: {(chats) in
            
            self.context.chats = chats
        })
*/
        
        loadNotification(self.context)
        
        self.contextLoaded = true
        
        //Regist realtime message
        for market in self.context.markets {
            if let productCode = market.productCode {
                self.realtimeApi.registChannelsAll(productCode)
            }
        }
    }
    
    //MARK: Realtime
    func realtimeDidReceiveMessage(_ message:Any, channel:String, timeToken:NSNumber) {
        //print("message:\(message), channel:\(channel), timeToken:\(timeToken)")
        
        let productCode = self.productCode(channel: channel)
        
        if channel.hasPrefix(Channel.board.rawValue) {
            //板差分
            guard let dict = message as? [String:Any] else {
                return
            }
            let diffBoard = Board(dictionary: dict)
            //Context更新
            self.updateContextBoard(productCode, diff: diffBoard)
            //通知
            self.realtimeNotification(channel: Channel.board, productCode: productCode, data: diffBoard)
            
        }else if channel.hasPrefix(Channel.ticker.rawValue) {
            //Ticker
            guard let dict = message as? [String:Any] else {
                return
            }
            let diffTicker = Ticker(dictionary: dict)
            self.updateContextTicker(productCode, diff: diffTicker)
            self.realtimeNotification(channel: Channel.ticker, productCode: productCode, data: diffTicker)
            
        }else if channel.hasPrefix(Channel.executions.rawValue) {
            //Executions
            guard let items = message as? [Any] else {
                return
            }
            
            var diffExecutions = [Execution]()
            for item in items {
                if let dict = item as? [String:Any] {
                    let execution = Execution(dictionary: dict)
                    diffExecutions.append(execution)
                }
            }

            self.updateContextExecution(productCode, diff: diffExecutions)
            self.realtimeNotification(channel: Channel.executions, productCode: productCode, data: diffExecutions)
            
        }
        
        
        
    }
    
    private func productCode(channel:String)-> String {
        
        let offset =
        channel.hasPrefix(Channel.board.rawValue) ? Channel.board.rawValue.utf16.count :
        channel.hasPrefix(Channel.ticker.rawValue) ? Channel.ticker.rawValue.utf16.count :
        channel.hasPrefix(Channel.executions.rawValue) ? Channel.executions.rawValue.utf16.count : 0
        
        let productCode = String(channel[channel.index(channel.startIndex,
                                                       offsetBy: offset)...])    //指定インデックスから終端まで
        
        return productCode
    }
    
    private func updateContextBoard(_ productCode:String, diff: Board) {
        
        for (index, dict) in self.context.boards.enumerated() {
            if var board = dict[productCode] {
                board.diffUpdate(diff)
                self.context.boards[index] = [productCode : board]
                break
            }
        }
    }
    
    private func updateContextTicker(_ productCode:String, diff: Ticker) {
        
        for (index, ticker) in self.context.tickers.enumerated() {
            
            guard let code = ticker.productCode else {
                continue
            }
            if code == productCode {
                self.context.tickers.remove(at: index)
                break
            }
        }
        
        self.context.tickers.append(diff)
    }
    
    private func updateContextExecution(_ productCode:String, diff: [Execution]) {
        
        if var items = self.context.executions[productCode] {
            items.insert(contentsOf: diff, at: 0)
            items.removeLast(diff.count)
        }
    }
    
}

//MARK: ロック制御
extension BFCoinManager {
    
    static private var keepAliveCount = 0
    
    fileprivate func keepAliveCountUp() {
        BFCoinManager.keepAliveCount = BFCoinManager.keepAliveCount + 1
        print("keepAliveCount: \(print(BFCoinManager.keepAliveCount))")
    }
    
    fileprivate func keepAliveCountDown() {
        BFCoinManager.keepAliveCount = BFCoinManager.keepAliveCount - 1
        print("keepAliveCount: \(print(BFCoinManager.keepAliveCount))")
    }
    
    fileprivate func waitKeepAlive() {
        let runLoop = RunLoop.current
        while BFCoinManager.keepAliveCount > 0 &&
            runLoop.run(mode: .defaultRunLoopMode, before: Date(timeIntervalSinceNow: 0.1)) {
                // 0.1秒毎の処理なので、処理が止まらない
        }
    }
}

