//
//  MarketViewController.swift
//  CoinCalculator
//
//  Created by jeonsangjun on 2018/02/05.
//  Copyright © 2018年 archive-asia. All rights reserved.
//

import UIKit

class MarketViewController: UIViewController {
    
    var productCode = ""
    var context = BFCoinManager.shared.context
    var askRates: [Rate]?
    var bidRates: [Rate]?
    var askRateCell: [MarketPriceCell] = []
    var bidRateCell: [MarketPriceCell] = []

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Add Observer
        BFCoinManager.shared.addObserver(self)
        initCell()
    }

    private func separateAskAndBid() {
        context = BFCoinManager.shared.context
        for board in context.boards {
            if (board[productCode] != nil) {
                let matchBoard = board[productCode]
                askRates = matchBoard?.asks
                bidRates = matchBoard?.bids
            }
        }
    }
    
    private func initCell() {
        separateAskAndBid()
        if let askRates = askRates {
            for askRate in askRates {
                if let cell = tableView.dequeueReusableCell(withIdentifier: "MarketPriceCell") as? MarketPriceCell {
                    cell.askRate = askRate
                    askRateCell.append(cell)
                }
            }
        }
        if let bidRates = bidRates {
            for bidRate in bidRates {
                if let cell = tableView.dequeueReusableCell(withIdentifier: "MarketPriceCell") as? MarketPriceCell {
                    cell.bidRate = bidRate
                    bidRateCell.append(cell)
                }
            }
        }
    }
    
    private func updateCell() {
        separateAskAndBid()
        if let askRates = askRates {
            for (index, askRate) in askRates.enumerated() {
                askRateCell[index].askRate = askRate
            }
        }
        if let bidRates = bidRates {
            for (index, bidRate) in bidRates.enumerated() {
                bidRateCell[index].bidRate = bidRate
            }
        }
    }
    

}

extension MarketViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return askRateCell.count
        case 1:
            return bidRateCell.count
        default:
            return 0
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            return askRateCell[indexPath.row]
        case 1:
            return bidRateCell[indexPath.row]
        default:
            return UITableViewCell()
        }
    }
}

extension MarketViewController : BFCoinManagerDataChanged {
    
    func coinDataDidLoad(_ context:BFContext) {
        print("context loaded!!")
        //print(context)
    }
    
    func coinDataChanged(channel: Channel, productCode: String, data: Any) {
        print("context changed!!")
        updateCell()
    }
}
