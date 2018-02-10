//
//  ChartViewController.swift
//  CoinCalculator
//
//  Created by jeonsangjun on 2018/02/05.
//  Copyright © 2018年 archive-asia. All rights reserved.
//

import UIKit
import Charts

enum Option {
    case toggleValues
    case toggleIcons
    case toggleHighlight
    case animateX
    case animateY
    case animateXY
    case saveToGallery
    case togglePinchZoom
    case toggleAutoScaleMinMax
    case toggleData
    case toggleBarBorders
    // CandleChart
    case toggleShadowColorSameAsCandle
    // CombinedChart
    case toggleLineValues
    case toggleBarValues
    case removeDataSet
    // CubicLineSampleFillFormatter
    case toggleFilled
    case toggleCircles
    case toggleCubic
    case toggleHorizontalCubic
    case toggleStepped
    // HalfPieChartController
    case toggleXValues
    case togglePercent
    case toggleHole
    case spin
    case drawCenter
    // RadarChart
    case toggleXLabels
    case toggleYLabels
    case toggleRotate
    case toggleHighlightCircle
    
    var label: String {
        switch self {
        case .toggleValues: return "Toggle Y-Values"
        case .toggleIcons: return "Toggle Icons"
        case .toggleHighlight: return "Toggle Highlight"
        case .animateX: return "Animate X"
        case .animateY: return "Animate Y"
        case .animateXY: return "Animate XY"
        case .saveToGallery: return "Save to Camera Roll"
        case .togglePinchZoom: return "Toggle PinchZoom"
        case .toggleAutoScaleMinMax: return "Toggle auto scale min/max"
        case .toggleData: return "Toggle Data"
        case .toggleBarBorders: return "Toggle Bar Borders"
        // CandleChart
        case .toggleShadowColorSameAsCandle: return "Toggle shadow same color"
        // CombinedChart
        case .toggleLineValues: return "Toggle Line Values"
        case .toggleBarValues: return "Toggle Bar Values"
        case .removeDataSet: return "Remove Random Set"
        // CubicLineSampleFillFormatter
        case .toggleFilled: return "Toggle Filled"
        case .toggleCircles: return "Toggle Circles"
        case .toggleCubic: return "Toggle Cubic"
        case .toggleHorizontalCubic: return "Toggle Horizontal Cubic"
        case .toggleStepped: return "Toggle Stepped"
        // HalfPieChartController
        case .toggleXValues: return "Toggle X-Values"
        case .togglePercent: return "Toggle Percent"
        case .toggleHole: return "Toggle Hole"
        case .spin: return "Spin"
        case .drawCenter: return "Draw CenterText"
        // RadarChart
        case .toggleXLabels: return "Toggle X-Labels"
        case .toggleYLabels: return "Toggle Y-Labels"
        case .toggleRotate: return "Toggle Rotate"
        case .toggleHighlightCircle: return "Toggle highlight circle"
        }
    }
}

class ChartViewController: UIViewController, ChartViewDelegate {
    
    open var productCode : String?
    
    @IBOutlet var chartView: CandleStickChartView!
    
    private var options: [Option]!
    private var shouldHideData: Bool = false
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initialize()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.initialize()
    }
    
    private func initialize() {
        self.edgesForExtendedLayout = []
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.title = "Chart"
        
        self.initializeChart()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let product_code = self.productCode else {
            chartView.data = nil
            return
        }
        
        BFCoinAPI.requestCharts(product_code) { (chartData) in
            
            self.updateChartData(chartData)
            for set in self.chartView.data!.dataSets as! [CandleChartDataSet] {
                set.shadowColorSameAsCandle = !set.shadowColorSameAsCandle
            }
            
            self.chartView.notifyDataSetChanged()
        }
    }
    
    func updateChartData(_ data:ChartData) {
        
        if self.shouldHideData {
            chartView.data = nil
            return
        }
        
        let yVals1 = (0..<data.items.count).map { (i) -> CandleChartDataEntry in
            
            let chartValue = data.items[i]
            
            let high = Double(chartValue.high)
            let low = Double(chartValue.low)
            let open = Double(chartValue.open)
            let close = Double(chartValue.close)
            
//            Double(chartValue.time)
            return CandleChartDataEntry(x: Double(i),
                                        shadowH: high,
                                        shadowL: low,
                                        open: open,
                                        close: close,
                                        icon: nil)
        }
        
        let set1 = CandleChartDataSet(values: yVals1, label: nil)
        set1.axisDependency = .right
        set1.setColor(UIColor(white: 80/255, alpha: 1))
        set1.drawIconsEnabled = false
        set1.shadowColor = .darkGray
        set1.shadowWidth = 0.7
        set1.decreasingColor = .blue
        set1.decreasingFilled = true
        set1.increasingColor = .red
        set1.increasingFilled = true
        set1.neutralColor = .blue
        set1.drawValuesEnabled = false
        let data = CandleChartData(dataSet: set1)
        chartView.data = data
    }
    
    //MARK: Private methods
    private func initializeChart() {
        
        self.options = [
//            .toggleValues,
            //.toggleIcons,
            //.toggleHighlight,
            .animateX,
            .animateY,
            .animateXY,
            //.saveToGallery,
//            .togglePinchZoom,
//            .toggleAutoScaleMinMax,
            //.toggleShadowColorSameAsCandle,
            //.toggleData
        ]
        
        chartView.delegate = self
        chartView.chartDescription?.enabled = true
        chartView.chartDescription?.text = "１時間足"
        chartView.drawGridBackgroundEnabled = false
        chartView.dragEnabled = true
        chartView.setScaleEnabled(true)
        chartView.maxVisibleCount = 100
        chartView.pinchZoomEnabled = true
        
//        chartView.legend.horizontalAlignment = .right
//        chartView.legend.verticalAlignment = .top
//        chartView.legend.orientation = .vertical
//        chartView.legend.drawInside = false
//        chartView.legend.font = UIFont(name: "HelveticaNeue-Light", size: 10)!
        chartView.legend.enabled = false
        
        chartView.rightAxis.labelFont = UIFont(name: "HelveticaNeue-Light", size: 10)!
        chartView.rightAxis.spaceTop = 0
        chartView.rightAxis.spaceBottom = 0.5
        chartView.rightAxis.axisMinimum = 0
        chartView.leftAxis.enabled = false
        
        chartView.xAxis.labelPosition = .bottom
        chartView.xAxis.labelFont = UIFont(name: "HelveticaNeue-Light", size: 10)!
        chartView.xAxis.drawLabelsEnabled = false
        
        chartView.xAxis.drawGridLinesEnabled = false
        chartView.xAxis.gridColor = NSUIColor.gray.withAlphaComponent(0.3)

    }
    
}

