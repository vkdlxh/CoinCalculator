//
//  Health.swift
//  BFCoinManager
//
//  Created by jaeeun on 2018/01/31.
//  Copyright © 2018年 leejaeeun. All rights reserved.
//

import Foundation

struct Health {
    var status: HealthType?
    
    init(dictionary: Dictionary<String, Any>) {
        
        if let status = dictionary["status"] as? String {
            self.status = HealthType(rawValue: status)
        }
    }
}
