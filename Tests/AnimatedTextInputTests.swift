//
//  AnimatedTextInputTests.swift
//  AnimatedTextInput
//
//  Created by Daniel Garcia on 02/08/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//
import KIF
import UIKit
import XCTest
import AnimatedTextInput
@testable import AnimatedTextInput_Example

class AnimatedTextInputTests: AcceptanceTestCase {

    func testDemo() {
        tester().waitForAnimationsToFinish()
        let testText = "hello"
        let standardTextInput = tester().waitForViewWithAccessibilityLabel("standard_text_input") as! AnimatedTextInput
        standardTextInput.becomeFirstResponder()
        tester().enterTextIntoCurrentFirstResponder(testText)
        tester().waitForTimeInterval(0.5)

        XCTAssertEqual(standardTextInput.text, testText.capitalizedString)
    }

    private func openExampleViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle(forClass: ViewController.self))
        let viewController = storyboard.instantiateViewControllerWithIdentifier("ViewController")
        presentViewController(viewController)
    }

}
