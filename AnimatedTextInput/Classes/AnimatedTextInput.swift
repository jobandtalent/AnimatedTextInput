import UIKit
import PureLayout

@objc public protocol AnimatedTextInputDelegate: class {

    optional func animatedTextInputDidBeginEditing(animatedTextInput: AnimatedTextInput)
    optional func animatedTextInputDidEndEditing(animatedTextInput: AnimatedTextInput)
    optional func animatedTextInputDidChange(animatedTextInput: AnimatedTextInput)
    optional func animatedTextInput(animatedTextInput: AnimatedTextInput, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool
    optional func animatedTextInputShouldBeginEditing(animatedTextInput: AnimatedTextInput) -> Bool
    optional func animatedTextInputShouldEndEditing(animatedTextInput: AnimatedTextInput) -> Bool
    optional func animatedTextInputShouldReturn(animatedTextInput: AnimatedTextInput) -> Bool
}

public class AnimatedTextInput: UIControl {

    public typealias AnimatedTextInputType = AnimatedTextInputFieldConfigurator.AnimatedTextInputType

    public var tapAction: (Void -> Void)?
    public  weak var delegate: AnimatedTextInputDelegate?
    public private(set) var textInputType: AnimatedTextInputType = .text
    public private(set) var isActive = false

    public var placeHolderText = "Test" {
        didSet {
            placeholderLayer.string = placeHolderText
        }
    }

    public var text: String? {
        return textInput.currentText
    }


    private let lineView = AnimatedLine()
    private let placeholderLayer = CATextLayer()
    private let counterLabel = UILabel()
    private let lineWidth: CGFloat = 1
    private let counterLabelRightMargin: CGFloat = 15

    private var isPlaceholderAsHint = false
    private var textInput: TextInput!
    private var textInputHeightConstraint: NSLayoutConstraint!
    private var placeholderErrorText = "Error message"
    private var styleConfigurator: AnimatedTextInputStyle = AnimatedTextInputStyleBlue()
    private var lineToBottomConstraint: NSLayoutConstraint!

    private var placeholderPosition: CGPoint {
        let hintPosition = CGPoint(x: styleConfigurator.leftMargin, y: styleConfigurator.yHintPositionOffset)
        let defaultPosition = CGPoint(x: styleConfigurator.leftMargin, y: styleConfigurator.topMargin)
        return isPlaceholderAsHint ? hintPosition : defaultPosition
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupCommonElements()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        setupCommonElements()
    }

    override public func intrinsicContentSize() -> CGSize {
        let normalHeight = textInput.view.intrinsicContentSize().height
        return CGSize(width: UIViewNoIntrinsicMetric, height: normalHeight + styleConfigurator.topMargin + styleConfigurator.bottomMargin)
    }

    // MARK: Configuration

    private func setupCommonElements() {
        addLine()
        addPlaceHolder()
        addTapGestureRecognizer()
        addTextInput()
    }

    private func addLine() {
        lineView.defaultColor = styleConfigurator.inactiveColor
        addSubview(lineView)
        lineView.autoPinEdge(.Leading, toEdge: .Leading, ofView: self, withOffset: styleConfigurator.leftMargin)
        lineView.autoPinEdge(.Trailing, toEdge: .Trailing, ofView: self, withOffset: -styleConfigurator.rightMargin)
        lineToBottomConstraint = lineView.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: self)
        lineView.autoSetDimension(.Height, toSize: lineWidth)
    }

    private func addPlaceHolder() {
        placeholderLayer.masksToBounds = false
        placeholderLayer.string = placeHolderText
        placeholderLayer.foregroundColor = styleConfigurator.inactiveColor.CGColor
        let fontSize = styleConfigurator.textInputFont.pointSize
        placeholderLayer.fontSize = fontSize
        placeholderLayer.font = styleConfigurator.textInputFont
        placeholderLayer.contentsScale = UIScreen.mainScreen().scale
        placeholderLayer.frame = CGRect(origin: placeholderPosition, size: CGSize(width: bounds.width, height: fontSize))
        layer.addSublayer(placeholderLayer)
    }

