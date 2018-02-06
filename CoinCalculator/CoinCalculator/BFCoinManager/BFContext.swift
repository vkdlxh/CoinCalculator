//
//  BFContext.swift
//  BFCoinManager
//
//  Created by jaeeun on 2018/02/03.
//  Copyright © 2018年 leejaeeun. All rights reserved.
//

import Foundation

struct BFContext {
    
    static let maxRateCount = 20
    static let maxExecutionCount = 100
    
    var markets     = [Market]()
    var boards      = [[String:Board]]()
    var tickers     = [Ticker]()
    var executions  = [String:[Execution]]()
    var boardStates = [String:BoardState]()
    var healths     = [String:Health]()
    var chats       = [Chat]()
}
