//
//  ChartData.swift
//  BFCoinManager
//
//  Created by jaeeun on 2018/02/05.
//  Copyright © 2018年 leejaeeun. All rights reserved.
//

import Foundation

/*
 ["Response": Success,
     "TimeTo": 1517756400,
     "FirstValueInArray": 1,
     "TimeFrom": 1517749200,
     "Data":
         {
         close = 928500;
         high = 936610;
         low = 917860;
         open = 927990;
         time = 1517749200;
         volumefrom = "1596.97";
         volumeto = "1479342231.46"
         },
         {
         close = 921765;
         high = 946770;
         low = 918001;
         open = 928500;
         time = 1517752800;
         volumefrom = "1488.94";
         volumeto = "1387672662.22"
 },
     "Aggregated": 0,
     "Type": 100,
     "ConversionType": {
         conversionSymbol = "";
         type = "force_direct"}]
 */
struct ChartData {
    var timeTo: Int?
    var timeFrom: Int?
    var items = [ChartValue]()
    
    init(dictionary: Dictionary<String, Any>) {
        
        if let timeTo = dictionary["TimeTo"] as? Int {
            self.timeTo = timeTo
        }
        
        if let timeFrom = dictionary["TimeFrom"] as? Int {
            self.timeFrom = timeFrom
        }
        
        if let chartValues = dictionary["Data"] as? [[String:Any]] {
            
            for dict in chartValues {
                let value = ChartValue(dictionary: dict)
                items.append(value)
            }
        }
    }
}

struct ChartValue {
    
    var close: Int = 0
    var high: Int = 0
    var low: Int = 0
    var open: Int = 0
    var time: Int = 0
    var volumefrom: Double = 0.0
    var volumeto: Double = 0.0
    
    init(dictionary: Dictionary<String, Any>) {
        
        if let close = dictionary["close"] as? Int {
            self.close = close
        }
        
        if let high = dictionary["high"] as? Int {
            self.high = high
        }
        
        if let low = dictionary["low"] as? Int {
            self.low = low
        }
        
        if let open = dictionary["open"] as? Int {
            self.open = open
        }
        
        if let time = dictionary["time"] as? Int {
            self.time = time
        }
        
        if let volumefrom = dictionary["volumefrom"] as? Double {
            self.volumefrom = volumefrom
        }
        
        if let volumeto = dictionary["volumeto"] as? Double {
            self.volumeto = volumeto
        }
        
    }
}
