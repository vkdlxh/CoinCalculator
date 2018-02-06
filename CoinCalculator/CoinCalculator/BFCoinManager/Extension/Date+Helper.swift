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
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        return dateFormatter.date(from: string)
    }
}
