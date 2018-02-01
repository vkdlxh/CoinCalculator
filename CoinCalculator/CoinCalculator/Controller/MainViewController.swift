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
    
    @IBOutlet weak var calculatorHeight: NSLayoutConstraint!
    
    @IBAction func showCalculatorPressed(_ sender: Any) {
        if isCalculatorHide {
            calculatorHeight.constant = self.view.bounds.height / 2
            isCalculatorHide = false
        } else {
            calculatorHeight.constant = 0
            isCalculatorHide = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        calculatorHeight.constant = 0
    }

}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "CoinCell") as? CoinListCell {
            
            
            return cell
        }
        return UITableViewCell()
    }
    
    
}

