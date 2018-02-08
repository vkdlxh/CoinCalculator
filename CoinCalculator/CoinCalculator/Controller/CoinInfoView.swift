//
//  CoinInfoView.swift
//  CoinCalculator
//
//  Created by jeonsangjun on 2018/02/08.
//  Copyright © 2018年 archive-asia. All rights reserved.
//

import UIKit

class CoinInfoView: UIView {
    
    var ticker: Ticker? {
        didSet {
            guard let ticker = ticker else {
                return
            }
            ltpLabel.text = "\(ticker.ltp)"
            bestBidLabel.text = "\(ticker.bestBid)"
            bestBidSizeLabel.text = "\(ticker.bestBidSize)"
            bestAskLabel.text = "\(ticker.bestAsk)"
            bestAskSizeLabel.text = "\(ticker.bestAskSize)"
            if let timestamp = ticker.timestamp {
                timestampLabel.text = "\(timestamp)"
            }
            
        }
    }
    
    @IBOutlet weak var ltpLabel: UILabel!
    @IBOutlet weak var bestBidLabel: UILabel!
    @IBOutlet weak var bestBidSizeLabel: UILabel!
    @IBOutlet weak var bestAskLabel: UILabel!
    @IBOutlet weak var bestAskSizeLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
