import UIKit

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
    public private(set) var isActive = false

    public var type: AnimatedTextInputType = .text {
        didSet {
            configureType()
        }
    }

    public var placeHolderText = "Test" {
        didSet {
            placeholderLayer.string = placeHolderText
        }
    }

    public var style: AnimatedTextInputStyle = AnimatedTextInputStyleBlue() {
        didSet {
            configureStyle()
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
    private let counterLabelTopMargin: CGFloat = 5

    private var isPlaceholderAsHint = false
    private var hasCounterLabel = false
    private var textInput: TextInput!
    private var textInputHeightConstraint: NSLayoutConstraint!
    private var placeholderErrorText = "Error message"
    private var lineToBottomConstraint: NSLayoutConstraint!

    private var placeholderPosition: CGPoint {
        let hintPosition = CGPoint(x: style.leftMargin, y: style.yHintPositionOffset)
        let defaultPosition = CGPoint(x: style.leftMargin, y: style.topMargin)
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
        return CGSize(width: UIViewNoIntrinsicMetric, height: normalHeight + style.topMargin + style.bottomMargin)
    }

    public override func updateConstraints() {
        addLineViewConstraints()
        addTextInputConstraints()
        super.updateConstraints()
    }

    // MARK: Configuration

    private func addLineViewConstraints() {
        let leading = NSLayoutConstraint(item: lineView,
                                         attribute: .Leading,
                                         relatedBy: .Equal,
                                         toItem: self,
                                         attribute: .Leading,
                                         multiplier: 1.0,
                                         constant: styleConfigurator.leftMargin)
        let trailing = NSLayoutConstraint(item: lineView,
                                          attribute: .Trailing,
                                          relatedBy: .Equal,
                                          toItem: self,
                                          attribute: .Trailing,
                                          multiplier: 1.0,
                                          constant: -styleConfigurator.rightMargin)
        let height = NSLayoutConstraint(item: lineView,
                                        attribute: .Height,
                                        relatedBy: .Equal,
                                        toItem: nil,
                                        attribute: .NotAnAttribute,
                                        multiplier: 1.0,
                                        constant: lineWidth)
        let constant = hasCounterLabel ? -counterLabel.intrinsicContentSize().height - counterLabelTopMargin : 0
        lineToBottomConstraint = NSLayoutConstraint(item: lineView,
                                                    attribute: .Bottom,
                                                    relatedBy: .Equal,
                                                    toItem: self,
                                                    attribute: .Bottom,
                                                    multiplier: 1.0,
                                                    constant: constant)
        addConstraints([leading, trailing, height, lineToBottomConstraint])
    }
    private func addTextInputConstraints() {
        let leading = NSLayoutConstraint(item: textInput.view,
                                         attribute: .Leading,
                                         relatedBy: .Equal,
                                         toItem: self,
                                         attribute: .Leading,
                                         multiplier: 1.0,
                                         constant: styleConfigurator.leftMargin)
        let trailing = NSLayoutConstraint(item: textInput.view,
                                          attribute: .Trailing,
                                          relatedBy: .Equal,
                                          toItem: self,
                                          attribute: .Trailing,
                                          multiplier: 1.0,
                                          constant: -styleConfigurator.rightMargin)
        let top = NSLayoutConstraint(item: textInput.view,
                                     attribute: .Top,
                                     relatedBy: .Equal,
                                     toItem: self,
                                     attribute: .Top,
                                     multiplier: 1.0,
                                     constant: styleConfigurator.topMargin)
        let bottom = NSLayoutConstraint(item: textInput.view,
                                        attribute: .Bottom,
                                        relatedBy: .Equal,
                                        toItem: lineView,
                                        attribute: .Top,
                                        multiplier: 1.0,
                                        constant: -styleConfigurator.bottomMargin)
        addConstraints([leading, trailing, top, bottom])
    }

    private func setupCommonElements() {
        addLine()
        addPlaceHolder()
        addTapGestureRecognizer()
        addTextInput()
    }

    private func addLine() {
        lineView.defaultColor = style.inactiveColor
        lineView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(lineView)
    }

    private func addPlaceHolder() {
        placeholderLayer.masksToBounds = false
        placeholderLayer.string = placeHolderText
        placeholderLayer.foregroundColor = style.inactiveColor.CGColor
        let fontSize = style.textInputFont.pointSize
        placeholderLayer.fontSize = fontSize
        placeholderLayer.font = style.textInputFont
        placeholderLayer.contentsScale = UIScreen.mainScreen().scale
        placeholderLayer.frame = CGRect(origin: placeholderPosition, size: CGSize(width: bounds.width, height: fontSize))
        layer.addSublayer(placeholderLayer)
    }

    private func addTapGestureRecognizer() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(viewWasTapped(_:)))
        addGestureRecognizer(tap)
    }

    private func addTextInput() {
        textInput = AnimatedTextInputFieldConfigurator.configure(with: type)
        textInput.textInputDelegate = self
        textInput.view.tintColor = style.activeColor
        textInput.textColor = style.textInputFontColor
        textInput.font = style.textInputFont
        textInput.view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(textInput.view)
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
        configurePlaceholderWith(fontSize: style.placeholderMinFontSize,
                                 foregroundColor: style.activeColor.CGColor,
                                 text: placeHolderText)
        lineView.fillLine(with: style.activeColor)
    }

    private func placeholderHintInactiveConfiguration() {
        isPlaceholderAsHint = true
        configurePlaceholderWith(fontSize: style.placeholderMinFontSize,
                                 foregroundColor: style.inactiveColor.CGColor,
                                 text: placeHolderText)
        lineView.animateToInitialState()
    }

    private func placeholderDefaultConfiguration() {
        isPlaceholderAsHint = false
        configurePlaceholderWith(fontSize: style.textInputFont.pointSize,
                                 foregroundColor: style.inactiveColor.CGColor,
                                 text: placeHolderText)
        lineView.animateToInitialState()
    }

    private func placeholderHintErrorConfiguration() {
        isPlaceholderAsHint = true
        configurePlaceholderWith(fontSize: style.placeholderMinFontSize,
                                 foregroundColor: style.errorColor.CGColor,
                                 text: placeholderErrorText)
        lineView.fillLine(with: style.errorColor)
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
        lineView.defaultColor = style.inactiveColor
        placeholderLayer.foregroundColor = style.inactiveColor.CGColor
        let fontSize = style.textInputFont.pointSize
        placeholderLayer.fontSize = fontSize
        placeholderLayer.font = style.textInputFont
        placeholderLayer.frame = CGRect(origin: placeholderPosition, size: CGSize(width: bounds.width, height: fontSize))
        textInput.view.tintColor = style.activeColor
        textInput.textColor = style.textInputFontColor
        textInput.font = style.textInputFont
        invalidateIntrinsicContentSize()
        layoutIfNeeded()
    }

    override public func becomeFirstResponder() -> Bool {
        isActive = true
        textInput.view.becomeFirstResponder()
        counterLabel.textColor = style.activeColor
        animatePlaceholder(to: placeholderHintActiveConfiguration)
        return true
    }

    override public func resignFirstResponder() -> Bool {
        isActive = false
        textInput.view.resignFirstResponder()
        counterLabel.textColor = style.inactiveColor

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

    private func configureType() {
        textInput.view.removeFromSuperview()
        addTextInput()
    }

    private func configureStyle() {
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
        counterLabel.textColor = isActive ? style.activeColor : style.inactiveColor
        counterLabel.font = style.counterLabelFont
        counterLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(counterLabel)
        addCharacterCounterConstraints()
        invalidateIntrinsicContentSize()
    }

    private func addCharacterCounterConstraints() {
        let top = NSLayoutConstraint(item: counterLabel,
                                     attribute: .Top,
                                     relatedBy: .Equal,
                                     toItem: lineView,
                                     attribute: .Bottom,
                                     multiplier: 1.0,
                                     constant: counterLabelTopMargin)
        let trailing = NSLayoutConstraint(item: counterLabel,
                                          attribute: .Trailing,
                                          relatedBy: .Equal,
                                          toItem: self,
                                          attribute: .Trailing,
                                          multiplier: 1.0,
                                          constant: -counterLabelRightMargin)
        addConstraints([top, trailing])
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
