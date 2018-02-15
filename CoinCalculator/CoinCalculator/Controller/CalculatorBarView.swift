//
//  CalculatorBarView.swift
//  CoinCalculator
//
//  Created by jeonsangjun on 2018/02/14.
//  Copyright © 2018年 archive-asia. All rights reserved.
//

import UIKit

class CalculatorBarView: UIView {
    
    var ticker: Ticker? {
        didSet {
            guard let ltp = ticker?.ltp else {
                return
            }
            self.ltp = ltp
        }
    }
    var ltp: Int = 0
//    var isKeyboardShowingByTappingView = false
    
    @IBOutlet weak var coinValueLabel: UILabel!
    @IBOutlet weak var jpyValueTextField: UITextField!
    
    @IBAction func exchangeAction(_ sender: UIButton) {
        // TODO: Exchange JPY -> Coin
        if let jpyString = jpyValueTextField.text {
            if let jpyDouble = Double(jpyString) {
                let ltpDouble = Double(ltp)
                let oneEn = 1 / ltpDouble
                let exchangedValue = jpyDouble * oneEn
                let finalValue = String(format:"%.8f", exchangedValue)
                coinValueLabel.text = finalValue
            }
        }
        
        
        
        
        
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
