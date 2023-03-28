//
//  PieChartViewController.swift
//  Chart
//
//  Created by 张泽群 on 2023/3/27.
//

import UIKit

class PieChartViewController: UIViewController {
    @IBOutlet weak var chart: PieChartView!

    override func viewDidLoad() {
        super.viewDidLoad()
        chart.layer.shadowColor = UIColor.black.cgColor
        chart.layer.shadowOffset = CGSize(width: 0, height: 0)
        chart.layer.shadowRadius = 5
        chart.layer.shadowOpacity = 0.1

        chart.dataSet = [
            PieChartView.DataValue(label: "硕士及以上", ratio: 0.1328, color: .c5F8FFF),
            PieChartView.DataValue(label: "博士及以上", ratio: 0.0108, color: .red),
            PieChartView.DataValue(label: "本科及以上", ratio: 0.6519, color: .cFFA092),
            PieChartView.DataValue(label: "专科及以上", ratio: 0.083, color: .orange),
            PieChartView.DataValue(label: "不限", ratio: 0.1215, color: .cyan)
        ]
    }
}
