//
//  LineChartViewController.swift
//  Chart
//
//  Created by 张泽群 on 2023/3/23.
//

import UIKit

class LineChartViewController: UIViewController {
    @IBOutlet weak var chart: LineChartView!

    override func viewDidLoad() {
        super.viewDidLoad()

        chart.layer.shadowColor = UIColor.black.cgColor
        chart.layer.shadowOffset = CGSize(width: 0, height: 0)
        chart.layer.shadowRadius = 5
        chart.layer.shadowOpacity = 0.1

        let values = [
            LineChartView.DataValue(color: .red, value: [34000, 43000, 44000, 23000, 23432, 12321, 34323, 21412, 43243, 32423, 36433, 23322])
        ]
        let xAxisValues = ["4月", "5月", "6月", "7月", "8月", "9月", "10月", "11月", "12月", "1月", "2月", "3月"]
        let yAxisValues = [50000, 40000, 30000, 20000, 10000, 0]
        chart.dataSet = LineChartView.DataSet(value: values, xAxisValues: xAxisValues, yAxisValues: yAxisValues)
    }
}
