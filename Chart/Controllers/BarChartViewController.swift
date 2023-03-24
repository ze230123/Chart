//
//  BarChartViewController.swift
//  Chart
//
//  Created by 张泽群 on 2023/3/24.
//

import UIKit

class BarChartViewController: UIViewController {
    @IBOutlet weak var chart: BarChartView!

    override func viewDidLoad() {
        super.viewDidLoad()
        chart.layer.shadowColor = UIColor.black.cgColor
        chart.layer.shadowOffset = CGSize(width: 0, height: 0)
        chart.layer.shadowRadius = 5
        chart.layer.shadowOpacity = 0.1

        let xAxisValues = [
            BarChartView.DataValue(label: "4月", values: [
                BarChartView.DataValue.Value(scale: 0.1, color: .cF4F4F4),
                BarChartView.DataValue.Value(scale: 0.2, color: .cF4F4F4),
                BarChartView.DataValue.Value(scale: 0.3, color: .cF4F4F4),
                BarChartView.DataValue.Value(scale: 0.2, color: .cF4F4F4),
                BarChartView.DataValue.Value(scale: 0.2, color: .cF4F4F4)
            ]),
            BarChartView.DataValue(label: "5月", values: [
                BarChartView.DataValue.Value(scale: 0.1, color: .cFFA092),
                BarChartView.DataValue.Value(scale: 0.15, color: .cFEE25E),
                BarChartView.DataValue.Value(scale: 0.3, color: .c5F8FFF),
                BarChartView.DataValue.Value(scale: 0.15, color: .c44D7B6),
                BarChartView.DataValue.Value(scale: 0.3, color: .cFFB968)
            ]),
            BarChartView.DataValue(label: "6月", values: [
                BarChartView.DataValue.Value(scale: 0.1, color: .cFFA092),
                BarChartView.DataValue.Value(scale: 0.15, color: .cFEE25E),
                BarChartView.DataValue.Value(scale: 0.3, color: .c5F8FFF),
                BarChartView.DataValue.Value(scale: 0.15, color: .c44D7B6),
                BarChartView.DataValue.Value(scale: 0.3, color: .cFFB968)
            ]),
            BarChartView.DataValue(label: "7月", values: [
                BarChartView.DataValue.Value(scale: 0.1, color: .cFFA092),
                BarChartView.DataValue.Value(scale: 0.15, color: .cFEE25E),
                BarChartView.DataValue.Value(scale: 0.3, color: .c5F8FFF),
                BarChartView.DataValue.Value(scale: 0.15, color: .c44D7B6),
                BarChartView.DataValue.Value(scale: 0.3, color: .cFFB968)
            ]),
            BarChartView.DataValue(label: "8月", values: [
                BarChartView.DataValue.Value(scale: 0.1, color: .cFFA092),
                BarChartView.DataValue.Value(scale: 0.15, color: .cFEE25E),
                BarChartView.DataValue.Value(scale: 0.3, color: .c5F8FFF),
                BarChartView.DataValue.Value(scale: 0.15, color: .c44D7B6),
                BarChartView.DataValue.Value(scale: 0.3, color: .cFFB968)

            ]),
            BarChartView.DataValue(label: "9月", values: [
                BarChartView.DataValue.Value(scale: 0.05, color: .cFFA092),
                BarChartView.DataValue.Value(scale: 0.2, color: .cFEE25E),
                BarChartView.DataValue.Value(scale: 0.5, color: .c5F8FFF),
                BarChartView.DataValue.Value(scale: 0.1, color: .c44D7B6),
                BarChartView.DataValue.Value(scale: 0.15, color: .cFFB968)
            ]),
            BarChartView.DataValue(label: "10月", values: [
                BarChartView.DataValue.Value(scale: 0, color: .cFFA092),
                BarChartView.DataValue.Value(scale: 0.1, color: .cFEE25E),
                BarChartView.DataValue.Value(scale: 0.4, color: .c5F8FFF),
                BarChartView.DataValue.Value(scale: 0.15, color: .c44D7B6),
                BarChartView.DataValue.Value(scale: 0.35, color: .cFFB968)
            ]),
            BarChartView.DataValue(label: "11月", values: [
                BarChartView.DataValue.Value(scale: 0, color: .cFFA092),
                BarChartView.DataValue.Value(scale: 0.15, color: .cFEE25E),
                BarChartView.DataValue.Value(scale: 0.35, color: .c5F8FFF),
                BarChartView.DataValue.Value(scale: 0.35, color: .c44D7B6),
                BarChartView.DataValue.Value(scale: 0.15, color: .cFFB968)
            ]),
            BarChartView.DataValue(label: "12月", values: [
                BarChartView.DataValue.Value(scale: 0, color: .cFFA092),
                BarChartView.DataValue.Value(scale: 0.15, color: .cFEE25E),
                BarChartView.DataValue.Value(scale: 0.3, color: .c5F8FFF),
                BarChartView.DataValue.Value(scale: 0.25, color: .c44D7B6),
                BarChartView.DataValue.Value(scale: 0.3, color: .cFFB968)
            ]),
            BarChartView.DataValue(label: "1月", values: [
                BarChartView.DataValue.Value(scale: 0.1, color: .cFFA092),
                BarChartView.DataValue.Value(scale: 0.15, color: .cFEE25E),
                BarChartView.DataValue.Value(scale: 0.3, color: .c5F8FFF),
                BarChartView.DataValue.Value(scale: 0.15, color: .c44D7B6),
                BarChartView.DataValue.Value(scale: 0.3, color: .cFFB968)
            ]),
            BarChartView.DataValue(label: "2月", values: [
                BarChartView.DataValue.Value(scale: 0.1, color: .cFFA092),
                BarChartView.DataValue.Value(scale: 0.15, color: .cFEE25E),
                BarChartView.DataValue.Value(scale: 0.3, color: .c5F8FFF),
                BarChartView.DataValue.Value(scale: 0.15, color: .c44D7B6),
                BarChartView.DataValue.Value(scale: 0.3, color: .cFFB968)
            ]),
            BarChartView.DataValue(label: "3月", values: [
                BarChartView.DataValue.Value(scale: 0.1, color: .cFFA092),
                BarChartView.DataValue.Value(scale: 0.15, color: .cFEE25E),
                BarChartView.DataValue.Value(scale: 0.3, color: .c5F8FFF),
                BarChartView.DataValue.Value(scale: 0.15, color: .c44D7B6),
                BarChartView.DataValue.Value(scale: 0.3, color: .cFFB968)
            ])
        ]

        let yAxisValues = ["100%", "80%", "60%", "40%", "20%", "0%"]
        chart.dataSet = BarChartView.DataSet(xAxisValues: xAxisValues, yAxisValues: yAxisValues)
    }
}
