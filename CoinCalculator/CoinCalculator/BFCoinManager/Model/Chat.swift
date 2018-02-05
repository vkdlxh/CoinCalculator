//
//  Chat.swift
//  BFLCoinManager
//
//  Created by jaeeun on 2018/01/31.
//  Copyright © 2018年 leejaeeun. All rights reserved.
//

import Foundation

/*
 {
 "nickname": "User1234567",
 "message": "Hello world!",
 "date": "2016-02-16T10:58:08.833"
 }
 */
struct Chat {
    var nickname: String?
    var message: String?
    var chatDate: Date?
    
    init(dictionary: Dictionary<String, Any>) {
        
        if let nickname = dictionary["nickname"] as? String {
            self.nickname = nickname
        }
        
        if let message = dictionary["message"] as? String {
            self.message = message
        }
        
        if let date = dictionary["date"] as? String {
            if let chat_date = Date.stringDate(date) {
                self.chatDate = chat_date
            }
        }
    }
}
