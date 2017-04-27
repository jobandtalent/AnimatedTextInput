import FBSnapshotTestCase
import XCTest
import AnimatedTextInput

class AnimatedTextInputSnapshotTests: FBSnapshotTestCase {
    private let sut = AnimatedTextInput()
    private var containerView: UIView!

    override func setUp() {
        super.setUp()
        recordMode = false
        setupViews()
    }

    func testNormalState() {
        sut.placeHolderText = "Placeholder"

        verifySUT()
    }

    func testEmptyActiveState() {
        sut.placeHolderText = "Placeholder"
        sut.becomeFirstResponder()

        verifySUT()
    }

    func testFilledActiveState() {
        sut.placeHolderText = "Placeholder"
        sut.text = "Some text"
        sut.becomeFirstResponder()

        verifySUT()
    }

    func testInactiveFilledState() {
        sut.placeHolderText = "Placeholder"
        sut.text = "Input text"

        verifySUT()
    }

    //Multiline type

    func testNormalStateMultiline() {
        sut.type = .multiline
        sut.placeHolderText = "Placeholder"

        verifySUT()
    }

    func testEmptyActiveStateMultiline() {
        sut.type = .multiline
        sut.placeHolderText = "Placeholder"
        sut.becomeFirstResponder()

        verifySUT()
    }

    func testFilledActiveStateMultiline() {
        sut.type = .multiline
        sut.placeHolderText = "Placeholder"
        sut.text = "A very long text to fill a few lines. A very long text to fill a few lines. A very long text to fill a few lines. A very long text to fill a few lines"
        sut.becomeFirstResponder()

        verifySUT()
    }

    func testFilledActiveStateMultilineWithCounter() {
        sut.type = .multiline
        sut.placeHolderText = "Placeholder"
        sut.text = "A very long text to fill a few lines. A very long text to fill a few lines. A very long text to fill a few lines. A very long text to fill a few lines"
        sut.showCharacterCounterLabel()
        sut.becomeFirstResponder()

        verifySUT()
    }

    func testInactiveFilledStateMultiline() {
        sut.type = .multiline
        sut.placeHolderText = "Placeholder"
        sut.text = "Input text"

        verifySUT()
    }

    //Multiline type

    func testNormalStateSelection() {
        sut.type = .selection
        sut.placeHolderText = "Placeholder"

        verifySUT()
    }

    func testInactiveFilledStateSelection() {
        sut.type = .selection
        sut.placeHolderText = "Placeholder"
        sut.text = "Input text"

        verifySUT()
    }

    func testAnimatedTextViewActiveCustomStyle() {
        sut.type = .standard
        sut.style = CustomTextInputStyle()
        sut.placeHolderText = "Placeholder"
        sut.text = "Input text"
        sut.becomeFirstResponder()

        verifySUT()
    }

    func testAnimatedTextFieldActiveCustomStyle() {
        sut.type = .multiline
        sut.style = CustomTextInputStyle()
        sut.placeHolderText = "Placeholder"
        sut.text = "Input text"
        sut.becomeFirstResponder()

        verifySUT()
    }

    // Helpers
    private func setupViews() {
        let containerFrame = CGRect(origin: .zero, size: CGSize(width: 320, height: 200))
        containerView = UIView(frame: containerFrame)
        sut.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(sut)
        addConstraints()
    }

    private func verifySUT() {
        FBSnapshotVerifyView(containerView)
        FBSnapshotVerifyLayer(containerView.layer)
    }

    // Constraints

    func addConstraints() {
        let leading = NSLayoutConstraint(item: containerView,
                           attribute: .leading,
                           relatedBy: .equal,
                           toItem: sut,
                           attribute: .leading,
                           multiplier: 1.0,
                           constant: 0)
        let trailing = NSLayoutConstraint(item: containerView,
                           attribute: .trailing,
                           relatedBy: .equal,
                           toItem: sut,
                           attribute: .trailing,
                           multiplier: 1.0,
                           constant: 0)
        let top = NSLayoutConstraint(item: containerView,
                           attribute: .top,
                           relatedBy: .equal,
                           toItem: sut,
                           attribute: .top,
                           multiplier: 1.0,
                           constant: 0)
        let constraints = [leading, trailing, top]
        constraints.forEach { $0.isActive = true }
        containerView.addConstraints(constraints)
    }
}
