import XCTest
import KIF

class AcceptanceTestCase: KIFTestCase {
    
    private var originalRootViewController: UIViewController?
    var rootViewController: UIViewController? {
        get {
            return UIApplication.sharedApplication().keyWindow?.rootViewController
        }

        set(newRootViewController) {
            UIApplication.sharedApplication().keyWindow?.rootViewController = newRootViewController
        }
    }

    override func tearDown() {
        super.tearDown()
//        if let originalRootViewController = originalRootViewController {
//            rootViewController = originalRootViewController
//        }
    }

    func presentViewController(viewController: UIViewController) {
        originalRootViewController = rootViewController
        rootViewController = viewController
    }
}

extension XCTestCase {

    func tester(file: String = #file, line: Int = #line) -> KIFUITestActor {
        return KIFUITestActor(inFile: file, atLine: line, delegate: self)
    }

    func system(file: String = #file, line: Int = #line) -> KIFSystemTestActor {
        return KIFSystemTestActor(inFile: file, atLine: line, delegate: self)
    }
}
