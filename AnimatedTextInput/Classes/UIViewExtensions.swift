import Foundation

extension UIView {
    func transactionAnimation(with duration: CFTimeInterval, timingFuncion: CAMediaTimingFunction, animations: Void -> Void) {
        CATransaction.begin()
        CATransaction.disableActions()
        CATransaction.setAnimationDuration(duration)
        CATransaction.setAnimationTimingFunction(timingFuncion)

        animations()

        CATransaction.commit()
    }
}