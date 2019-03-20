import UIKit

public struct AnimatedTextInputFieldConfigurator {
    
    public enum AnimatedTextInputType {
        case standard
        case email
        case password(toggleable: Bool)
        case numeric
        case phone
        case selection
        case customSelection(isRightViewEnabled: Bool, rightViewImage: UIImage?)
        case multiline()
        case multilineRestricted(maxHeight: CGFloat)
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
        case .phone:
            return AnimatedTextInputPhoneConfigurator.generate()
        case .selection:
            return AnimatedTextInputSelectionConfigurator.generate()
        case .multiline():
            return AnimatedTextInputMultilineConfigurator.generate(using: nil)
        case .multilineRestricted(let maxHeight):
            return AnimatedTextInputMultilineConfigurator.generate(using: maxHeight)
        case .generic(let textInput):
            return textInput
        case .customSelection(let isRightViewEnabled, let rightViewImage):
            return AnimatedTextInputCustomSelectionConfigurator.generate(isRightViewEnabled: isRightViewEnabled, rightViewImage: rightViewImage)
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
            disclosureButton.frame = CGRect(origin: CGPoint.zero, size: CGSize(width: 20, height: 20))
            let bundle = Bundle(path: Bundle(for: AnimatedTextInput.self).path(forResource: "AnimatedTextInput", ofType: "bundle")!)
            let normalImage = UIImage(named: "cm_icon_input_eye_normal", in: bundle, compatibleWith: nil)
            let selectedImage = UIImage(named: "cm_icon_input_eye_selected", in: bundle, compatibleWith: nil)
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

fileprivate struct AnimatedTextInputPhoneConfigurator {
    
    static func generate() -> TextInput {
        let textField = AnimatedTextField()
        textField.clearButtonMode = .whileEditing
        textField.keyboardType = .phonePad
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

fileprivate struct AnimatedTextInputCustomSelectionConfigurator {
    
    static func generate(isRightViewEnabled: Bool = true, rightViewImage: UIImage? = nil) -> TextInput {
        let textField = AnimatedTextField()
        if isRightViewEnabled && rightViewImage != nil {
            let arrowImageView = UIImageView(image: rightViewImage)
            textField.rightView = arrowImageView
            textField.rightViewMode = .always
        }
        textField.isUserInteractionEnabled = false
        return textField
    }
}


fileprivate struct AnimatedTextInputMultilineConfigurator {
    
    static func generate(using maxHeight: CGFloat?) -> TextInput {
        let textView = AnimatedTextView()
        textView.textContainerInset = .zero
        textView.backgroundColor = .clear
        textView.isScrollEnabled = false
        textView.autocorrectionType = .no

        // Use the maximum allowed height if one is provided by the caller.
        if let providedMaxHeight = maxHeight {
            
            // Pass the value along to the TextView.
            textView.maximumHeightOfMultilineLabel = providedMaxHeight
            
            // Add a constraint to set the maximum height that must not be exeeded.
            let constraint = NSLayoutConstraint(item: textView, attribute: .height, relatedBy: .lessThanOrEqual, toItem: nil, attribute: .height, multiplier: 1, constant: providedMaxHeight)
            constraint.identifier = "MaxHeightOfTextView"
            textView.view.addConstraint(constraint)
        }
        return textView
    }
}
