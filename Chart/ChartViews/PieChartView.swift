//
//  PieChart.swift
//  Chart
//
//  Created by 张泽群 on 2023/3/27.
//

import UIKit

class PieChartView: UIView {
    var dataSet: [DataValue] = []

    override func draw(_ rect: CGRect) {
        // 获取绘图上下文
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        context.setFillColor(UIColor.black.cgColor)
        context.fill(rect)

        let center = CGPoint(x: rect.midX, y: rect.midY)
        // 饼图半径
        let radius: CGFloat = rect.insetBy(dx: 0, dy: 20).height / 2
        // 饼图画图区域
        let drawRect = CGRect(x: rect.midX - radius, y: rect.midY - radius, width: radius * 2, height: radius * 2)
        // 绘图开始角度
        var startAngle: CGFloat = -.pi / 2
        let padding: CGFloat = .pi * 1 / 180

        dataSet.forEach { item in
            // 画圆弧
            let angle: CGFloat = .pi * (355 * item.ratio) / 180.0
            let endAngle = startAngle + angle
            context.addArc(center: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: false)
            context.addLine(to: center)
            context.setFillColor(item.color.cgColor)
            context.drawPath(using: .fill)

            let centerAngle = startAngle + (endAngle - startAngle) / 2



            startAngle = endAngle + padding
        }

        context.setFillColor(UIColor.white.cgColor)
        context.addArc(center: center, radius: radius - 30, startAngle: 0, endAngle: .pi * 2, clockwise: false)
        context.drawPath(using: .fill)
    }
}

extension PieChartView {
    struct DataValue {
        let label: String
        let ratio: CGFloat
        let color: UIColor
    }
}
