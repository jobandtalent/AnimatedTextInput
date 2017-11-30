import UIKit

public struct AnimatedTextInputFieldConfigurator {

    public enum AnimatedTextInputType {
        case standard
        case email
        case password(toggleable: Bool)
        case numeric
        case selection
        case multiline
        case generic(textInput: TextInput)
    }

    static func configure(with type: AnimatedTextInputType) -> TextInput {
        switch type {
        case .standard:
            return AnimatedTextInputTextConfigurator.generate()
        case .email:
            return AnimatedTextInputEmailConfigurator.generate()
        case .password (let toggleable):
            return AnimatedTextInputPasswordConfigurator.generate(toggleable: toggleable)
        case .numeric:
            return AnimatedTextInputNumericConfigurator.generate()
        case .selection:
            return AnimatedTextInputSelectionConfigurator.generate()
        case .multiline:
            return AnimatedTextInputMultilineConfigurator.generate()
        case .generic(let textInput):
            return textInput
        }
    }
}

fileprivate struct AnimatedTextInputTextConfigurator {

    static func generate() -> TextInput {
        let textField = AnimatedTextField()
        textField.clearButtonMode = .whileEditing
        textField.autocorrectionType = .no
        return textField
    }
}

fileprivate struct AnimatedTextInputEmailConfigurator {

    static func generate() -> TextInput {
        let textField = AnimatedTextField()
        textField.clearButtonMode = .whileEditing
        textField.keyboardType = .emailAddress
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        return textField
    }
}

fileprivate struct AnimatedTextInputPasswordConfigurator {

    static func generate(toggleable: Bool) -> TextInput {
        let textField = AnimatedTextField()
        textField.rightViewMode = .whileEditing
        textField.isSecureTextEntry = true
        textField.autocapitalizationType = .none
        if toggleable {
            let disclosureButton = UIButton(type: .custom)
            disclosureButton.frame = CGRect(origin: CGPoint.zero, size: CGSize(width: 25, height: 21))
            let bundle = Bundle(path: Bundle(for: AnimatedTextInput.self).path(forResource: "AnimatedTextInput", ofType: "bundle")!)
            let normalImage = UIImage(named: "cm_icon_input_eye_normal", in: bundle, compatibleWith: nil)
            let selectedImage = UIImage(named: "cm_icon_input_eye_selected", in: bundle, compatibleWith: nil)
            disclosureButton.imageView?.contentMode = .scaleAspectFit
            disclosureButton.setImage(normalImage, for: .normal)
            disclosureButton.setImage(selectedImage, for: .selected)
            textField.add(disclosureButton: disclosureButton) {
                disclosureButton.isSelected = !disclosureButton.isSelected
                textField.resignFirstResponder()
                textField.isSecureTextEntry = !textField.isSecureTextEntry
                textField.becomeFirstResponder()
            }
        }
        return textField
    }
}

fileprivate struct AnimatedTextInputNumericConfigurator {

    static func generate() -> TextInput {
        let textField = AnimatedTextField()
        textField.clearButtonMode = .whileEditing
        textField.keyboardType = .decimalPad
        textField.autocorrectionType = .no
        return textField
    }
}

fileprivate struct AnimatedTextInputSelectionConfigurator {

    static func generate() -> TextInput {
        let textField = AnimatedTextField()
        let bundle = Bundle(path: Bundle(for: AnimatedTextInput.self).path(forResource: "AnimatedTextInput", ofType: "bundle")!)
        let arrowImageView = UIImageView(image: UIImage(named: "disclosure", in: bundle, compatibleWith: nil))
        textField.rightView = arrowImageView
        textField.rightViewMode = .always
        textField.isUserInteractionEnabled = false
        return textField
    }
}

fileprivate struct AnimatedTextInputMultilineConfigurator {

    static func generate() -> TextInput {
        let textView = AnimatedTextView()
        textView.textContainerInset = .zero
        textView.backgroundColor = .clear
        textView.isScrollEnabled = false
        textView.autocorrectionType = .no
        return textView
    }
}
