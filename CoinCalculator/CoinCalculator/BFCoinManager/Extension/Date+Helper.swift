//
//  Date+Helper.swift
//  BFCoinManager
//
//  Created by jaeeun on 2018/02/03.
//  Copyright © 2018年 leejaeeun. All rights reserved.
//

import Foundation

extension Date {
    
    func dateString()-> String {
        //"2018-02-03T02:28:43.247"
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        return dateFormatter.string(from: self)
    }
    
    static func stringDate(_ string:String)-> Date? {
        var newString = string
        if newString.last == "Z" {
            newString.removeLast()
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        
//        var finalDate: Date?
//        if let date = dateFormatter.date(from:string) {
//            let calendar = Calendar.current
//            let components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
//            finalDate = calendar.date(from:components)
//        } else {
//            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
//            if let date = dateFormatter.date(from:string) {
//                let calendar = Calendar.current
//                let components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
//                finalDate = calendar.date(from:components)
//            }
//        }
//        return finalDate
        return dateFormatter.date(from: newString)
    }
    
    // TEST
    static func stringToString(_ string:String) -> String {
        var newString = string
        // 違う形式のフォーマットを同じく作る
        if newString.last == "Z" {
            newString.removeLast()
        }
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        let date = dateFormatter.date(from: newString)
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        
        return dateFormatter.string(from: date!)
        
    }
}
