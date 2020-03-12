//
// Xcore
// Copyright © 2018 Xcore
// MIT license, see LICENSE file for details
//

import XCTest
import UIKit
@testable import Xcore

class ViewControllerTestCase: TestCase {
    let viewController = UIViewController()
    var view: UIView {
        viewController.view
    }

    override func setUp() {
        super.setUp()
        viewController.loadViewIfNeeded()
    }

    override func tearDown() {
        super.tearDown()
    }
}
