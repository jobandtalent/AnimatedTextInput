import UIKit

final internal class AnimatedTextField: UITextField {

    enum TextFieldType {
        case text
        case password
        case numeric
        case selection
    }

    private let defaultPadding: CGFloat = -16

    var rightViewPadding: CGFloat
    weak var textInputDelegate: TextInputDelegate?

    private var disclosureButtonAction: (Void -> Void)?

    override init(frame: CGRect) {
        self.rightViewPadding = defaultPadding

        super.init(frame: frame)

        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        self.rightViewPadding = defaultPadding

        super.init(coder: aDecoder)

        setup()
    }

    private func setup() {
        delegate = self
        addTarget(self, action: #selector(textFieldDidChange), forControlEvents: .EditingChanged)
    }

    override func rightViewRectForBounds(bounds: CGRect) -> CGRect {
        return CGRectOffset(super.rightViewRectForBounds(bounds), rightViewPadding, 0)
    }

    func add(disclosureButton button: UIButton, action: (Void -> Void)) {
        let selector = #selector(disclosureButtonPressed)
        if disclosureButtonAction != nil, let previousButton = rightView as? UIButton {
            previousButton.removeTarget(self, action: selector, forControlEvents: .TouchUpInside)
        }
        disclosureButtonAction = action
        button.addTarget(self, action: selector, forControlEvents: .TouchUpInside)
        rightView = button
    }

    @objc private func disclosureButtonPressed() {
        disclosureButtonAction?()
    }

    @objc private func textFieldDidChange() {
        textInputDelegate?.textInputDidChange(self)
    }
}

extension AnimatedTextField: TextInput {

    var view: UIView { return self }

    var currentText: String? {
        get { return text }
        set { self.text = newValue }
    }

    var textAttributes: [String: AnyObject] {
        get { return typingAttributes ?? [:] }
        set { self.typingAttributes = textAttributes }
    }
}

extension AnimatedTextField: TextInputError {

    func configureErrorState(with message: String?) {
        placeholder = message
    }

    func removeErrorHintMessage() {
        placeholder = nil
    }
}

extension AnimatedTextField: UITextFieldDelegate {

    func textFieldDidBeginEditing(textField: UITextField) {
        textInputDelegate?.textInputDidBeginEditing(self)
    }

    func textFieldDidEndEditing(textField: UITextField) {
        textInputDelegate?.textInputDidEndEditing(self)
    }

    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        return textInputDelegate?.textInput(self, shouldChangeCharactersInRange: range, replacementString: string) ?? true
    }

    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        return textInputDelegate?.textInputShouldBeginEditing(self) ?? true
    }

    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        return textInputDelegate?.textInputShouldEndEditing(self) ?? true
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        return textInputDelegate?.textInputShouldReturn(self) ?? true
    }
}
