//
// Xcore
// Copyright © 2018 Xcore
// MIT license, see LICENSE file for details
//

import Testing
import UIKit
@testable import Xcore

@MainActor
class ViewControllerTestCase {
    let viewController = UIViewController()

    var view: UIView {
        viewController.view
    }

    init() {
        viewController.loadViewIfNeeded()
    }
}
