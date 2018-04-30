import UIKit

final public class AnimatedTextView: UITextView {

    public var textAttributes: [NSAttributedStringKey: Any]? {
        didSet {
            guard let attributes = textAttributes else { return }
            typingAttributes = Dictionary(uniqueKeysWithValues: attributes.lazy.map { ($0.key.rawValue, $0.value) })
        }
    }

    public override var font: UIFont? {
        didSet {
            var attributes = typingAttributes
            attributes[NSAttributedStringKey.font.rawValue] = font
            textAttributes = Dictionary(uniqueKeysWithValues: attributes.lazy.map { (NSAttributedStringKey($0.key), $0.value)})
        }
    }

    public weak var textInputDelegate: TextInputDelegate?

    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)

        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        setup()
    }

    fileprivate func setup() {
        contentInset = UIEdgeInsets(top: 0, left: -4, bottom: 0, right: 0)
        delegate = self
    }

    public override func resignFirstResponder() -> Bool {
        return super.resignFirstResponder()
    }
}

extension AnimatedTextView: TextInput {
    public func configureInputView(newInputView: UIView) {
        inputView = newInputView
    }

    public var currentText: String? {
        get { return text }
        set { self.text = newValue }
    }

    public var currentSelectedTextRange: UITextRange? {
        get { return self.selectedTextRange }
        set { self.selectedTextRange = newValue }
    }

    public var currentBeginningOfDocument: UITextPosition? {
        return self.beginningOfDocument
    }
    
    public var currentKeyboardAppearance: UIKeyboardAppearance {
        get { return self.keyboardAppearance }
        set { self.keyboardAppearance = newValue}
    }

    public var autocorrection: UITextAutocorrectionType {
        get { return self.autocorrectionType }
        set { self.autocorrectionType = newValue }
    }
    
    public func changeReturnKeyType(with newReturnKeyType: UIReturnKeyType) {
        returnKeyType = newReturnKeyType
    }
    
    public func currentPosition(from: UITextPosition, offset: Int) -> UITextPosition? {
        return position(from: from, offset: offset)
    }
    
    public func changeClearButtonMode(with newClearButtonMode: UITextFieldViewMode) {}
    
}

extension AnimatedTextView: UITextViewDelegate {

    public func textViewDidBeginEditing(_ textView: UITextView) {
        textInputDelegate?.textInputDidBeginEditing(textInput: self)
    }

    public func textViewDidEndEditing(_ textView: UITextView) {
        textInputDelegate?.textInputDidEndEditing(textInput: self)
    }

    public func textViewDidChange(_ textView: UITextView) {
        let range = textView.selectedRange
        textView.attributedText = NSAttributedString(string: textView.text, attributes: textAttributes)
        textView.selectedRange = range

        textInputDelegate?.textInputDidChange(textInput: self)
    }

    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            return textInputDelegate?.textInputShouldReturn(textInput: self) ?? true
        }
        return textInputDelegate?.textInput(textInput: self, shouldChangeCharactersInRange: range, replacementString: text) ?? true
    }

    public func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        return textInputDelegate?.textInputShouldBeginEditing(textInput: self) ?? true
    }

    public func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        return textInputDelegate?.textInputShouldEndEditing(textInput: self) ?? true
    }
}
