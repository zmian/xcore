//
// Xcore
// Copyright © 2017 Xcore
// MIT license, see LICENSE file for details
//

#if canImport(UIKit)
import UIKit

extension UITabBarController {
    func isRootViewController(_ viewController: UIViewController) -> Bool {
        guard let viewControllers else {
            return false
        }

        if let navigationController = viewController.navigationController {
            return viewControllers.contains(navigationController)
        }

        return viewControllers.contains(viewController)
    }
}
#endif
