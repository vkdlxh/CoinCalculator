//
//  MainViewController.swift
//  CoinCalculator
//
//  Created by jeonsangjun on 2018/01/31.
//  Copyright © 2018年 archive-asia. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    var isCalculatorHide: Bool = true
    
    @IBOutlet weak var calculatorView: UIView!
    @IBOutlet weak var calculatorHeight: NSLayoutConstraint!
    
    @IBAction func showCalculatorPressed(_ sender: Any) {
        if isCalculatorHide {
            calculatorHeight.constant = self.view.bounds.height / 2
            isCalculatorHide = false
            calculatorView.isHidden = false
        } else {
            calculatorHeight.constant = 0
            isCalculatorHide = true
            calculatorView.isHidden = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        calculatorView.isHidden = true
        calculatorHeight.constant = 0
    }
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        if !isCalculatorHide {
            calculatorHeight.constant = self.view.bounds.height / 2
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

