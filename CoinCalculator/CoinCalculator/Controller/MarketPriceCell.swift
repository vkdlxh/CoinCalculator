//
//  MarketPriceCell.swift
//  CoinCalculator
//
//  Created by jeonsangjun on 2018/02/05.
//  Copyright © 2018年 archive-asia. All rights reserved.
//

import UIKit

class MarketPriceCell: UITableViewCell {
    
    var askRate: Rate? {
        didSet {
            if let askRate = askRate {
                askSizeLabel.text = "\(askRate.size)"
                priceLabel.text = "\(askRate.price)"
                priceLabel.textColor = CCColor().askColor
            }
        }
    }
    
    var midPrice: Int? {
        didSet {
            if let midPrice = midPrice {
                askSizeLabel.text = " "
                priceLabel.text = "\(midPrice)"
                priceLabel.font = UIFont.boldSystemFont(ofSize: 16)
            }
        }
    }
    
    var bidRate: Rate? {
        didSet {
            if let bidRate = bidRate {
                bidSizeLabel.text = "\(bidRate.size)"
                priceLabel.text = "\(bidRate.price)"
                priceLabel.textColor = CCColor().bidColor
            }
        }
    }

    @IBOutlet weak var askSizeLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var bidSizeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        bidSizeLabel.text = nil
        priceLabel.text = nil
        askSizeLabel.text = nil
    }

}
