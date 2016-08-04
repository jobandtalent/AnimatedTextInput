import UIKit

@objc public protocol AnimatedTextInputDelegate: class {

    @objc optional func animatedTextInputDidBeginEditing(_ animatedTextInput: AnimatedTextInput)
    @objc optional func animatedTextInputDidEndEditing(_ animatedTextInput: AnimatedTextInput)
    @objc optional func animatedTextInputDidChange(_ animatedTextInput: AnimatedTextInput)
    @objc optional func animatedTextInput(_ animatedTextInput: AnimatedTextInput, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool
    @objc optional func animatedTextInputShouldBeginEditing(_ animatedTextInput: AnimatedTextInput) -> Bool
    @objc optional func animatedTextInputShouldEndEditing(_ animatedTextInput: AnimatedTextInput) -> Bool
    @objc optional func animatedTextInputShouldReturn(_ animatedTextInput: AnimatedTextInput) -> Bool
}

public class AnimatedTextInput: UIControl {

    public typealias AnimatedTextInputType = AnimatedTextInputFieldConfigurator.AnimatedTextInputType

    public var tapAction: ((Void) -> Void)?
    public  weak var delegate: AnimatedTextInputDelegate?
    public private(set) var isActive = false

    public var type: AnimatedTextInputType = .standard {
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
        get {
            return textInput.currentText
        }
        set {
            (newValue != nil) ? configurePlaceholderAsInactiveHint() : configurePlaceholderAsDefault()
            textInput.currentText = newValue
        }
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

    override public var intrinsicContentSize: CGSize {
        get {
        let normalHeight = textInput.view.intrinsicContentSize.height
        return CGSize(width: UIViewNoIntrinsicMetric, height: normalHeight + style.topMargin + style.bottomMargin)
        }
    }

    public override func updateConstraints() {
        addLineViewConstraints()
        addTextInputConstraints()
        super.updateConstraints()
    }


    // MARK: Configuration

    private func addLineViewConstraints() {
        pinLeading(toLeadingOf: lineView, constant: style.leftMargin)
        pinTrailing(toTrailingOf: lineView, constant: style.rightMargin)
        lineView.setHeight(to: lineWidth)
        let constant = hasCounterLabel ? -counterLabel.intrinsicContentSize.height - counterLabelTopMargin : 0
        pinBottom(toBottomOf: lineView, constant: constant)
    }

    private func addTextInputConstraints() {
        pinLeading(toLeadingOf: textInput.view, constant: style.leftMargin)
        pinTrailing(toTrailingOf: textInput.view, constant: style.rightMargin)
        pinTop(toTopOf: textInput.view, constant: style.topMargin)
        textInput.view.pinBottom(toTopOf: lineView, constant: style.bottomMargin)
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
        placeholderLayer.foregroundColor = style.inactiveColor.cgColor
        let fontSize = style.textInputFont.pointSize
        placeholderLayer.fontSize = fontSize
        placeholderLayer.font = style.textInputFont
        placeholderLayer.contentsScale = UIScreen.main.scale
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
        let components = counterText.components(separatedBy: "/")
        let characters = (text != nil) ? text!.characters.count : 0
        counterLabel.text = "\(characters)/\(components[1])"
    }

    //MARK: States and animations

    private func configurePlaceholderAsActiveHint() {
        isPlaceholderAsHint = true
        configurePlaceholderWith(fontSize: style.placeholderMinFontSize,
                                 foregroundColor: style.activeColor.cgColor,
                                 text: placeHolderText)
        lineView.fillLine(with: style.activeColor)
    }

    private func configurePlaceholderAsInactiveHint() {
        isPlaceholderAsHint = true
        configurePlaceholderWith(fontSize: style.placeholderMinFontSize,
                                 foregroundColor: style.inactiveColor.cgColor,
                                 text: placeHolderText)
        lineView.animateToInitialState()
    }

    private func configurePlaceholderAsDefault() {
        isPlaceholderAsHint = false
        configurePlaceholderWith(fontSize: style.textInputFont.pointSize,
                                 foregroundColor: style.inactiveColor.cgColor,
                                 text: placeHolderText)
        lineView.animateToInitialState()
    }

    private func configurePlaceholderAsErrorHint() {
        isPlaceholderAsHint = true
        configurePlaceholderWith(fontSize: style.placeholderMinFontSize,
                                 foregroundColor: style.errorColor.cgColor,
                                 text: placeholderErrorText)
        lineView.fillLine(with: style.errorColor)
    }

    private func configurePlaceholderWith(fontSize: CGFloat, foregroundColor: CGColor, text: String) {
        placeholderLayer.fontSize = fontSize
        placeholderLayer.foregroundColor = foregroundColor
        placeholderLayer.string = text
        placeholderLayer.frame = CGRect(origin: placeholderPosition, size: placeholderLayer.frame.size)
    }

    private func animatePlaceholder(to applyConfiguration: (Void) -> Void) {
        let duration = 0.2
        let function = CAMediaTimingFunction(controlPoints: 0.3, 0.0, 0.5, 0.95)
        transactionAnimation(with: duration, timingFuncion: function, animations: applyConfiguration)
    }

    //MARK: Behaviours

    @objc private func viewWasTapped(_ sender: UIGestureRecognizer) {
        if let tapAction = tapAction { tapAction() }
        else { becomeFirstResponder() }
    }

    private func styleDidChange() {
        lineView.defaultColor = style.inactiveColor
        placeholderLayer.foregroundColor = style.inactiveColor.cgColor
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
        animatePlaceholder(to: configurePlaceholderAsActiveHint)
        return true
    }

    override public func resignFirstResponder() -> Bool {
        isActive = false
        textInput.view.resignFirstResponder()
        counterLabel.textColor = style.inactiveColor

        if let textInputError = textInput as? TextInputError {
            textInputError.removeErrorHintMessage()
        }

        guard let text = textInput.currentText , !text.isEmpty else {
            animatePlaceholder(to: configurePlaceholderAsDefault)
            return true
        }
        animatePlaceholder(to: configurePlaceholderAsInactiveHint)
        return true
    }



    override public var canResignFirstResponder: Bool {
        get {
            return textInput.view.canResignFirstResponder
        }
    }

    override public var canBecomeFirstResponder: Bool {
        get {
            return textInput.view.canBecomeFirstResponder
        }
    }

    public func show(error errorMessage: String, placeholderText: String? = nil) {
        placeholderErrorText = errorMessage
        if let textInput = textInput as? TextInputError {
            textInput.configureErrorState(with: placeholderText)
        }
        animatePlaceholder(to: configurePlaceholderAsErrorHint)
    }

    private func configureType() {
        textInput.view.removeFromSuperview()
        addTextInput()
    }

    private func configureStyle() {
        styleDidChange()
        if isActive {
            configurePlaceholderAsActiveHint()
        } else {
            isPlaceholderAsHint ? configurePlaceholderAsInactiveHint() : configurePlaceholderAsDefault()
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
        lineView.pinBottom(toTopOf: counterLabel, constant: counterLabelTopMargin)
        pinTrailing(toTrailingOf: counterLabel, constant: counterLabelRightMargin)
    }

    public func removeCharacterCounterLabel() {
        counterLabel.removeConstraints(counterLabel.constraints)
        counterLabel.removeFromSuperview()
        lineToBottomConstraint.constant = 0
        invalidateIntrinsicContentSize()
    }
}

extension AnimatedTextInput: TextInputDelegate {

    public func textInputDidBeginEditing(_ textInput: TextInput) {
        becomeFirstResponder()
        delegate?.animatedTextInputDidBeginEditing?(self)
    }

    public func textInputDidEndEditing(_ textInput: TextInput) {
        resignFirstResponder()
        delegate?.animatedTextInputDidEndEditing?(self)
    }

    public func textInputDidChange(_ textInput: TextInput) {
        updateCounter()
        delegate?.animatedTextInputDidChange?(self)
    }

    public func textInput(_ textInput: TextInput, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        return delegate?.animatedTextInput?(self, shouldChangeCharactersInRange: range, replacementString: string) ?? true
    }

    public func textInputShouldBeginEditing(_ textInput: TextInput) -> Bool {
        return delegate?.animatedTextInputShouldBeginEditing?(self) ?? true
    }

    public func textInputShouldEndEditing(_ textInput: TextInput) -> Bool {
        return delegate?.animatedTextInputShouldEndEditing?(self) ?? true
    }

    public func textInputShouldReturn(_ textInput: TextInput) -> Bool {
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
    func textInputDidBeginEditing(_ textInput: TextInput)
    func textInputDidEndEditing(_ textInput: TextInput)
    func textInputDidChange(_ textInput: TextInput)
    func textInput(_ textInput: TextInput, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool
    func textInputShouldBeginEditing(_ textInput: TextInput) -> Bool
    func textInputShouldEndEditing(_ textInput: TextInput) -> Bool
    func textInputShouldReturn(_ textInput: TextInput) -> Bool
}

public protocol TextInputError {
    func configureErrorState(with message: String?)
    func removeErrorHintMessage()
}
