//
//  CalculatorButton.swift
//  CoinCalculator
//
//  Created by jeonsangjun on 2018/02/01.
//  Copyright © 2018年 archive-asia. All rights reserved.
//

import UIKit

@IBDesignable
class CalculatorButton: UIButton {
    @IBInspectable var buttonBorder: Bool = false {
        didSet {
            if buttonBorder {
                layer.borderWidth = 0.5
                layer.borderColor = UIColor.black.cgColor
            }
        }
    }
    
    
    override func prepareForInterfaceBuilder() {
        if buttonBorder {
            layer.borderWidth = 0.5
            layer.borderColor = UIColor.black.cgColor
        }
    }
}
