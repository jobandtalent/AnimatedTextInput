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

    func pinTrailing(toTrailingOf view: UIView, constant: CGFloat) {
        NSLayoutConstraint(item: view,
                           attribute: .trailing,
                           relatedBy: .equal,
                           toItem: self,
                           attribute: .trailing,
                           multiplier: 1.0,
                           constant: -constant).isActive = true
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

    func pinBottom(toBottomOf view: UIView, constant: CGFloat) {
        NSLayoutConstraint(item: view,
                           attribute: .bottom,
                           relatedBy: .equal,
                           toItem: self,
                           attribute: .bottom,
                           multiplier: 1.0,
                           constant: -constant).isActive = true
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

    func setHeight(to constant: CGFloat) {
        NSLayoutConstraint(item: self,
                           attribute: .height,
                           relatedBy: .equal,
                           toItem: nil,
                           attribute: .notAnAttribute,
                           multiplier: 1.0,
                           constant: constant).isActive = true
    }
}
