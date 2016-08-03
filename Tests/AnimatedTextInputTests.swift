import KIF
import UIKit
import XCTest
import Nimble
import AnimatedTextInput
@testable import AnimatedTextInput_Example

class AnimatedTextInputTests: AcceptanceTestCase {

    let inputAccessibilityLabel = "standard_text_input"

    func testStandardInputHasCorrectText() {
        tester().waitForAnimationsToFinish()
        let testText = "hello"
        let standardTextInput = tester().waitForViewWithAccessibilityLabel(inputAccessibilityLabel) as! AnimatedTextInput
        standardTextInput.becomeFirstResponder()
        tester().enterTextIntoCurrentFirstResponder(testText)
        tester().waitForTimeInterval(0.5)

        expect(standardTextInput.text).to(equal(testText.capitalizedString))
    }

    func testInputIsActive() {
        tester().waitForAnimationsToFinish()

        let standardTextInput = tester().waitForViewWithAccessibilityLabel(inputAccessibilityLabel) as! AnimatedTextInput
        standardTextInput.becomeFirstResponder()

        expect(standardTextInput.isActive).to(beTrue())
    }

    func testInputIsInActive() {
        tester().waitForAnimationsToFinish()
        let standardTextInput = tester().waitForViewWithAccessibilityLabel(inputAccessibilityLabel) as! AnimatedTextInput
        standardTextInput.becomeFirstResponder()
        tester().waitForAnimationsToFinish()
        standardTextInput.resignFirstResponder()

        expect(standardTextInput.isActive).to(beFalse())
    }

    func testStandardInputSetText() {
        tester().waitForAnimationsToFinish()
        let initialText = "hello"
        let typedText = " world!"
        let standardTextInput = tester().waitForViewWithAccessibilityLabel(inputAccessibilityLabel) as! AnimatedTextInput
        standardTextInput.text = initialText
        standardTextInput.becomeFirstResponder()
        tester().enterTextIntoCurrentFirstResponder(typedText)
        tester().waitForTimeInterval(0.5)

        expect(standardTextInput.text).to(equal(initialText + typedText))
    }

    func testTapInputToBecomeActive() {
        tester().waitForAnimationsToFinish()
        let standardTextInput = tester().waitForViewWithAccessibilityLabel(inputAccessibilityLabel) as! AnimatedTextInput
        tester().tapScreenAtPoint(standardTextInput.center)

        expect(standardTextInput.isActive).to(beTrue())
    }

    func testPlaceholderActiveState() {
        tester().waitForAnimationsToFinish()
        let standardTextInput = tester().waitForViewWithAccessibilityLabel(inputAccessibilityLabel) as! AnimatedTextInput
        let style = CustomTextInputStyle()
        standardTextInput.style = style

        //how to get text layer?
        let placeholder = CATextLayer()

        standardTextInput.becomeFirstResponder()
        tester().waitForAnimationsToFinish()

        XCTAssertEqual(placeholder.fontSize, style.placeholderMinFontSize)
    }

    override func afterEach() {
        super.afterEach()
        let viewController = rootViewController as! AnimatedTextInput_Example.ViewController
        viewController.textInputs.forEach{
            $0.text = ""
            $0.resignFirstResponder()
        }
    }

    private func openExampleViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle(forClass: ViewController.self))
        let viewController = storyboard.instantiateViewControllerWithIdentifier("ViewController")
        presentViewController(viewController)
    }
}
