//
// Xcore
// Copyright © 2014 Xcore
// MIT license, see LICENSE file for details
//

#if canImport(UIKit)
import UIKit

extension UINavigationController {
    /// A property to get and set root view controller without animation.
    @objc open var rootViewController: UIViewController? {
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
#endif
