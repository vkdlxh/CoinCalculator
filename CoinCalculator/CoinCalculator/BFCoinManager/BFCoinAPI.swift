//
//  BFCoinAPI.swift
//  BFCoinAPI
//
//  Created by jaeeun on 2018/01/30.
//  Copyright © 2018年 leejaeeun. All rights reserved.
//

import Foundation
import Alamofire

/*
 API制限
 HTTP API は、以下のとおり呼出回数を制限いたします。
 Private API は 1 分間に約 200 回を上限とします。
 IP アドレスごとに 1 分間に約 500 回を上限とします。
 注文数量が 0.01 以下の注文を大量に発注するユーザーは、一時的に、発注できる注文数が 1 分間に約 10 回までに制限されることがあります。
 システムに負荷をかける目的での発注を繰り返していると当社が判断した場合は、API の使用が制限されることがあります。ご了承ください。
 */

final class BFCoinAPI {
    
    // ホスト名
    private static let host = "https://api.bitflyer.jp/v1"
    
    
    
    // 共通ヘッダー
    static let CommonHeaders:HTTPHeaders = [
        "Authorization": "",
        "Version": Bundle.main.infoDictionary!["CFBundleShortVersionString"]! as! String,
        "Accept": "application/json"
    ]
    
     //リクエスト処理の生成
    private class func createRequest(url:String, parameters: Parameters? = nil) -> Alamofire.DataRequest {
    
        var urlString = "\(host)\(url)"
        var count = 0
        if let paramDict = parameters {
            urlString.append("?")
            for (key, value) in paramDict {
                urlString.append("\(key)=\(value)")
                count = count + 1
                if (count < paramDict.count) {
                    urlString.append("&")
                }
            }
        }
        
        return Alamofire.request(urlString,
                    method:.get,
                    parameters: nil,
                    encoding: JSONEncoding.default,
                    headers: BFCoinAPI.CommonHeaders).validate()
    }
    
    
    
    //マーケットの一覧
    static func requestMarkets(_ completion: @escaping (Array<Market>) ->Void) -> Void {
        
        self.createRequest(url: "/markets", parameters: nil).responseJSON { response in
            
            if let data = response.result.value {
                print("Success with response")
                
                var markets = Array<Market>()
                for dict in data as! [[String:Any]] {
                    let market = Market(dictionary: dict)
                    //print(market)
                    markets.append(market)
                }
                
                completion(markets)
            
            }else{
                print("Error with response")
            }
        }
    }
    
    //板情報
    static func requestBoard(_ productCode: String?, completion: @escaping (Board)->Void) -> Void {
        
        var parameters:[String:Any]? = nil
        
        if let code = productCode {
            parameters = ["product_code":code]
        }
        
        self.createRequest(url: "/board", parameters: parameters).responseJSON { response in
            
            if let data = response.result.value {
                print("Success with response")
                
                guard let dict = data as? Dictionary<String,Any> else {
                    return
                }
                
                let board = Board(dictionary: dict)
                
                completion(board)
                
            }else{
                print("Error with response")
            }
        }
        
    }
    
    //Ticker
    static func requestTicker(_ productCode: String?, completion: @escaping (Ticker)->Void) -> Void {
        
        var parameters : [String:Any]? = nil
        if let code = productCode {
            parameters = ["product_code":code]
        }
        
        self.createRequest(url: "/ticker", parameters: parameters).responseJSON { response in
            
            if let data = response.result.value {
                print("Success with response")
                
                guard let dict = data as? Dictionary<String,Any> else {
                    return
                }
                
                let ticker = Ticker(dictionary: dict)
                
                completion(ticker)
            }else{
                print("Error with response")
            }
        }
        
    }
    
     //約定履歴
    static func requestExecutions(_ productCode: String?, before: String?, after: String?, count: Int?,
                                  completion:@escaping ([Execution])->Void) -> Void {
        
        var parameters : [String:Any]? = nil
        if let code = productCode {
            parameters = ["product_code":code]
        }
        
        /*
         count: 結果の個数を指定します。省略した場合の値は 100 です。
         before: このパラメータに指定した値より小さい id を持つデータを取得します。
         after: このパラメータに指定した値より大きい id を持つデータを取得します。
         */
        self.createRequest(url: "/executions", parameters: parameters).responseJSON { response in
            
            if let data = response.result.value {
                print("Success with response")
                
                guard let items = data as? [Dictionary<String,Any>] else {
                    return
                }
                
                var executions = Array<Execution>()
                for dict in items {
                    let execution = Execution(dictionary: dict)
                    executions.append(execution)
                }
                
                completion(executions)
                
            }else{
                print("Error with response")
            }
        }
        
    }
    
