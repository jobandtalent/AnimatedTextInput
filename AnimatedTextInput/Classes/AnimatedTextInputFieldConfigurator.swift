import UIKit

public struct AnimatedTextInputFieldConfigurator {

    public enum AnimatedTextInputType {
        case text
        case password
        case numeric
        case selection
        case multiline
        case generic(textInput: TextInput)
    }

    static func configure(with type: AnimatedTextInputType) -> TextInput {
        switch type {
        case .text:
            return AnimatedTextInputTextConfigurator.generate()
        case .password:
            return AnimatedTextInputPasswordConfigurator.generate()
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

private struct AnimatedTextInputTextConfigurator {

    static func generate() -> TextInput {
        let textField = AnimatedTextField()
        textField.clearButtonMode = .WhileEditing
        return textField
    }
}

private struct AnimatedTextInputPasswordConfigurator {

    static func generate() -> TextInput {
        let textField = AnimatedTextField()
        textField.rightViewMode = .WhileEditing
        textField.secureTextEntry = true
        let disclosureButton = UIButton(type: .Custom)
        disclosureButton.frame = CGRect(origin: CGPoint.zero, size: CGSize(width: 20, height: 20))
        disclosureButton.setImage(UIImage(named: "cm_icon_input_eye_normal"), forState: .Normal)
        disclosureButton.setImage(UIImage(named: "cm_icon_input_eye_selected"), forState: .Selected)
        textField.add(disclosureButton: disclosureButton) {
            disclosureButton.selected = !disclosureButton.selected
            textField.resignFirstResponder()
            textField.secureTextEntry = !textField.secureTextEntry
            textField.becomeFirstResponder()
        }
        return textField
    }
}

private struct AnimatedTextInputNumericConfigurator {

    static func generate() -> TextInput {
        let textField = AnimatedTextField()
        textField.clearButtonMode = .WhileEditing
        textField.keyboardType = .DecimalPad
        return textField
    }
}

private struct AnimatedTextInputSelectionConfigurator {

    static func generate() -> TextInput {
        let textField = AnimatedTextField()
        let arrowImageView = UIImageView(image: UIImage(named: "disclosure-indicator"))
        textField.rightView = arrowImageView
        textField.rightViewMode = .Always
        textField.userInteractionEnabled = false
        return textField
    }
}

private struct AnimatedTextInputMultilineConfigurator {

    static func generate() -> TextInput {
        let textView = AnimatedTextView()
        textView.textContainerInset = UIEdgeInsetsZero
        textView.backgroundColor = UIColor.clearColor()
        textView.scrollEnabled = false
        return textView
    }
}
