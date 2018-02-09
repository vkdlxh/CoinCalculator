//
//  String+Converter.swift
//  CoinCalculator
//
//  Created by jeonsangjun on 2018/02/09.
//  Copyright © 2018年 archive-asia. All rights reserved.
//

import Foundation

enum CoinType: String {
    case BTC_JPY
    case ETH_BTC
}

extension String {
    func convertCodeToName() -> String {
        
        if self == CoinType.BTC_JPY.rawValue {
            return "BitCoin"
        } else if self == CoinType.ETH_BTC.rawValue {
            return "Ethereum"
        } else {
            return self
        }
    }
}
