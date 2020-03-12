//
// Xcore
// Copyright © 2017 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

extension UIViewController {
    static func swizzle_hidesBottomBarWhenPushed_runOnceSwapSelectors() {
        swizzle(
            UIViewController.self,
            originalSelector: #selector(getter: UIViewController.hidesBottomBarWhenPushed),
            swizzledSelector: #selector(getter: UIViewController.swizzled_hidesBottomBarWhenPushed)
        )
    }

    /// A swizzled function to ensure that `hidesBottomBarWhenPushed` value is
    /// respected when a view controller is pushed on to a navigation controller.
    ///
    /// The default behavior of the `hidesBottomBarWhenPushed` property of
    /// `UIViewController` is to ignores the value of any subsequent view
    /// controllers that are pushed on to the stack.
    ///
    /// According to the documentation: **If true, the bottom bar remains hidden
    /// until the view controller is popped from the stack.**
    @objc private var swizzled_hidesBottomBarWhenPushed: Bool {
        let value = self.swizzled_hidesBottomBarWhenPushed

        if value, navigationController?.topViewController != self {
            return false
        }

        return value
    }
}
