import UIKit

final public class AnimatedTextView: UITextView {
    

    public var textAttributes: [NSAttributedString.Key: Any]? {
        didSet {
            guard let attributes = textAttributes else { return }
            typingAttributes = Dictionary(uniqueKeysWithValues: attributes.lazy.map { ($0.key, $0.value) })
        }
    }

    public override var font: UIFont? {
        didSet {
            var attributes = typingAttributes
            attributes[NSAttributedString.Key.font] = font
            textAttributes = Dictionary(uniqueKeysWithValues: attributes.lazy.map { ($0.key, $0.value)})
        }
    }

    public weak var textInputDelegate: TextInputDelegate?

    /// The maximum allowed height of a multiline label. When set, the TextView will not grow above this height.
    var maximumHeightOfMultilineLabel: CGFloat?
    
    /// Constraint that limits the maximum height of a multiline textview.
    fileprivate var heightConstraintForMultilineLabel: NSLayoutConstraint?
    
    
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
    
    public func changeClearButtonMode(with newClearButtonMode: UITextField.ViewMode) {}
    
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
        
        // Force-refresh the layout as we need the contentSize based on the current amount of text.
        textView.setNeedsLayout()
        textView.layoutIfNeeded()
        
        // Perform a check to see if the TextView should have a maximum height. If so, check if the desired contentHeight is above the max height.
        if let maxHeight = maximumHeightOfMultilineLabel, textView.contentSize.height >= maxHeight {
            
            // Check if the height constraint is not added, yet. Create and add it if so.
            if heightConstraintForMultilineLabel == nil {
                
                // Enable scrolling:
                textView.isScrollEnabled = true
                
                // Set new maximum height as current height constraint. Since the maximum allowed height is already reached, this constraint defines the current height of the text input to be the maximum height:
                heightConstraintForMultilineLabel = NSLayoutConstraint(item: textView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: maxHeight)
                heightConstraintForMultilineLabel!.identifier = "CurrentHeightOfTextView"
                textView.addConstraint(heightConstraintForMultilineLabel!)
                
                // Scroll to the bottom as the user may enter even more text and want to see where the text ist put.
                let bottomRect = CGRect(x: 0, y: textView.contentSize.height-1, width: textView.contentSize.width, height: 1)
                textView.scrollRectToVisible(bottomRect, animated: true)
            }
        }
        else {
            // Remove the constraint and set it to nil in order to avoid re-adding it later.
            if let existingConstraint = heightConstraintForMultilineLabel {
                textView.removeConstraint(existingConstraint)
                heightConstraintForMultilineLabel = nil
                
                // Disable scrolling:
                textView.isScrollEnabled = false
            }
        }
        
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
