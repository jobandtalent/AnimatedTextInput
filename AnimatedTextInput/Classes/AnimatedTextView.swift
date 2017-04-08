import UIKit

final internal class AnimatedTextView: UITextView {

    var textAttributes: [String: Any]? {
        didSet {
            guard let attributes = textAttributes else { return }
            typingAttributes = attributes
        }
    }

    weak var textInputDelegate: TextInputDelegate?

    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)

        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        setup()
    }

    fileprivate func setup() {
        delegate = self
    }

    override func resignFirstResponder() -> Bool {
        return super.resignFirstResponder()
    }
}

extension AnimatedTextView: TextInput {

    var currentText: String? {
        get { return text }
        set { self.text = newValue }
    }

    var currentSelectedTextRange: UITextRange? {
        get { return self.selectedTextRange }
        set { self.selectedTextRange = newValue }
    }

    open var currentBeginningOfDocument: UITextPosition? {
        return self.beginningOfDocument
    }

    func changeReturnKeyType(with newReturnKeyType: UIReturnKeyType) {
        returnKeyType = newReturnKeyType
    }

    func currentPosition(from: UITextPosition, offset: Int) -> UITextPosition? {
        return position(from: from, offset: offset)
    }
    
    func changeClearButtonMode(with newClearButtonMode: UITextFieldViewMode) {}
    
}

extension AnimatedTextView: UITextViewDelegate {

    func textViewDidBeginEditing(_ textView: UITextView) {
        textInputDelegate?.textInputDidBeginEditing(textInput: self)
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        textInputDelegate?.textInputDidEndEditing(textInput: self)
    }

    func textViewDidChange(_ textView: UITextView) {
        let range = textView.selectedRange
        textView.attributedText = NSAttributedString(string: textView.text, attributes: textAttributes)
        textView.selectedRange = range

        textInputDelegate?.textInputDidChange(textInput: self)
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            return textInputDelegate?.textInputShouldReturn(textInput: self) ?? true
        }
        return textInputDelegate?.textInput(textInput: self, shouldChangeCharactersInRange: range, replacementString: text) ?? true
    }

    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        return textInputDelegate?.textInputShouldBeginEditing(textInput: self) ?? true
    }

    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        return textInputDelegate?.textInputShouldEndEditing(textInput: self) ?? true
    }
}
