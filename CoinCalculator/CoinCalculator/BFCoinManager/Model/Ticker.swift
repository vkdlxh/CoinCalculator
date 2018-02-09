//
//  Ticker.swift
//  BFCoinManager
//
//  Created by jaeeun on 2018/01/31.
//  Copyright © 2018年 leejaeeun. All rights reserved.
//

import Foundation

/*
 {"product_code": "BTC_JPY",
 "timestamp": "2015-07-08T02:50:59.97",
 "tick_id": 3579,
 "best_bid": 30000,
 "best_ask": 36640,
 "best_bid_size": 0.1,
 "best_ask_size": 5,
 "total_bid_depth": 15.13,
 "total_ask_depth": 20,
 "ltp": 31690,
 "volume": 16819.26,
 "volume_by_product": 6819.26}
 */
struct Ticker {
    var productCode :String?
//    var timestamp   :Date?
    var timestamp: String?
    var tickId :UInt64  = 0
    var bestBid         = 0
    var bestAsk         = 0
    var bestBidSize     = 0.0
    var bestAskSize     = 0.0
    var totalBidDepth   = 0.0
    var totalAskDepth   = 0.0
    var ltp             = 0
    var volume          = 0.0
    var volumeByProduct = 0.0

    init(dictionary: Dictionary<String, Any>) {
        
        if let product_code = dictionary["product_code"] as? String {
            self.productCode = product_code
        }
        
        if let timestamp = dictionary["timestamp"] as? String {
//            if let date = Date.stringDate(timestamp) {
//                self.timestamp = date
//            }
            let date = Date.stringToString(timestamp)
            self.timestamp = date
        }
        
        if let tick_id = dictionary["tick_id"] as? UInt64 {
            self.tickId = tick_id
        }
        
        if let best_bid = dictionary["best_bid"] as? Int {
            self.bestBid = best_bid
        }
        
        if let best_ask = dictionary["best_ask"] as? Int {
            self.bestAsk = best_ask
        }
        
        if let best_bid_size = dictionary["best_bid_size"] as? Double {
            self.bestBidSize = best_bid_size
        }
        
        if let best_ask_size = dictionary["best_ask_size"] as? Double {
            self.bestAskSize = best_ask_size
        }
        
        if let total_bid_depth = dictionary["total_bid_depth"] as? Double {
            self.totalBidDepth = total_bid_depth
        }
        
        if let total_ask_depth = dictionary["total_ask_depth"] as? Double {
            self.totalAskDepth = total_ask_depth
        }
        
        if let ltp = dictionary["ltp"] as? Int {
            self.ltp = ltp
        }
        
        if let volume = dictionary["volume"] as? Double {
            self.volume = volume
        }
        
        if let volume_by_product = dictionary["volume_by_product"] as? Double {
            self.volumeByProduct = volume_by_product
        }
        
    }
    
}
