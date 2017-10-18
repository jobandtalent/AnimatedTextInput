import UIKit

extension UIView {

    func transactionAnimation(with duration: CFTimeInterval, timingFuncion: CAMediaTimingFunction, animations: (Void) -> Void) {
        CATransaction.begin()
        CATransaction.disableActions()
        CATransaction.setAnimationDuration(duration)
        CATransaction.setAnimationTimingFunction(timingFuncion)
        animations()
        CATransaction.commit()
    }

    func pinLeading(toLeadingOf view: UIView, constant: CGFloat) {
        NSLayoutConstraint(item: view,
                           attribute: .leading,
                           relatedBy: .equal,
                           toItem: self,
                           attribute: .leading,
                           multiplier: 1.0,
                           constant: constant).isActive = true
    }

    @discardableResult func pinTrailing(toTrailingOf view: UIView, constant: CGFloat) -> NSLayoutConstraint {
        let constraint = NSLayoutConstraint(item: view,
                           attribute: .trailing,
                           relatedBy: .equal,
                           toItem: self,
                           attribute: .trailing,
                           multiplier: 1.0,
                           constant: -constant)
        constraint.isActive = true
        return constraint
    }

    @discardableResult func pinTrailing(toLeadingOf view: UIView, constant: CGFloat) -> NSLayoutConstraint {
        let constraint = NSLayoutConstraint(item: view,
                                            attribute: .leading,
                                            relatedBy: .equal,
                                            toItem: self,
                                            attribute: .trailing,
                                            multiplier: 1.0,
                                            constant: -constant)
        constraint.isActive = true
        return constraint
    }

    func alignHorizontalAxis(toSameAxisOfView view: UIView) {
        NSLayoutConstraint(item: view,
                           attribute: .centerY,
                           relatedBy: .equal,
                           toItem: self,
                           attribute: .centerY,
                           multiplier: 1.0,
                           constant: 0.0).isActive = true
    }

    func pinTop(toTopOf view: UIView, constant: CGFloat) {
        NSLayoutConstraint(item: view,
                           attribute: .top,
                           relatedBy: .equal,
                           toItem: self,
                           attribute: .top,
                           multiplier: 1.0,
                           constant: constant).isActive = true
    }

    @discardableResult func pinBottom(toBottomOf view: UIView, constant: CGFloat) -> NSLayoutConstraint {
        let constraint = NSLayoutConstraint(item: view,
                           attribute: .bottom,
                           relatedBy: .equal,
                           toItem: self,
                           attribute: .bottom,
                           multiplier: 1.0,
                           constant: -constant)
        constraint.isActive = true
        return constraint
    }

    func pinBottom(toTopOf view: UIView, constant: CGFloat) {
        NSLayoutConstraint(item: self,
                           attribute: .bottom,
                           relatedBy: .equal,
                           toItem: view,
                           attribute: .top,
                           multiplier: 1.0,
                           constant: -constant).isActive = true
    }

    func setHeight(viewHeightFor view: UIView, constant: CGFloat) -> NSLayoutConstraint {
        let constraint = NSLayoutConstraint(item: view,
                                            attribute: .height,
                                            relatedBy: .equal,
                                            toItem: nil,
                                            attribute: .notAnAttribute,
                                            multiplier: 1.0,
                                            constant: constant)
        constraint.isActive = true
        return constraint
    }
}
