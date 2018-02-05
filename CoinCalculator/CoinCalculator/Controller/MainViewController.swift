//
//  MainViewController.swift
//  CoinCalculator
//
//  Created by jeonsangjun on 2018/01/31.
//  Copyright © 2018年 archive-asia. All rights reserved.
//

import UIKit

enum Operation: String {
    case Add = "+"
    case Subtract = "-"
    case Multiply = "*"
    case Divide = "/"
    case NULL = "Null"
}

class MainViewController: UIViewController {
    
    var isCalculatorHide: Bool = true
    var currentValue = ""
    var leftValue = ""
    var rightValue = ""
    var result = ""
    var currentOperation: Operation = .NULL
    
    @IBOutlet weak var outputLabel: UILabel!
    @IBOutlet weak var calculatorView: UIView!
    @IBOutlet weak var showCalculatorButton: UIButton!
    @IBOutlet weak var calculatorHeight: NSLayoutConstraint!
    
    
    @IBAction func numberPressed(_ sender: CalculatorButton) {
        currentValue += "\(sender.tag)"
        outputLabel.text = currentValue
    }
    
    @IBAction func allClearPressed(_ sender: CalculatorButton) {
        currentValue = ""
        leftValue = ""
        rightValue = ""
        result = ""
        currentOperation = .NULL
        outputLabel.text = "0"
    }
    @IBAction func dotPressed(_ sender: CalculatorButton) {
         if outputLabel.text == "0" {
            currentValue = "0."
        } else if outputLabel.text?.range(of: ".") == nil {
            currentValue += "."
        }
        outputLabel.text = currentValue
        
    }
    @IBAction func equalPressed(_ sender: CalculatorButton) {
        operation(opertaion: currentOperation)
    }
    @IBAction func addPressed(_ sender: CalculatorButton) {
        operation(opertaion: .Add)
    }
    @IBAction func subtractPressed(_ sender: CalculatorButton) {
        operation(opertaion: .Subtract)
    }
    @IBAction func multiplyPressed(_ sender: CalculatorButton) {
        operation(opertaion: .Multiply)
    }
    @IBAction func dividePressed(_ sender: CalculatorButton) {
        operation(opertaion: .Divide)
    }
    
    @IBAction func showCalculatorPressed(_ sender: Any) {
        if isCalculatorHide {
            showCalculatorButton.setTitle("▽", for: .normal)
            calculatorHeight.constant = self.view.bounds.height / 2
            isCalculatorHide = false
            calculatorView.isHidden = false
        } else {
            showCalculatorButton.setTitle("△", for: .normal)
            calculatorHeight.constant = 0
            isCalculatorHide = true
            calculatorView.isHidden = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initCalculator()
    }
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        if !isCalculatorHide {
            calculatorHeight.constant = self.view.bounds.height / 2
        }
    }
    
    func initCalculator() {
        outputLabel.text = "0"
        showCalculatorButton.setTitle("△", for: .normal)
        calculatorView.isHidden = true
        calculatorHeight.constant = 0
    }
    
    func operation(opertaion: Operation) {
        if currentOperation != .NULL {
            if currentValue != "" {
                rightValue = currentValue
                currentValue = ""
                
                if currentOperation == .Add {
                    result = "\(Double(leftValue)! + Double(rightValue)!)"
                } else if currentOperation == .Subtract {
                    result = "\(Double(leftValue)! - Double(rightValue)!)"
                } else if currentOperation == .Multiply {
                    result = "\(Double(leftValue)! * Double(rightValue)!)"
                } else if currentOperation == .Divide {
                    result = "\(Double(leftValue)! / Double(rightValue)!)"
                }
                leftValue = result
                if (Double(result)!.truncatingRemainder(dividingBy: 1) == 0) {
                    result = "\(Int(Double(result)!))"
                }
                outputLabel.text = result
            }
            currentOperation = opertaion
        } else {
            if currentValue == "" {
                currentValue = "0"
            }
            leftValue = currentValue
            currentValue = ""
            currentOperation = opertaion
            
        }
        
    }

}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "CoinCell") as? CoinListCell {
            // TODO: Coin ModelをCellに渡す
            
            return cell
        }
        return UITableViewCell()
    }
    
    
}

