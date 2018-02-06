//
//  MarketPriceCell.swift
//  CoinCalculator
//
//  Created by jeonsangjun on 2018/02/05.
//  Copyright © 2018年 archive-asia. All rights reserved.
//

import UIKit

class MarketPriceCell: UITableViewCell {

    @IBOutlet weak var asksSizeLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var bidsSizeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
