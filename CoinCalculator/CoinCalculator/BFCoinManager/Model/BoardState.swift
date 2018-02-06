//
//  BoardState.swift
//  BFCoinManager
//
//  Created by jaeeun on 2018/01/31.
//  Copyright © 2018年 leejaeeun. All rights reserved.
//

import Foundation

enum HealthType: String {
    case normal      = "NORMAL"      //取引所は稼動しています。
    case busy        = "BUSY"        //取引所に負荷がかかっている状態です。
    case veryBusy    = "VERY BUSY"   //取引所の負荷が大きい状態です。
    case superBusy   = "SUPER BUSY"  //負荷が非常に大きい状態です。発注は失敗するか、遅れて処理される可能性があります。
    case noOrder     = "NO ORDER"    //発注が受付できない状態です。
    case stop        = "STOP"        //取引所は停止しています。発注は受付されません。
}

enum StateType: String {
    case running        = "RUNNING"         //通常稼働中
    case closed         = "CLOSED"          //取引停止中
    case starting       = "STARTING"        //再起動中
    case preopen        = "PREOPEN"         //板寄せ中
    case circuitBreak   = "CIRCUIT BREAK"   //サーキットブレイク発動中
    case awaitingSQ     = "AWAITING SQ"     //Lightning Futures の取引終了後 SQ（清算値）の確定前
    case matured        = "MATURED"         //Lightning Futures の満期に到達
}
/*
 {
 "health": "NORMAL",
 "state": "MATURED",
 "data": {
 "special_quotation": 410897
 }
 */
struct BoardState {
    var health: HealthType?
    var state: StateType?
    var data: [String:Any]?
    
    init(dictionary: Dictionary<String, Any>) {
        
        if let health = dictionary["health"] as? String {
            self.health = HealthType(rawValue: health)
        }
        
        if let state = dictionary["state"] as? String {
            self.state = StateType(rawValue: state)
        }
        
        if let data = dictionary["data"] as? [String:Any] {
            self.data = data
        }
    }
}