    //板の状態
    static func requestBoardState(_ productCode: String?, completion: @escaping (BoardState)->Void) -> Void {
        
        var parameters : [String:Any]? = nil
        if let code = productCode {
            parameters = ["product_code":code]
        }
        
        self.createRequest(url: "/getboardstate", parameters: parameters).responseJSON { response in
            
            if let data = response.result.value {
                print("Success with response")
                guard let dict = data as? [String:Any] else {
                    return
                }
                
                let boardState = BoardState(dictionary: dict)
                
                completion(boardState)
            }else{
                print("Error with response")
            }
        }
        
    }
    
    //取引所の状態
    static func requestHealth(_ productCode: String?, completion: @escaping (Health)->Void) -> Void {
        
        var parameters : [String:Any]? = nil
        if let code = productCode {
            parameters = ["product_code":code]
        }
        
        self.createRequest(url: "/gethealth", parameters: parameters).responseJSON { response in
            
            if let data = response.result.value {
                print("Success with response")
                
                guard let dict = data as? [String:Any] else {
                    return
                }
                
                let health = Health(dictionary: dict)
                
                completion(health)
                
            }else{
                print("Error with response")
            }
        }
        
    }
    
    //チャット
    static func requestChats(_ fromDate: Date?, completion: @escaping ([Chat])->Void) -> Void {
        
        var parameters : [String:Any]? = nil
        
        if let dateString = fromDate?.dateString() {
            parameters = ["from_date":dateString]
        }
        
        self.createRequest(url: "/getchats", parameters: parameters).responseJSON { response in
            
            if let data = response.result.value {
                print("Success with response")
                
                guard let items = data as? [[String:Any]] else {
                    return
                }
                
                var chats = Array<Chat>()
                for dict in items {
                    let chat = Chat(dictionary: dict)
                    chats.append(chat)
                }
                
                completion(chats)
                
            }else{
                print("Error with response")
            }
        }
        
    }
}

enum SupportChartCoin : String {
    case BTC = "BTC"    //BitCoin
    case ETH = "ETH"    //Ethereum
    case BCH = "BCH"    //BitCoin Cash
}

extension BFCoinAPI {
    
    //Chartホスト名（過去テータ）
    private static let chartHost = "https://min-api.cryptocompare.com/data"
    
    private class func createChrtRequest(url:String) -> Alamofire.DataRequest {
        
        return Alamofire.request("\(chartHost)\(url)",
            method:.get,
            parameters: nil,
            encoding: JSONEncoding.default,
            headers: BFCoinAPI.CommonHeaders).validate()
    }
    
    /*
         Chart APIの説明
        https://www.cryptocompare.com/api/#introduction
     */
    static func requestCharts(_ productCode: String, completion: @escaping (ChartData)->Void) -> Void {

        let valueCount = 24*3 //3日
        let fsym = String(productCode[..<productCode.index(productCode.startIndex, offsetBy: 3)])
        
        if !(fsym == SupportChartCoin.BTC.rawValue
            || fsym == SupportChartCoin.ETH.rawValue
            || fsym == SupportChartCoin.BCH.rawValue) {
                print("not support chart")
                return
        }
        
        
        //https://min-api.cryptocompare.com/data/histohour?fsym=BTC&tsym=JPY&limit=60&aggregate=1&e=BitFlyer
        let parameterString = "fsym=\(fsym)&tsym=JPY&limit=\(valueCount)&aggregate=3&e=BitFlyer"

        //１時間足固定
        self.createChrtRequest(url: "/histohour?\(parameterString)").responseJSON { response in
            if let data = response.result.value {
                print("Success with response")

                guard let dict = data as? [String:Any] else {
                    return
                }
                
                let chartData = ChartData(dictionary: dict)
                
                completion(chartData)

            }else{
                print("Error with response")
            }
        }

    }
}
