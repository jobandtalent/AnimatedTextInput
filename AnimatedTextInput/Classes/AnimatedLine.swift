import UIKit

public final class AnimatedLine: UIView {

    enum FillType {
        case leftToRight
        case rightToLeft
    }

    private let lineLayer = CAShapeLayer()

    var animationDuration: Double = 0.4

    var defaultColor = UIColor.gray.withAlphaComponent(0.6) {
        didSet {
            backgroundColor = defaultColor
        }
    }

    var fillType = FillType.leftToRight {
        didSet {
            updatePath()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        setup()
    }

    private func setup() {
        backgroundColor = defaultColor
        addLine()
    }

    override public func layoutSubviews() {
        super.layoutSubviews()

        lineLayer.frame = bounds
        lineLayer.lineWidth = bounds.height
        updatePath()
    }

    private func addLine() {
        lineLayer.frame = bounds
        let clearColor = UIColor.clear.cgColor
        lineLayer.backgroundColor = clearColor
        lineLayer.fillColor = clearColor
        lineLayer.strokeColor = defaultColor.cgColor
        lineLayer.lineWidth = bounds.height
        updatePath()
        lineLayer.strokeEnd = 0
        layer.addSublayer(lineLayer)
    }

    private func updatePath() {
        lineLayer.path = linePath()
    }

    private func linePath() -> CGPath {
        let path = UIBezierPath()
        let initialPoint = CGPoint(x: 0, y: bounds.midY)
        let finalPoint = CGPoint(x: bounds.maxX, y: bounds.midY)

        switch fillType {
        case .leftToRight:
            path.move(to: initialPoint)
            path.addLine(to: finalPoint)
        case .rightToLeft:
            path.move(to: finalPoint)
            path.addLine(to: initialPoint)
        }

        return path.cgPath
    }

    func fillLine(with color: UIColor) {
        if lineLayer.strokeEnd == 1 {
            backgroundColor = UIColor(cgColor: lineLayer.strokeColor ?? defaultColor.cgColor)
        }
        lineLayer.strokeColor = color.cgColor
        lineLayer.strokeEnd = 0
        animateLine(to: 1.0)
    }

    func animateToInitialState() {
        backgroundColor = defaultColor
        animateLine(to: 0.0)
    }

    private func animateLine(to value: CGFloat) {
        let function = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transactionAnimation(with: animationDuration, timingFuncion: function) {
            self.lineLayer.strokeEnd = value
        }
    }
}
