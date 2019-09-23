//
// Router+Extensions.swift
//
// Copyright © 2019 Xcore
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

import UIKit

extension Router {
    /// Returns the shared router.
    public static var shared: Router? {
        guard let topViewController = UIApplication.sharedOrNil?.delegate?.window??.topViewController else {
            return nil
        }

        return topViewController._router
    }
}

// MARK: - UIViewController

extension UINavigationController {
    private struct AssociatedKey {
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
            fatalError("Router requires a navigation controller.")
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

// MARK: - XCCollectionViewDataSource

extension XCCollectionViewDataSource {
    public var router: Router {
        guard let collectionView = collectionView else {
            return Router(navigationController: nil)
        }

        guard let router = collectionView.viewController?.router else {
            #if DEBUG
            if isDebuggerAttached {
                fatalError("Datasource doesn't have a view controller.")
            }
            #endif
            return Router(navigationController: nil)
        }

        return router
    }
}

// MARK: - XCTableViewDataSource

extension XCTableViewDataSource {
    public var router: Router {
        guard let tableView = tableView else {
            return Router(navigationController: nil)
        }

        guard let router = tableView.viewController?.router else {
            #if DEBUG
            if isDebuggerAttached {
                fatalError("Datasource doesn't have a view controller.")
            }
            #endif
            return Router(navigationController: nil)
        }

        return router
    }
}
