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
    var midCell = MarketPriceCell()
    var midPrice = 0

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isNoData(false)
        //Add Observer
        BFCoinManager.shared.addObserver(self)
        initCell()
    }

    private func separateBoard() {
        context = BFCoinManager.shared.context
        for board in context.boards {
            if (board[productCode] != nil) {
                if let matchBoard = board[productCode] {
                    askRates = matchBoard.asks
                    bidRates = matchBoard.bids
                    midPrice = matchBoard.midPrice
                }
            }
        }
    }
    
    private func initCell() {
        separateBoard()
        if let askRates = askRates, askRates.isEmpty == false {
            for askRate in askRates {
                if let cell = tableView.dequeueReusableCell(withIdentifier: "MarketPriceCell") as? MarketPriceCell {
                    cell.askRate = askRate
                    askRateCell.append(cell)
                }
            }
            if let cell = tableView.dequeueReusableCell(withIdentifier: "MarketPriceCell") as? MarketPriceCell {
                cell.midPrice = midPrice
                midCell = cell
            }
        } else {
            isNoData(true)
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
        separateBoard()
        if let askRates = askRates, askRates.isEmpty == false {
            for (index, askRate) in askRates.enumerated() {
                askRateCell[index].askRate = askRate
            }
            midCell.midPrice = midPrice
        }
        
        if let bidRates = bidRates {
            for (index, bidRate) in bidRates.enumerated() {
                bidRateCell[index].bidRate = bidRate
            }
        }
    }
    
    private func isNoData(_ bool: Bool) {
        if bool {
            messageLabel.isHidden = false
            tableView.separatorStyle = .none
        } else {
            messageLabel.isHidden = true
            tableView.separatorStyle = .singleLine
        }
        
    }
}

extension MarketViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return askRateCell.count
        case 1:
            return 1
        case 2:
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
            return midCell
        case 2:
            return bidRateCell[indexPath.row]
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
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
