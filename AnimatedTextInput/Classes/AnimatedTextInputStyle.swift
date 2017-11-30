import UIKit

public protocol AnimatedTextInputStyle {
    var activeColor: UIColor { get }
    var placeholderInactiveColor: UIColor { get }
    var inactiveColor: UIColor { get }
    var lineActiveColor: UIColor { get }
    var lineInactiveColor: UIColor { get }
    var lineHeight: CGFloat { get }
    var errorColor: UIColor { get }
    var textInputFont: UIFont { get }
    var textInputFontColor: UIColor { get }
    var placeholderMinFontSize: CGFloat { get }
    var counterLabelFont: UIFont? { get }
    var leftMargin: CGFloat { get }
    var topMargin: CGFloat { get }
    var rightMargin: CGFloat { get }
    var bottomMargin: CGFloat { get }
    var yHintPositionOffset: CGFloat { get }
    var yPlaceholderPositionOffset: CGFloat { get }
    var textAttributes: [String: Any]? { get }
}

public struct AnimatedTextInputStyleBlue: AnimatedTextInputStyle {

    public let activeColor = UIColor(red: 51.0/255.0, green: 175.0/255.0, blue: 236.0/255.0, alpha: 1.0)
    public let placeholderInactiveColor = UIColor.gray.withAlphaComponent(0.5)
    public let inactiveColor = UIColor.gray.withAlphaComponent(0.5)
    public let lineActiveColor = UIColor.gray.withAlphaComponent(0.0)
    public let lineInactiveColor = UIColor.gray.withAlphaComponent(0.2)
    public let lineHeight: CGFloat = 1.0
    public let errorColor = UIColor.red
    public let textInputFont = UIFont.systemFont(ofSize: 14)
    public let textInputFontColor = UIColor.black
    public let placeholderMinFontSize: CGFloat = 9
    public let counterLabelFont: UIFont? = UIFont.systemFont(ofSize: 9)
    public let leftMargin: CGFloat = 25
    public let topMargin: CGFloat = 20
    public let rightMargin: CGFloat = 0
    public let bottomMargin: CGFloat = 10
    public let yHintPositionOffset: CGFloat = 7
    public let yPlaceholderPositionOffset: CGFloat = 0
    //Text attributes will override properties like textInputFont, textInputFontColor...
    public let textAttributes: [String: Any]? = nil

    public init() { }
}
