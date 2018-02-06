//
//  MarketViewController.swift
//  CoinCalculator
//
//  Created by jeonsangjun on 2018/02/05.
//  Copyright © 2018年 archive-asia. All rights reserved.
//

import UIKit

class MarketViewController: UIViewController {
    
    var productCode: String?
    var context = BFCoinManager.shared.context
    var askRates: [Rate]?
    var bidRates: [Rate]?

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Add Observer
        BFCoinManager.shared.addObserver(self)
        separateAskAndBid()
    }

    func separateAskAndBid() {
        context = BFCoinManager.shared.context
        for board in context.boards {
            if (board[productCode!] != nil) {
                let matchBoard = board[productCode!]
                askRates = matchBoard?.asks
                bidRates = matchBoard?.bids
            }
        }
        tableView.reloadData()
    }
    

}

extension MarketViewController: UITabBarDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            guard let askRatesCount = askRates?.count else {
                return 0
            }
            return askRatesCount
        case 1:
            guard let bidRatesCount = bidRates?.count else {
                return 0
            }
            return bidRatesCount
        default:
            return 0
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "MarketPriceCell") as? MarketPriceCell {
            switch indexPath.section {
            case 0:
                if let askRate = askRates?[indexPath.row] {
                    cell.askRate = askRate
                    return cell
                }
            case 1:
                if let bidRate = bidRates?[indexPath.row] {
                    cell.bidRate = bidRate
                    return cell
                }
            default:
                break
            }
            
        }
        return UITableViewCell()
    }
    
}

extension MarketViewController : BFCoinManagerDataChanged {
    
    func coinDataDidLoad(_ context:BFContext) {
        print("context loaded!!")
        //print(context)
    }
    
    func coinDataChanged(channel: Channel, productCode: String, data: Any) {
        print("context changed!!")
        separateAskAndBid()
    }
}
