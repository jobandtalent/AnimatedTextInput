import UIKit

public final class AnimatedLine: UIView {

    enum FillType {
        case leftToRight
        case rightToLeft
    }

    private let lineLayer = CAShapeLayer()

    var animationDuration: Double = 0.4

    var defaultColor = UIColor.grayColor().colorWithAlphaComponent(0.6) {
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
        lineLayer.lineWidth = CGRectGetHeight(bounds)
        updatePath()
    }

    private func addLine() {
        lineLayer.frame = bounds
        let clearColor = UIColor.clearColor().CGColor
        lineLayer.backgroundColor = clearColor
        lineLayer.fillColor = clearColor
        lineLayer.strokeColor = defaultColor.CGColor
        lineLayer.lineWidth = CGRectGetHeight(bounds)
        updatePath()
        lineLayer.strokeEnd = 0
        layer.addSublayer(lineLayer)
    }

    private func updatePath() {
        lineLayer.path = linePath()
    }

    private func linePath() -> CGPath {
        let path = UIBezierPath()
        let initialPoint = CGPoint(x: 0, y: CGRectGetMidY(bounds))
        let finalPoint = CGPoint(x: CGRectGetMaxX(bounds), y: CGRectGetMidY(bounds))

        switch fillType {
        case .leftToRight:
            path.moveToPoint(initialPoint)
            path.addLineToPoint(finalPoint)
        case .rightToLeft:
            path.moveToPoint(finalPoint)
            path.addLineToPoint(initialPoint)
        }

        return path.CGPath
    }

    func fillLine(with color: UIColor) {
        if lineLayer.strokeEnd == 1 {
            backgroundColor = UIColor(CGColor: lineLayer.strokeColor ?? defaultColor.CGColor)
        }
        lineLayer.strokeColor = color.CGColor
        lineLayer.strokeEnd = 0
        animateLine(to: 1.0)
    }

    func animateToInitialState() {
        backgroundColor = defaultColor
        animateLine(to: 0.0)
    }

    private func animateLine(to value: CGFloat) {
        let function = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        let duration = 0.2
        transactionAnimation(with: animationDuration, timingFuncion: function) {
            self.lineLayer.strokeEnd = value
        }
    }
}
