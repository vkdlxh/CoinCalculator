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
    
    // MARK: Properties
    var context = BFCoinManager.shared.context
    var tickers: [Ticker] = []
    
    // Calculator
    var isCalculatorHide: Bool = true
    var currentValue = ""
    var leftValue = ""
    var rightValue = ""
    var result = ""
    var currentOperation: Operation = .NULL
    
    // MARK: IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var outputLabel: UILabel!
    @IBOutlet weak var calculatorView: UIView!
    @IBOutlet weak var showCalculatorButton: UIButton!
    @IBOutlet weak var calculatorHeight: NSLayoutConstraint!
    
    // MARK: IBAction
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
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initCalculator()
        
        //Add Observer
        BFCoinManager.shared.addObserver(self)
        getTickersFromManager()
    }
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        if !isCalculatorHide {
            calculatorHeight.constant = self.view.bounds.height / 2
        }
    }
    
    // MARK: Internal Methods
    
    // MARK: Private Methods
    private func getTickersFromManager() {
        let context = BFCoinManager.shared.context
        let sortedTickers = context.tickers.sorted { $0.productCode! < $1.productCode! }
        tickers = sortedTickers
//        tableView.reloadData()
    }
    
    private func initCalculator() {
        outputLabel.text = "0"
        showCalculatorButton.setTitle("△", for: .normal)
        calculatorView.isHidden = true
        calculatorHeight.constant = 0
    }
    
    private func operation(opertaion: Operation) {
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
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CoinInfoSegue" {
            if let destination = segue.destination as? CoinInforViewController {
                if let selectedIndex = self.tableView.indexPathForSelectedRow?.row {
                    destination.productCode = tickers[selectedIndex].productCode
                }
            }
        }
    }

}

// MARK: Extensions
extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tickers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "CoinCell") as? CoinListCell {
            // TODO: Coin ModelをCellに渡す
            cell.ticker = tickers[indexPath.row]
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "CoinInfoSegue", sender: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }

}

extension MainViewController : BFCoinManagerDataChanged {
    
    func coinDataDidLoad(_ context:BFContext) {
        print("context loaded!!")
        //print(context)
    }
    
    func coinDataChanged(channel: Channel, productCode: String, data: Any) {
        print("context changed!!")
        getTickersFromManager()
    }
}