    private func addTapGestureRecognizer() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(viewWasTapped(_:)))
        addGestureRecognizer(tap)
    }

    private func addTextInput() {
        textInput = AnimatedTextInputFieldConfigurator.configure(with: textInputType)
        textInput.textInputDelegate = self
        textInput.view.tintColor = styleConfigurator.activeColor
        textInput.textColor = styleConfigurator.textInputFontColor
        textInput.font = styleConfigurator.textInputFont
        addSubview(textInput.view)
        textInput.view.autoPinEdge(.Leading, toEdge: .Leading, ofView: self, withOffset: styleConfigurator.leftMargin)
        textInput.view.autoPinEdge(.Trailing, toEdge: .Trailing, ofView: self, withOffset: -styleConfigurator.rightMargin)
        textInput.view.autoPinEdge(.Bottom, toEdge: .Top, ofView: lineView, withOffset: -styleConfigurator.bottomMargin)
        textInput.view.autoPinEdge(.Top, toEdge: .Top, ofView: self, withOffset: styleConfigurator.topMargin)
        invalidateIntrinsicContentSize()
    }

    private func updateCounter() {
        guard let counterText = counterLabel.text else { return }
        let components = counterText.componentsSeparatedByString("/")
        let characters = (text != nil) ? text!.characters.count : 0
        counterLabel.text = "\(characters)/\(components[1])"
    }

    //MARK: States and animations

    private func placeholderHintActiveConfiguration() {
        isPlaceholderAsHint = true
        configurePlaceholderWith(fontSize: styleConfigurator.placeholderMinFontSize,
                                 foregroundColor: styleConfigurator.activeColor.CGColor,
                                 text: placeHolderText)
        lineView.fillLine(with: styleConfigurator.activeColor)
    }

    private func placeholderHintInactiveConfiguration() {
        isPlaceholderAsHint = true
        configurePlaceholderWith(fontSize: styleConfigurator.placeholderMinFontSize,
                                 foregroundColor: styleConfigurator.inactiveColor.CGColor,
                                 text: placeHolderText)
        lineView.animateToInitialState()
    }

    private func placeholderDefaultConfiguration() {
        isPlaceholderAsHint = false
        configurePlaceholderWith(fontSize: styleConfigurator.textInputFont.pointSize,
                                 foregroundColor: styleConfigurator.inactiveColor.CGColor,
                                 text: placeHolderText)
        lineView.animateToInitialState()
    }

    private func placeholderHintErrorConfiguration() {
        isPlaceholderAsHint = true
        configurePlaceholderWith(fontSize: styleConfigurator.placeholderMinFontSize,
                                 foregroundColor: styleConfigurator.errorColor.CGColor,
                                 text: placeholderErrorText)
        lineView.fillLine(with: styleConfigurator.errorColor)
    }

    private func configurePlaceholderWith(fontSize fontSize: CGFloat, foregroundColor: CGColor, text: String) {
        placeholderLayer.fontSize = fontSize
        placeholderLayer.foregroundColor = foregroundColor
        placeholderLayer.string = text
        placeholderLayer.frame = CGRect(origin: placeholderPosition, size: placeholderLayer.frame.size)
    }

    private func animatePlaceholder(to applyConfiguration: Void -> Void) {
        let duration = 0.2
        let function = CAMediaTimingFunction(controlPoints: 0.3, 0.0, 0.5, 0.95)
        transactionAnimation(with: duration, timingFuncion: function, animations: applyConfiguration)
    }

    //MARK: Behaviours

    @objc private func viewWasTapped(sender: UIGestureRecognizer) {
        if let tapAction = tapAction { tapAction() }
        else { becomeFirstResponder() }
    }

    private func styleDidChange() {
        lineView.defaultColor = styleConfigurator.inactiveColor
        placeholderLayer.foregroundColor = styleConfigurator.inactiveColor.CGColor
        let fontSize = styleConfigurator.textInputFont.pointSize
        placeholderLayer.fontSize = fontSize
        placeholderLayer.font = styleConfigurator.textInputFont
        placeholderLayer.frame = CGRect(origin: placeholderPosition, size: CGSize(width: bounds.width, height: fontSize))
        textInput.view.tintColor = styleConfigurator.activeColor
        textInput.textColor = styleConfigurator.textInputFontColor
        textInput.font = styleConfigurator.textInputFont
        invalidateIntrinsicContentSize()
        layoutIfNeeded()
    }

    override public func becomeFirstResponder() -> Bool {
        isActive = true
        textInput.view.becomeFirstResponder()
        counterLabel.textColor = styleConfigurator.activeColor
        animatePlaceholder(to: placeholderHintActiveConfiguration)
        return true
    }

    override public func resignFirstResponder() -> Bool {
        isActive = false
        textInput.view.resignFirstResponder()
        counterLabel.textColor = styleConfigurator.inactiveColor

        if let textInputError = textInput as? TextInputError {
            textInputError.removeErrorHintMessage()
        }

        guard let text = textInput.currentText where !text.isEmpty else {
            animatePlaceholder(to: placeholderDefaultConfiguration)
            return true
        }
        animatePlaceholder(to: placeholderHintInactiveConfiguration)
        return true
    }

    override public func canResignFirstResponder() -> Bool {
        return textInput.view.canResignFirstResponder()
    }

    override public func canBecomeFirstResponder() -> Bool {
        return textInput.view.canBecomeFirstResponder()
    }

    public func set(text text: String?) {
        (text != nil) ? placeholderHintInactiveConfiguration() : placeholderDefaultConfiguration()
        textInput.currentText = text
    }

    public func show(error errorMessage: String, placeholderText: String? = nil) {
        placeholderErrorText = errorMessage
        if let textInput = textInput as? TextInputError {
            textInput.configureErrorState(with: placeholderText)
        }
        animatePlaceholder(to: placeholderHintErrorConfiguration)
    }

    public func configureType(with type: AnimatedTextInputType) {
        textInputType = type
        textInput.view.removeFromSuperview()
        addTextInput()
    }

    public func configureStyle(with style: AnimatedTextInputStyle) {
        styleConfigurator = style
        styleDidChange()
        if isActive {
            placeholderHintActiveConfiguration()
        } else {
            isPlaceholderAsHint ? placeholderHintInactiveConfiguration() : placeholderDefaultConfiguration()
        }
    }

    public func showCharacterCounterLabel(with maximum: Int) {
        let characters = (text != nil) ? text!.characters.count : 0
        counterLabel.text = "\(characters)/\(maximum)"
        counterLabel.textColor = isActive ? styleConfigurator.activeColor : styleConfigurator.inactiveColor
        counterLabel.font = styleConfigurator.counterLabelFont
        addSubview(counterLabel)
        let topOffset: CGFloat = 5
        counterLabel.autoPinEdge(.Top, toEdge: .Bottom, ofView: lineView, withOffset: topOffset)
        counterLabel.autoPinEdge(.Trailing, toEdge: .Trailing, ofView: self, withOffset: -counterLabelRightMargin)
        lineToBottomConstraint.constant = -counterLabel.intrinsicContentSize().height - topOffset
        invalidateIntrinsicContentSize()
    }

    public func removeCharacterCounterLabel() {
        counterLabel.removeConstraints(counterLabel.constraints)
        counterLabel.removeFromSuperview()
        lineToBottomConstraint.constant = 0
        invalidateIntrinsicContentSize()
    }
}

