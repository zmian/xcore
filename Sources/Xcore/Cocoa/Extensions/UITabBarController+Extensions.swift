//
// Xcore
// Copyright © 2017 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

extension UITabBarController {
    open func setTabBarHidden(_ hide: Bool, animated: Bool) {
        let frame = tabBar.frame
        let offsetY = hide ? frame.size.height : -frame.size.height
        var newFrame = frame
        newFrame.origin.y = view.frame.maxY + offsetY
        tabBar.isHidden = false

        UIView.animate(withDuration: animated ? 0.35 : 0.0, delay: 0, options: .beginFromCurrentState) {
            self.tabBar.frame = newFrame
        } completion: { complete in
            if complete {
                self.tabBar.isHidden = hide
            }
        }
    }
}

extension UITabBarController {
    func isRootViewController(_ viewController: UIViewController) -> Bool {
        guard let viewControllers = viewControllers else {
            return false
        }

        if let navigationController = viewController.navigationController {
            return viewControllers.contains(navigationController)
        }

        return viewControllers.contains(viewController)
    }
}

// MARK: - Forwarding

extension UITabBarController {
    // Autorotation Fix. Simply override `supportedInterfaceOrientations` method in
    // any view controller and it would respect that orientation setting per view
    // controller.
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        selectedViewController?.preferredInterfaceOrientations ??
            preferredInterfaceOrientations ??
            selectedViewController?.supportedInterfaceOrientations ??
            super.supportedInterfaceOrientations
    }

    open override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        selectedViewController?.interfaceOrientationForPresentation ??
            interfaceOrientationForPresentation ??
            selectedViewController?.preferredInterfaceOrientationForPresentation ??
            super.preferredInterfaceOrientationForPresentation
    }

    open override var shouldAutorotate: Bool {
        selectedViewController?.isAutorotateEnabled ??
            isAutorotateEnabled ??
            selectedViewController?.shouldAutorotate ??
            super.shouldAutorotate
    }
}
