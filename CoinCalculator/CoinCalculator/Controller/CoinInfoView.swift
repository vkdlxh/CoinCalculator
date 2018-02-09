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
            let ltp = ticker.ltp == 0 ? "-" : "\(ticker.ltp)"
            ltpLabel.text = ltp
            let bestBid = ticker.bestBid == 0 ? "-" : "\(ticker.bestBid)"
            bestBidLabel.text = bestBid
            let bestBidSize = ticker.bestBidSize == 0 ? "-" : "\(ticker.bestBidSize)"
            bestBidSizeLabel.text = bestBidSize
            let bestAsk = ticker.bestAsk == 0 ? "-" : "\(ticker.bestAsk)"
            bestAskLabel.text = bestAsk
            let bestAskSize = ticker.bestAskSize == 0 ? "-" : "\(ticker.bestAskSize)"
            bestAskSizeLabel.text = bestAskSize
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
