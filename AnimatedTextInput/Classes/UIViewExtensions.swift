import UIKit

extension UIView {

    func transactionAnimation(with duration: CFTimeInterval, timingFuncion: CAMediaTimingFunction, animations: Void -> Void) {
        CATransaction.begin()
        CATransaction.disableActions()
        CATransaction.setAnimationDuration(duration)
        CATransaction.setAnimationTimingFunction(timingFuncion)
        animations()
        CATransaction.commit()
    }

    func pinLeading(toLeadingOf view: UIView, constant: CGFloat) {
        NSLayoutConstraint(item: view,
                           attribute: .Leading,
                           relatedBy: .Equal,
                           toItem: self,
                           attribute: .Leading,
                           multiplier: 1.0,
                           constant: constant).active = true
    }

    func pinTrailing(toTrailingOf view: UIView, constant: CGFloat) {
        NSLayoutConstraint(item: view,
                           attribute: .Trailing,
                           relatedBy: .Equal,
                           toItem: self,
                           attribute: .Trailing,
                           multiplier: 1.0,
                           constant: -constant).active = true
    }

    func pinTop(toTopOf view: UIView, constant: CGFloat) {
        NSLayoutConstraint(item: view,
                           attribute: .Top,
                           relatedBy: .Equal,
                           toItem: self,
                           attribute: .Top,
                           multiplier: 1.0,
                           constant: constant).active = true
    }

    func pinBottom(toBottomOf view: UIView, constant: CGFloat) {
        NSLayoutConstraint(item: view,
                           attribute: .Bottom,
                           relatedBy: .Equal,
                           toItem: self,
                           attribute: .Bottom,
                           multiplier: 1.0,
                           constant: -constant).active = true
    }

    func pinBottom(toTopOf view: UIView, constant: CGFloat) {
        NSLayoutConstraint(item: self,
                           attribute: .Bottom,
                           relatedBy: .Equal,
                           toItem: view,
                           attribute: .Top,
                           multiplier: 1.0,
                           constant: -constant).active = true
    }

    func setHeight(to constant: CGFloat) {
        NSLayoutConstraint(item: self,
                           attribute: .Height,
                           relatedBy: .Equal,
                           toItem: nil,
                           attribute: .NotAnAttribute,
                           multiplier: 1.0,
                           constant: constant).active = true
    }
}
