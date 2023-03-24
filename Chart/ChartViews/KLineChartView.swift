//
//  KLineChartView.swift
//  Chart
//
//  Created by 张泽群 on 2023/3/23.
//

import UIKit

struct ChartConfiguration {
    var font: UIFont = UIFont.systemFont(ofSize: 10)

    var lineColor: UIColor = .cF6F6F6
    var textColor: UIColor = .c999999
    var contentColor: UIColor = .cFF951B

    func yAxisAttributes() -> [NSAttributedString.Key: Any] {
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .right
        return [
            .font: font,
            .foregroundColor: textColor,
            .paragraphStyle: paragraph
        ]
    }

    func xAxisAttributes() -> [NSAttributedString.Key: Any] {
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center
        return [
            .font: font,
            .foregroundColor: textColor,
            .paragraphStyle: paragraph
        ]
    }
}

class KLineChartView: UIView {
    var configure = ChartConfiguration()

    var dataSet: DataSet? {
        didSet {
            setNeedsDisplay()
        }
    }

    /// 中间数据rect
    var midRects: [CGRect] = []

    private var selectIndex: Int?

    override init(frame: CGRect) {
        super.init(frame: frame)
        prepare()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        prepare()
    }

    override func draw(_ rect: CGRect) {
        guard let yAxisDataSet = dataSet?.yAxisValues,
                let xAxisDataSet = dataSet?.xAxisValues,
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

//        // x轴区域
//        context.setFillColor(UIColor.red.cgColor)
//        context.addRect(xAxisRect)
//        context.fillPath()
//
//        // Y轴区域
//        context.setFillColor(UIColor.blue.cgColor)
//        context.addRect(yAxisRect)
//        context.fillPath()
//
//        // 内容区域
//        context.setFillColor(UIColor.green.cgColor)
//        context.addRect(contentRect)
//        context.fillPath()

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
            item.element.kValue.draw(in: titleRect, withAttributes: configure.yAxisAttributes())
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
        let xAxisTitles = xAxisDataSet.map { $0.label }
        let width = contentRect.width / CGFloat(xAxisTitles.count)
        xAxisTitles.enumerated().forEach { (index, title) in
            let rect = CGRect(x: CGFloat(index) * width + xAxisRect.minX, y: xAxisRect.minY + 5, width: width, height: configure.font.lineHeight)
            (title as NSString).draw(in: rect, withAttributes: configure.xAxisAttributes())
        }

        let contentPath = CGMutablePath()
        let valueRank = maxValue - minValue
        var contentRects: [CGRect] = []
        xAxisDataSet.enumerated().forEach { (index, value) in
            let centerX = CGFloat(index) * width + contentRect.minX + width / 2

            let minY = contentRect.minY + CGFloat(maxValue - value.value.max) / CGFloat(valueRank) * contentRect.height
            let maxY = contentRect.maxY - CGFloat(value.value.min - minValue) / CGFloat(valueRank) * contentRect.height
            let mid_minY = contentRect.minY + CGFloat(maxValue - value.value.mid.max) / CGFloat(valueRank) * contentRect.height
            let mid_maxY = contentRect.maxY - CGFloat(value.value.mid.min - minValue) / CGFloat(valueRank) * contentRect.height

            contentPath.move(to: CGPoint(x: centerX, y: minY))
            contentPath.addLine(to: CGPoint(x: centerX, y: mid_minY))

            contentPath.move(to: CGPoint(x: centerX, y: mid_maxY))
            contentPath.move(to: CGPoint(x: centerX, y: maxY))

            let midRect = CGRect(x: centerX - 5, y: mid_minY, width: 10, height: mid_maxY - mid_minY)
            contentPath.addRect(midRect)
            contentRects.append(midRect)
        }
        midRects = contentRects
        context.addPath(contentPath)
        context.setStrokeColor(configure.contentColor.cgColor)
        context.strokePath()

        if let selectIndex {
            let selectRect = midRects[selectIndex]
            context.setFillColor(configure.contentColor.cgColor)
            context.fill(selectRect)
        }
    }
}

extension KLineChartView {
    func prepare() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction(_:)))
        addGestureRecognizer(tap)
    }

    @objc func tapAction(_ sender: UITapGestureRecognizer) {
//        guard let xAxisValues = dataSet?.xAxisValues else { return }
        let point = sender.location(in: self)
        guard let index = midRects.firstIndex(where: { $0.contains(point) }) else { return }
        debugPrint("点击", index)
        if selectIndex == index {
            selectIndex = nil
        } else {
            selectIndex = index
        }
        setNeedsDisplay()
    }
}


extension KLineChartView {
    struct DataValue {
        struct Value {
            typealias Mid = (max: Int, min: Int)
            let max: Int
            let min: Int
            let mid: Mid
        }
        /// X轴value
        let value: Value
        /// X轴标签
        let label: String
    }

    struct DataSet {
        let xAxisValues: [DataValue]
        let yAxisValues: [Int]
    }
}

extension Int {
    var kValue: String {
        return "\(self / 1000)k"
    }
}

extension String {
    var asNSString: NSString {
        return self as NSString
    }

    func draw(in rect: CGRect, withAttributes attrs: [NSAttributedString.Key: Any]?) {
        asNSString.draw(in: rect, withAttributes: attrs)
    }

    func widthFor(font: UIFont, height: CGFloat) -> CGFloat {
        return asNSString.boundingRect(with: CGSize(width: .greatestFiniteMagnitude, height: height), attributes: [.font: font], context: nil).width
    }
}
