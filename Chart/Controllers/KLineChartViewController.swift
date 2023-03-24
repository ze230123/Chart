//
//  KLineChartViewController.swift
//  Chart
//
//  Created by 张泽群 on 2023/3/23.
//

import UIKit

class KLineChartViewController: UIViewController {
    @IBOutlet weak var chart: KLineChartView!

    override func viewDidLoad() {
        super.viewDidLoad()

        chart.layer.shadowColor = UIColor.black.cgColor
        chart.layer.shadowOffset = CGSize(width: 0, height: 0)
        chart.layer.shadowRadius = 5
        chart.layer.shadowOpacity = 0.1

        let xAxisValues = [
            KLineChartView.DataValue(value: KLineChartView.DataValue.Value(max: 15000, min: 2000, mid: (10000, 7000)), label: "4月"),
            KLineChartView.DataValue(value: KLineChartView.DataValue.Value(max: 20000, min: 5000, mid: (15000, 8000)), label: "5月"),
            KLineChartView.DataValue(value: KLineChartView.DataValue.Value(max: 24000, min: 3000, mid: (18000, 7000)), label: "6月"),
            KLineChartView.DataValue(value: KLineChartView.DataValue.Value(max: 21000, min: 6000, mid: (14000, 7000)), label: "7月"),
            KLineChartView.DataValue(value: KLineChartView.DataValue.Value(max: 17000, min: 8000, mid: (17000, 8000)), label: "8月"),
            KLineChartView.DataValue(value: KLineChartView.DataValue.Value(max: 14000, min: 4500, mid: (6000, 4500)), label: "9月"),
            KLineChartView.DataValue(value: KLineChartView.DataValue.Value(max: 12000, min: 5500, mid: (10000, 8900)), label: "10月"),
            KLineChartView.DataValue(value: KLineChartView.DataValue.Value(max: 18000, min: 3900, mid: (15700, 7500)), label: "11月"),
            KLineChartView.DataValue(value: KLineChartView.DataValue.Value(max: 17500, min: 8300, mid: (11000, 9000)), label: "12月"),
            KLineChartView.DataValue(value: KLineChartView.DataValue.Value(max: 16800, min: 7300, mid: (14300, 8000)), label: "1月"),
            KLineChartView.DataValue(value: KLineChartView.DataValue.Value(max: 13000, min: 1200, mid: (10000, 2000)), label: "2月"),
            KLineChartView.DataValue(value: KLineChartView.DataValue.Value(max: 18300, min: 3400, mid: (9000, 6000)), label: "3月")
        ]
        let yAxisValues = [25000, 20000, 15000, 10000, 5000, 1000]
        chart.dataSet = KLineChartView.DataSet(xAxisValues: xAxisValues, yAxisValues: yAxisValues)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
