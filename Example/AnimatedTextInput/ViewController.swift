import UIKit
import AnimatedTextInput

class ViewController: UIViewController {

    @IBOutlet var textInputs: [AnimatedTextInput]!
    fileprivate var isBlue = true

    override func viewDidLoad() {
        textInputs[0].accessibilityLabel = "standard_text_input"
        textInputs[0].placeHolderText = "Normal text"

        textInputs[1].placeHolderText = "Password"
        textInputs[1].type = .password

        textInputs[2].placeHolderText = "Numeric"
        textInputs[2].type = .numeric

        textInputs[3].placeHolderText = "Selection"
        textInputs[3].type = .selection
        textInputs[3].tapAction = { [weak self] in
            guard let strongself = self else { return }
            strongself.tap()
        }

        textInputs[4].placeHolderText = "Multiline"
        textInputs[4].type = .multiline
        textInputs[4].showCharacterCounterLabel(with: 160)


        // Text attributes (as well as any other property, can be configured using styles (AnimatedTextInputStyle) or using textInput's propoerties
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 15
        textInputs[4].textAttributes = [NSParagraphStyleAttributeName : paragraphStyle,
                                        NSFontAttributeName : UIFont.boldSystemFont(ofSize: 18)]
    }

    func tap() {
        let vc = UIViewController()
        vc.view.backgroundColor = UIColor.blue
        present(vc, animated: true) {
            if let text = self.textInputs[3].text, text.isEmpty {
                self.textInputs[3].text = "Some option the user did select"
            } else {
                self.textInputs[3].text = nil
            }
            vc.dismiss(animated: true, completion: nil)
        }
    }

    @IBAction func showError(_ sender: AnyObject) {
        textInputs[0].show(error: "You made an error!", placeholderText: "Type something")
    }

    @IBAction func toggleStyle(_ sender: AnyObject) {
        textInputs[1].style = isBlue ? CustomTextInputStyle() : AnimatedTextInputStyleBlue()
        isBlue = !isBlue
    }

    @IBAction func backgroundTap(_ sender: AnyObject) {
        for input in textInputs {
            input.resignFirstResponder()
        }
    }
}

struct CustomTextInputStyle: AnimatedTextInputStyle {

    let activeColor = UIColor.orange
    let inactiveColor = UIColor.gray.withAlphaComponent(0.3)
    let lineInactiveColor = UIColor.gray.withAlphaComponent(0.3)
    let errorColor = UIColor.red
    let textInputFont = UIFont.systemFont(ofSize: 14)
    let textInputFontColor = UIColor.black
    let placeholderMinFontSize: CGFloat = 9
    let counterLabelFont: UIFont? = UIFont.systemFont(ofSize: 9)
    let leftMargin: CGFloat = 25
    let topMargin: CGFloat = 20
    let rightMargin: CGFloat = 0
    let bottomMargin: CGFloat = 10
    let yHintPositionOffset: CGFloat = 7
    let yPlaceholderPositionOffset: CGFloat = 0
    public let textAttributes: [String: Any]? = nil
}
