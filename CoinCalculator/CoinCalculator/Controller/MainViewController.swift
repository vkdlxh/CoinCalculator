//
//  MainViewController.swift
//  CoinCalculator
//
//  Created by jeonsangjun on 2018/01/31.
//  Copyright © 2018年 archive-asia. All rights reserved.
//

import UIKit


class MainViewController: UIViewController {
    
    // MARK: Properties
    var context = BFCoinManager.shared.context
    var tickers: [Ticker] = []
    var cells: [CoinListCell] = []
    
    let cautionMessage = "アプリが表示する情報は参考用です。"
    var mutableString = NSMutableAttributedString()
    
    // MARK: IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var cautionMessageLabel: UILabel!
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Add Observer
        BFCoinManager.shared.addObserver(self)
        initCells()
        
        mutableString = NSMutableAttributedString(string: cautionMessage)
        mutableString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.darkGray, range: NSRange(location:0,length:cautionMessage.count))
        mutableString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.red, range: NSRange(location:11,length:3))
        cautionMessageLabel.attributedText = mutableString
    }
    
    // MARK: Internal Methods
    
    // MARK: Private Methods
    private func getTickersFromManager() {
        let context = BFCoinManager.shared.context
        let sortedTickers = context.tickers.sorted { $0.productCode! < $1.productCode! }
        tickers = sortedTickers
    }
    
    private func initCells() {
        getTickersFromManager()
        for ticker in tickers {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "CoinCell") as? CoinListCell {
                cell.ticker = ticker
                cells.append(cell)
            }
        }
    }
    
    private func updateCell() {
        getTickersFromManager()
        for (index, ticker) in tickers.enumerated() {
            cells[index].ticker = ticker
        }
    }
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CoinInfoSegue" {
            if let destination = segue.destination as? CoinInforViewController {
                if let selectedIndex = self.tableView.indexPathForSelectedRow?.row {
                    destination.productCode = tickers[selectedIndex].productCode!
                }
            }
        }
    }

}

// MARK: Extensions
extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cells[indexPath.row]
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
        updateCell()
    }
}

