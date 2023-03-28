//
//  PieChart.swift
//  Chart
//
//  Created by 张泽群 on 2023/3/27.
//

import UIKit

class PieChartView: UIView {
    var configure = ChartConfiguration()

    var dataSet: [DataValue] = []

    override func draw(_ rect: CGRect) {
        // 获取绘图上下文
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }

        let center = CGPoint(x: rect.midX, y: rect.midY)
        // 饼图半径
        let radius: CGFloat = rect.insetBy(dx: 0, dy: 30).height / 2
        // 饼图画图区域
        let drawRect = CGRect(x: rect.midX - radius, y: rect.midY - radius, width: radius * 2, height: radius * 2)
        // 绘图开始角度
        var startAngle: CGFloat = -.pi / 2

        // 上一个引导线数字, 坐标
        var preNumberPoint: CGPoint?
        // 上一个引导线名字，坐标
        var preNamePoint: CGPoint?

        // 文字高度
        let textHeight = configure.font.lineHeight

        dataSet.enumerated().forEach { (index, item) in
            // 画圆弧
            let angle: CGFloat = .pi * 2 * item.ratio
            let endAngle = startAngle + angle
            context.addArc(center: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: false)
            context.addLine(to: center)
            context.setLineWidth(2)
            context.setFillColor(item.color.cgColor)
            context.setStrokeColor(UIColor.white.cgColor)
            context.drawPath(using: .fillStroke)

            // 圆弧中心角度
            let centerAngle = (startAngle + endAngle) * 0.5
            let lineStartX = center.x + radius * cos(centerAngle)
            let lineStartY = center.y + radius * sin(centerAngle)

            let startPoint = CGPoint(x: lineStartX, y: lineStartY)

            // 指引线转折点的位置(x, y)
            let breakPointX = startPoint.x + 15 * cos(centerAngle)
            let breakPointY = startPoint.y + 15 * sin(centerAngle)

            // 指引线终点（x, y）
            var endX: CGFloat = 0
            let endY: CGFloat = breakPointY

            // 重设开始角度
            startAngle = endAngle

            // 百分比宽度
            let textWidth: CGFloat = 120
            // 百分比文字坐标
            var numberPoint = CGPoint.zero
            numberPoint.x = breakPointX
            numberPoint.y = breakPointY - textHeight

            var namePoint = CGPoint.zero
            namePoint.x = breakPointX
            namePoint.y = breakPointY + 2

            if startPoint.x <= center.x { // 左边
                endX = 10
                numberPoint.x = endX
                namePoint.x = endX
            } else { // 右边
                endX = rect.maxX - 10
                numberPoint.x = endX - textWidth
                namePoint.x = endX - textWidth
            }

            // 判断上一个文字和即将绘图文字是否有重叠
            // 重叠的话不绘制
            if let preNumberPoint = preNumberPoint, let preNamePoint = preNamePoint {
                // 右边
                if numberPoint.x > center.x && preNumberPoint.x > center.x {
                    if preNamePoint.y + textHeight + 10 > numberPoint.y {
                        return
                    }
                } else if numberPoint.x < center.x && preNumberPoint.x < center.x {
                    if preNumberPoint.y - 10 < namePoint.y + textHeight {
                        return
                    }
                }
            }

            preNumberPoint = numberPoint
            preNamePoint = namePoint

            // 指引起点的位置（x, y）
            let startX = startPoint.x + 5 * cos(centerAngle)
            let startY = startPoint.y + 5 * sin(centerAngle)

            // 绘制小圆点
            context.addArc(center: CGPoint(x: startX, y: startY), radius: 3, startAngle: 0, endAngle: .pi * 2, clockwise: false)
            context.drawPath(using: .fill)

            context.move(to: CGPoint(x: startX, y: startY))
            context.addLine(to: CGPoint(x: breakPointX, y: breakPointY))
            context.addLine(to: CGPoint(x: endX, y: endY))
            context.setLineWidth(1)
            context.setStrokeColor(item.color.cgColor)
            context.drawPath(using: .stroke)

            // 绘制文字
            let par = NSMutableParagraphStyle()
            par.alignment = numberPoint.x > center.x ? .right : .left
            let attributes: [NSAttributedString.Key: Any] = [
                .font: configure.font,
                .foregroundColor: configure.textColor,
                .paragraphStyle: par
            ]
            let textSize = CGSize(width: textWidth, height: textHeight)
            let number = "\(item.ratio * 100)%"
            number.draw(in: CGRect(origin: numberPoint, size: textSize), withAttributes: attributes)
            item.label.draw(in: CGRect(origin: namePoint, size: textSize), withAttributes: attributes)
        }

//        // 绘制中心圆遮罩
//        context.setFillColor(UIColor.white.cgColor)
//        context.addArc(center: center, radius: radius - 30, startAngle: 0, endAngle: .pi * 2, clockwise: false)
//        context.drawPath(using: .fill)
    }
}

extension PieChartView {
    struct DataValue {
        let label: String
        let ratio: CGFloat
        let color: UIColor
    }
}