extension AnimatedTextInput: TextInputDelegate {

    public func textInputDidBeginEditing(textInput: TextInput) {
        becomeFirstResponder()
        delegate?.animatedTextInputDidBeginEditing?(self)
    }

    public func textInputDidEndEditing(textInput: TextInput) {
        resignFirstResponder()
        delegate?.animatedTextInputDidEndEditing?(self)
    }

    public func textInputDidChange(textInput: TextInput) {
        updateCounter()
        delegate?.animatedTextInputDidChange?(self)
    }

    public func textInput(textInput: TextInput, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        return delegate?.animatedTextInput?(self, shouldChangeCharactersInRange: range, replacementString: string) ?? true
    }

    public func textInputShouldBeginEditing(textInput: TextInput) -> Bool {
        return delegate?.animatedTextInputShouldBeginEditing?(self) ?? true
    }

    public func textInputShouldEndEditing(textInput: TextInput) -> Bool {
        return delegate?.animatedTextInputShouldEndEditing?(self) ?? true
    }

    public func textInputShouldReturn(textInput: TextInput) -> Bool {
        return delegate?.animatedTextInputShouldReturn?(self) ?? true
    }
}

public protocol TextInput {
    var view: UIView { get }
    var currentText: String? { get set }
    var font: UIFont? { get set }
    var textColor: UIColor? { get set }
    weak var textInputDelegate: TextInputDelegate? { get set }
}

public protocol TextInputDelegate: class {
    func textInputDidBeginEditing(textInput: TextInput)
    func textInputDidEndEditing(textInput: TextInput)
    func textInputDidChange(textInput: TextInput)
    func textInput(textInput: TextInput, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool
    func textInputShouldBeginEditing(textInput: TextInput) -> Bool
    func textInputShouldEndEditing(textInput: TextInput) -> Bool
    func textInputShouldReturn(textInput: TextInput) -> Bool
}

public protocol TextInputError {
    func configureErrorState(with message: String?)
    func removeErrorHintMessage()
}
