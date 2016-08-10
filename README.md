![](https://github.com/jobandtalent/AnimatedTextInput/blob/master/Assets/Jobandtalent%20Eng.png)


# AnimatedTextInput [![GitHub version](https://badge.fury.io/gh/jobandtalent%2FAnimatedTextInput.svg)](https://badge.fury.io/gh/jobandtalent%2FAnimatedTextInput)
iOS custom text input component used in the [Jobandtalent app](https://itunes.apple.com/app/id665060895).

![](https://github.com/jobandtalent/AnimatedTextInput/blob/master/Assets/general.gif)

## Installation
Use cocoapods to install this custom control in your project.

```
pod 'AnimatedTextInput', '~> 0.3.0'
```

## Usage

Use the main class `AnimatedTextInput`. Create it either by code or dragging a new instance of `UIView` into your storyboard/nib file and setting its class in the identity inspector.

### Types
Currently there are 6 different types, defined in the `AnimatedTextInputType` enum.

- Text: basic text input, same behaviour as UITextField.

- Password: secure text entry and `eye` button for revealing its content.

- Numeric: numeric text input.

- Selection: user interaction for the text input is disabled. A `tapAction` is expected and called when the text input is pressed. Normally used to present a set of options and modify its state after one option is selected.

- Multiline: similar behaviour to UITextView with no scrolling. The `intrinsicContentSize` of the view will grow as the user types. If you need this behaviour and you use autolayout, pin either the bottom or the top, otherwise the view won't grow (like you would do with a `UILabel`).

- Generic: expects a configured `TextInput`. Use this if you need a UITextField or UITextView with your custom behaviour. Check `TextInput` and `TextInputDelegate` protocols and create a class conforming to them.

To switch between types, you can simply use the `type` property assining one of the values available in the `AnimatedTextInputType` enum.

```swift
textInput.type = .numeric
```

### Styles

Creating a new visual style is as easy as creating a new `struct` that conforms to the `AnimatedTextInputStyle` protocol.

For example:

```swift

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
```

Then, use the `style` property to set it.

```swift
textInput.style = CustomTextInputStyle()
```

### Other considerations

- You can use `AnimatedTextInput` as a replacement for either `UITextField` or `UITextView`. To set or retrieve the input text, use the `text` property.

- This control provides an easy way of setting a counter label. Just call the function `showCharacterCounterLabel(with:)` and give it a maximum number of characters.

- `AnimatedTextInput` has its own delegate methods, very similar to `UITextFieldDelegate` and `UITextViewDelegate`.

Download and check the Example project for more examples.

---

#### One last question: Why create a `TextInput` abstraction and not use `UITextField` or `UITextView` instead?
From an API point of view, we only wanted to deal with one control. However, we needed some behaviours that were not supported by `UITextField` or `UITextView`. For instance, we wanted `AnimatedTextInput` to support multiline, but `UITextField` does not support it. We also wanted secure text entry for the password type, but `UITextView` does not support it. That's why we ended up creating `TextInput` abstraction.
