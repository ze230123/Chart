//
//  BarChartView.swift
//  Chart
//
//  Created by 张泽群 on 2023/3/24.
//

import UIKit

class BarChartView: UIView {
    var configure = ChartConfiguration()

    var dataSet: DataSet?

    override func draw(_ rect: CGRect) {
        guard let yAxisDataSet = dataSet?.yAxisValues,
                let xAxisDataSet = dataSet?.xAxisValues else {
                  return
        }

        // 获取绘图上下文
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }

        /// 内容区域顶部边距
        let contentTop: CGFloat = 8
        /// Y轴刻度标识
        let yAxisTitles = yAxisDataSet
        /// Y轴刻度表示最大宽度，默认 30
        let yAxisWidth: CGFloat = yAxisTitles.map { $0.widthFor(font: configure.font, height: configure.font.lineHeight) }.max() ?? 30
        let yAxisRight: CGFloat = 4

        /// X轴刻度标识高度，上下加5
        let xAxisHeight = configure.font.lineHeight + 10

        let yAxisRect = CGRect(x: 0, y: 0, width: yAxisWidth + yAxisRight * 2, height: rect.height - xAxisHeight)
        let xAxisRect = CGRect(x: yAxisRect.maxX, y: yAxisRect.maxY, width: rect.width - yAxisRect.maxX, height: xAxisHeight)
        let contentRect = CGRect(x: yAxisRect.maxX, y: contentTop, width: rect.width - yAxisRect.maxX, height: xAxisRect.minY - contentTop)

        // 绘制Y轴
        context.move(to: CGPoint(x: yAxisRect.maxX, y: yAxisRect.minY))
        context.addLine(to: CGPoint(x: yAxisRect.maxX, y: yAxisRect.maxY))
        context.setStrokeColor(configure.lineColor.cgColor)
        context.strokePath()

        // 绘制内容区域Y轴网格，Y轴刻度
        let space = contentRect.height / CGFloat(yAxisDataSet.count - 1)
        let fontHeight = configure.font.lineHeight
        yAxisTitles.enumerated().forEach { item in
            let y = CGFloat(item.offset) * space + contentRect.minY
            let titleRect = CGRect(x: yAxisRect.minX, y: y - fontHeight / 2, width: yAxisRect.width - yAxisRight, height: fontHeight)
            item.element.draw(in: titleRect, withAttributes: configure.yAxisAttributes())
        }

        // 绘制X轴
        context.move(to: CGPoint(x: xAxisRect.minX, y: xAxisRect.minY))
        context.addLine(to: CGPoint(x: xAxisRect.maxX, y: xAxisRect.minY))
        context.setStrokeColor(configure.lineColor.cgColor)
        context.strokePath()

        // 绘制X轴刻度
        let xAxisTitles = xAxisDataSet.map { $0.label }
        let width = contentRect.width / CGFloat(xAxisTitles.count)
        xAxisTitles.enumerated().forEach { (index, title) in
            let rect = CGRect(x: CGFloat(index) * width + xAxisRect.minX, y: xAxisRect.minY + (xAxisRect.height - configure.font.lineHeight) / 2, width: width, height: configure.font.lineHeight)
            (title as NSString).draw(in: rect, withAttributes: configure.xAxisAttributes())
        }

        xAxisDataSet.enumerated().forEach { (index, value) in
            let centerX = CGFloat(index) * width + contentRect.minX + width / 2

            let items = value.values.filter { $0.scale != 0 }
            struct RectValue {
                let rect: CGRect
                let color: UIColor
            }

            var minY: CGFloat = contentRect.minY

            let rects = items.map { item in
                let height = item.scale * contentRect.height
                let rect = CGRect(x: centerX - 5, y: minY, width: 10, height: height)
                minY += height
                return RectValue(rect: rect, color: item.color)
            }
            rects.forEach { item in
                context.setFillColor(item.color.cgColor)
                context.fill(item.rect)
            }
        }
    }
}

extension BarChartView {
    struct DataValue {
        struct Value {
            let scale: CGFloat
            let color: UIColor
        }
        /// X轴标识
        let label: String
        let values: [Value]
    }

    struct DataSet {
        let xAxisValues: [DataValue]
        let yAxisValues: [String]
    }
}
