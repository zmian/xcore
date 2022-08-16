//
// Xcore
// Copyright © 2014 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

extension UINavigationController {
    /// A convenience property to set root view controller without animation.
    open var rootViewController: UIViewController? {
        get { viewControllers.first }
        set {
            var rvc: [UIViewController] = []
            if let vc = newValue {
                rvc = [vc]
            }
            setViewControllers(rvc, animated: false)
        }
    }
}
