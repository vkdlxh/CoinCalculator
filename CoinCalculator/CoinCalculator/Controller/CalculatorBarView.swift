//
//  CalculatorBarView.swift
//  CoinCalculator
//
//  Created by jeonsangjun on 2018/02/14.
//  Copyright © 2018年 archive-asia. All rights reserved.
//

import UIKit

class CalculatorBarView: UIView {
    
    var coinName = ""
    var ltp: Int = 0
    var isExchangeOfYenForCoin = false
    
    var ticker: Ticker? {
        didSet {
            if let ticker = ticker {
                if let productCode = ticker.productCode {
                    self.coinName = productCode.convertCodeToName()
                }
                self.ltp = ticker.ltp
            }
        }
    }
    
    @IBOutlet weak var currentExchangeModeLabel: UILabel!
    @IBOutlet weak var exchangedResultLabel: UILabel!
    @IBOutlet weak var inputValueTextField: UITextField!
    
    @IBAction func switchExchangeAction(_ sender: UIButton) {
        switchExchangeMode()
    }
    
    @IBAction func exchangeAction(_ sender: UIButton) {
        if isExchangeOfYenForCoin { // JPY -> BTC
            if let inputValueString = inputValueTextField.text {
                if let inputValueDouble = Double(inputValueString) {
                    let ltpDouble = Double(ltp)
                    let oneYen = 1 / ltpDouble
                    let exchangedValue = inputValueDouble * oneYen
                    let finalValue = String(format:"%.8f", exchangedValue)
                    exchangedResultLabel.text = finalValue
                }
            }
        } else {                    // BTC -> JPY
            if let inputValueString = inputValueTextField.text {
                if let inputValueDouble = Double(inputValueString) {
                    let ltpDouble = Double(ltp)
                    let exchangedValue = Int(inputValueDouble * ltpDouble)
                    
                    let numFormatter : NumberFormatter = NumberFormatter()
                    numFormatter.numberStyle = .decimal
                    let finalValue : String = numFormatter.string(from: NSNumber(value: exchangedValue))!
    
                    exchangedResultLabel.text = "\(finalValue) ￥"
                    
                }
            }
        }
    }

    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        switchExchangeMode()
        
        exchangedResultLabel.layer.masksToBounds = true
        exchangedResultLabel.layer.cornerRadius = 5
        exchangedResultLabel.layer.borderColor = UIColor.lightGray.cgColor
        exchangedResultLabel.layer.borderWidth = 1
        
    }
    
    private func switchExchangeMode() {
        if isExchangeOfYenForCoin { // BTC -> JPY
            currentExchangeModeLabel.text = "\(coinName) → JPY"
            exchangedResultLabel.text = "JPY"
            inputValueTextField.placeholder = "\(coinName)"
            isExchangeOfYenForCoin = false
        } else {                    // JPY -> BTC
            currentExchangeModeLabel.text = "JPY → \(coinName)"
            exchangedResultLabel.text = "\(coinName)"
            inputValueTextField.placeholder = "JPY"
            isExchangeOfYenForCoin = true
        }
    }
 

}
