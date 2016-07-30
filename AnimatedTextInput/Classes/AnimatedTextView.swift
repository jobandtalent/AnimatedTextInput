import UIKit

final internal class AnimatedTextView: UITextView {

    weak var textInputDelegate: TextInputDelegate?

    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)

        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        setup()
    }

    private func setup() {
        delegate = self
    }

    override func resignFirstResponder() -> Bool {
        return super.resignFirstResponder()
    }
}

extension AnimatedTextView: TextInput {

    var view: UIView { return self }

    var currentText: String? {
        get { return text }
        set { self.text = newValue }
    }

    var textAttributes: [String: AnyObject] {
        get { return typingAttributes }
        set { self.typingAttributes = textAttributes }
    }
}

extension AnimatedTextView: UITextViewDelegate {

    func textViewDidBeginEditing(textView: UITextView) {
        textInputDelegate?.textInputDidBeginEditing(self)
    }

    func textViewDidEndEditing(textView: UITextView) {
        textInputDelegate?.textInputDidEndEditing(self)
    }

    func textViewDidChange(textView: UITextView) {
        textInputDelegate?.textInputDidChange(self)
    }

    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            return textInputDelegate?.textInputShouldReturn(self) ?? true
        }
        return textInputDelegate?.textInput(self, shouldChangeCharactersInRange: range, replacementString: text) ?? true
    }

    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        return textInputDelegate?.textInputShouldBeginEditing(self) ?? true
    }

    func textViewShouldEndEditing(textView: UITextView) -> Bool {
        return textInputDelegate?.textInputShouldEndEditing(self) ?? true
    }
}
