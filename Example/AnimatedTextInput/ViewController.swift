import UIKit
import AnimatedTextInput

class ViewController: UIViewController {

    @IBOutlet var textInputs: [AnimatedTextInput]!
    private var isBlue = true

    override func viewDidLoad() {
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
    }

    func tap() {
        let vc = UIViewController()
        vc.view.backgroundColor = UIColor.blueColor()
        presentViewController(vc, animated: true) {
            if let text = self.textInputs[3].text where text.isEmpty {
                self.textInputs[3].set(text: "Some option the user did select")
            } else {
                self.textInputs[3].set(text: nil)
            }
            vc.dismissViewControllerAnimated(true, completion: nil)
        }
    }

    @IBAction func showError(sender: AnyObject) {
        textInputs[0].show(error: "You made an error!", placeholderText: "Type something")
    }

    @IBAction func toggleStyle(sender: AnyObject) {
        textInputs[1].style = isBlue ? CustomTextInputStyle() : AnimatedTextInputStyleBlue()
        isBlue = !isBlue
    }

    @IBAction func backgroundTap(sender: AnyObject) {
        for input in textInputs {
            input.resignFirstResponder()
        }
    }
}

struct CustomTextInputStyle: AnimatedTextInputStyle {

    let activeColor = UIColor.orangeColor()
    let inactiveColor = UIColor.grayColor().colorWithAlphaComponent(0.3)
    let errorColor = UIColor.redColor()
    let textInputFont = UIFont.systemFontOfSize(14)
    let textInputFontColor = UIColor.blackColor()
    let placeholderMinFontSize: CGFloat = 9
    let counterLabelFont: UIFont? = UIFont.systemFontOfSize(9)
    let leftMargin: CGFloat = 25
    let topMargin: CGFloat = 20
    let rightMargin: CGFloat = 0
    let bottomMargin: CGFloat = 10
    let yHintPositionOffset: CGFloat = 7
}
