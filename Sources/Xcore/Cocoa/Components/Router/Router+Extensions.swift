//
// Xcore
// Copyright © 2019 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

extension Router {
    /// Returns the current router of the top level navigation controller.
    public static var current: Router? {
        guard let navigationController = UIApplication.sharedOrNil?.topNavigationController else {
            return nil
        }

        return navigationController._router
    }

    /// Returns the router of the main app window.
    public static var app: Router? {
        guard
            let rvc = UIApplication.sharedOrNil?.delegate?.window??.rootViewController,
            let navigationController = UIApplication.topViewController(rvc)
        else {
            return nil
        }

        return navigationController.router
    }
}

// MARK: - UIViewController

extension UINavigationController {
    private enum AssociatedKey {
        static var router = "router"
    }

    fileprivate var _navigationControllerRouter: Router {
        get {
            let router: Router

            if let existingRouter: Router = associatedObject(&AssociatedKey.router) {
                router = existingRouter
            } else {
                router = Router(navigationController: self)
                self._navigationControllerRouter = router
            }

            return router
        }
        set { setAssociatedObject(&AssociatedKey.router, value: newValue) }
    }
}

// MARK: - UIViewController

extension UIViewController {
    public var router: Router {
        guard let router = _router else {
            #if DEBUG
            if AppInfo.isDebuggerAttached {
                fatalError("Router requires a navigation controller.")
            }
            #endif
            return Router(navigationController: nil)
        }

        return router
    }

    fileprivate var _router: Router? {
        guard let navigationController = navigationController else {
            if let navController = self as? UINavigationController {
                return navController._navigationControllerRouter
            }

            return nil
        }

        return navigationController._navigationControllerRouter
    }
}
