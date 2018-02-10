//
//  CoinInforViewController.swift
//  CoinCalculator
//
//  Created by jeonsangjun on 2018/02/05.
//  Copyright © 2018年 archive-asia. All rights reserved.
//

import UIKit

class CoinInforViewController: UIViewController {

    var productCode = ""
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var marketView: UIView!
    @IBOutlet weak var chartView: UIView!
    @IBOutlet weak var coinInfoView: CoinInfoView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = productCode
        
        setupSegmentedControl()
        //Add Observer
        BFCoinManager.shared.addObserver(self)
        updateCoinInfoView()
        
        // child chart
//        if let chartViewController = UIStoryboard(name: "Chart", bundle: nil).instantiateInitialViewController() as? ChartViewController {
//            self.addContentController(chartViewController)
//        }
        
    }
    
    private func updateCoinInfoView() {
        let context = BFCoinManager.shared.context
        for ticker in context.tickers {
            if ticker.productCode == self.productCode {
               coinInfoView.ticker = ticker
            }
        }
    }
    
    private func setupSegmentedControl() {
        // Configure Segmented Control
        segmentedControl.removeAllSegments()
        segmentedControl.insertSegment(withTitle: "気配", at: 0, animated: false)
        segmentedControl.insertSegment(withTitle: "チャート", at: 1, animated: false)
        segmentedControl.addTarget(self, action: #selector(selectionDidChange(_:)), for: .valueChanged)
        
        // Select First Segment
        segmentedControl.selectedSegmentIndex = 0
    }
    
    private func addContentController(_ content:UIViewController) {
        self.addChildViewController(content)
        self.view.addSubview(content.view)
        
        content.didMove(toParentViewController: self)
    }
    
    @objc private func selectionDidChange(_ sender: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            marketView.isHidden = false
            chartView.isHidden = true
            
            marketView.didMoveToWindow()
        case 1:
            marketView.isHidden = true
            chartView.isHidden = false
            
            chartView.didMoveToWindow()
            
        default:
            break;
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "marketSegue" {
            if let destination = segue.destination as? MarketViewController {
                destination.productCode = productCode
            }
        }else if segue.identifier == "chartSegue" {
            if let destination = segue.destination as? ChartViewController {
                destination.productCode = productCode
            }
        }
    }

}

extension CoinInforViewController: BFCoinManagerDataChanged {
    func coinDataDidLoad(_ context:BFContext) {
        print("context loaded!!")
        //print(context)
    }
    
    func coinDataChanged(channel: Channel, productCode: String, data: Any) {
        print("context changed!!")
        updateCoinInfoView()
    }
}
