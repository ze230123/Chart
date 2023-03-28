//
//  LineChartView.swift
//  Chart
//
//  Created by 张泽群 on 2023/3/23.
//

import UIKit

class LineChartView: UIView {
    var configure = ChartConfiguration()

    var dataSet: DataSet? {
        didSet {
            setNeedsDisplay()
        }
    }

    override func draw(_ rect: CGRect) {
        guard let yAxisDataSet = dataSet?.yAxisValues,
              let xAxisDataSet = dataSet?.xAxisValues,
              let values = dataSet?.value,
              let maxValue = yAxisDataSet.max(),
              let minValue = yAxisDataSet.min() else {
            return
        }

        // 获取绘图上下文
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }

        let yAxisWidth: CGFloat = 26
        let xAxisHeight = configure.font.lineHeight + 10

        let xAxisRect = CGRect(x: yAxisWidth, y: rect.height - xAxisHeight, width: rect.width - yAxisWidth, height: xAxisHeight)
        let yAxisRect = CGRect(x: 0, y: 0, width: yAxisWidth, height: rect.height - xAxisHeight)
        let contentRect = CGRect(x: yAxisWidth, y: 8, width: rect.width - yAxisWidth, height: rect.height - 8 - xAxisHeight)

        // 绘制Y轴
        context.move(to: CGPoint(x: yAxisRect.maxX, y: yAxisRect.minY))
        context.addLine(to: CGPoint(x: yAxisRect.maxX, y: yAxisRect.maxY))
        context.setStrokeColor(configure.lineColor.cgColor)
        context.strokePath()

        // 绘制内容区域Y轴网格，Y轴刻度
        let space = contentRect.height / CGFloat(yAxisDataSet.count - 1)
        let yGridPath = CGMutablePath()
        let fontHeight = configure.font.lineHeight
        yAxisDataSet.enumerated().forEach { item in
            let y = CGFloat(item.offset) * space + contentRect.minY
            yGridPath.move(to: CGPoint(x: contentRect.minX, y: y))
            yGridPath.addLine(to: CGPoint(x: contentRect.maxX, y: y))
            let titleRect = CGRect(x: yAxisRect.minX, y: y - fontHeight / 2, width: yAxisRect.width - 4, height: fontHeight)
            item.element.wValue.draw(in: titleRect, withAttributes: configure.yAxisAttributes())
        }
        context.addPath(yGridPath)
        // 设置虚线模式
        context.setLineDash(phase: 0, lengths: [3, 1])
        context.setStrokeColor(configure.lineColor.cgColor)
        context.strokePath()
        // 取消虚线模式
        context.setLineDash(phase: 0, lengths: [])

        // 绘制X轴
        context.move(to: CGPoint(x: xAxisRect.minX, y: xAxisRect.minY))
        context.addLine(to: CGPoint(x: xAxisRect.maxX, y: xAxisRect.minY))
        context.setStrokeColor(configure.lineColor.cgColor)
        context.strokePath()

        // 绘制X轴刻度
        let xAxisTitles = xAxisDataSet
        let width = contentRect.width / CGFloat(xAxisTitles.count)
        xAxisTitles.enumerated().forEach { (index, title) in
            let rect = CGRect(x: CGFloat(index) * width + xAxisRect.minX, y: xAxisRect.minY + 5, width: width, height: configure.font.lineHeight)
            (title as NSString).draw(in: rect, withAttributes: configure.xAxisAttributes())
        }

        let valueRank = maxValue - minValue
        values.forEach { item in
            var points = item.value.enumerated().map { (index, value) in
                let centerX = CGFloat(index) * width + contentRect.minX + width / 2
                let y = contentRect.minY + CGFloat(maxValue - value) / CGFloat(valueRank) * contentRect.height
                return CGPoint(x: centerX, y: y)
            }
            points.insert(points.first ?? .zero, at: 0)
            points.append(points.last ?? .zero)
            let path = UIBezierPath()
            for idx in 0..<points.count - 3 {
                let p1 = points[idx]
                let p2 = points[idx + 1]
                let p3 = points[idx + 2]
                let p4 = points[idx + 3]
                if idx == 0 {
                    path.move(to: p2)
                }
                getControlPoint(p1.x, y0: p1.y, x1: p2.x, y1: p2.y, x2: p3.x, y2: p3.y, x3: p4.x, y3: p4.y, path: path)
            }
            context.addPath(path.cgPath)
            context.setStrokeColor(item.color.cgColor)
            context.strokePath()
        }
    }

    func getControlPoint(_ x0: CGFloat, y0: CGFloat, x1: CGFloat, y1: CGFloat, x2: CGFloat, y2: CGFloat, x3: CGFloat, y3: CGFloat, path: UIBezierPath) {

        let smoothValue: CGFloat = 0.6
        var ctrl1X: CGFloat = 0
        var ctrl1Y: CGFloat = 0
        var ctrl2X: CGFloat = 0
        var ctrl2Y: CGFloat = 0
        let xc1: CGFloat = (x0 + x1) / 2.0
        let yc1: CGFloat = (y0 + y1) / 2.0
        let xc2: CGFloat = (x1 + x2) / 2.0
        let yc2: CGFloat = (y1 + y2) / 2.0
        let xc3: CGFloat = (x2 + x3) / 2.0
        let yc3: CGFloat = (y2 + y3) / 2.0
        let len1: CGFloat = sqrt((x1-x0) * (x1-x0) + (y1-y0) * (y1-y0))
        let len2: CGFloat = sqrt((x2-x1) * (x2-x1) + (y2-y1) * (y2-y1))
        let len3: CGFloat = sqrt((x3-x2) * (x3-x2) + (y3-y2) * (y3-y2))
        let k1: CGFloat = len1 / (len1 + len2)
        let k2: CGFloat = len2 / (len2 + len3)
        let xm1: CGFloat = xc1 + (xc2 - xc1) * k1
        let ym1: CGFloat = yc1 + (yc2 - yc1) * k1
        let xm2: CGFloat = xc2 + (xc3 - xc2) * k2
        let ym2: CGFloat = yc2 + (yc3 - yc2) * k2
        ctrl1X = xm1 + (xc2 - xm1) * smoothValue + x1 - xm1
        ctrl1Y = ym1 + (yc2 - ym1) * smoothValue + y1 - ym1
        ctrl2X = xm2 + (xc2 - xm2) * smoothValue + x2 - xm2
        ctrl2Y = ym2 + (yc2 - ym2) * smoothValue + y2 - ym2
        path.addCurve(to: CGPoint(x: x2, y: y2), controlPoint1: CGPoint(x: ctrl1X, y: ctrl1Y), controlPoint2: CGPoint(x: ctrl2X, y: ctrl2Y))
    }
}

extension LineChartView {
    struct DataValue {
        /// 线颜色
        let color: UIColor
        /// X轴value
        let value: [Int]
    }

    struct DataSet {
        let value: [DataValue]
        let xAxisValues: [String]
        let yAxisValues: [Int]
    }
}

private extension Int {
    var wValue: String {
        guard self > 0 else {
            return "0"
        }
        return "\(self / 10000)w"
    }
}
