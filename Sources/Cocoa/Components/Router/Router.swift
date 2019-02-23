//
// Router.swift
//
// Copyright © 2019 Zeeshan Mian
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

public protocol RouteHandler {
    associatedtype Route

    func route(to route: Route)
}

private struct RouteHandlerAssociatedKey {
    static var viewController = "viewController"
}

extension RouteHandler {
    public var navigationController: UINavigationController? {
        return viewController?.navigationController
    }

    fileprivate var viewController: UIViewController? {
        get { return objc_getAssociatedObject(self, &RouteHandlerAssociatedKey.viewController) as? UIViewController }
        set { objc_setAssociatedObject(self, &RouteHandlerAssociatedKey.viewController, newValue, .OBJC_ASSOCIATION_ASSIGN) }
    }
}

extension RouteHandler {
    /// A convenience method to pop to specified subclass of `UIViewController` type.
    /// If the given type of view controller is not found then it pops to the root
    /// view controller.
    ///
    /// - Parameters:
    ///   - type: The view controller type to pop to.
    ///   - animated: Set this value to `true` to animate the transition.
    ///               Pass `false` if you are setting up a navigation controller
    ///               before its view is displayed.
    /// - Returns: The view controller instance of the specified type `T`.
    @discardableResult
    public func popToViewController<T: UIViewController>(_ type: T.Type, animated: Bool) -> T? {
        guard let navigationController = navigationController else {
            return nil
        }

        guard let viewController = navigationController.viewControllers.lastElement(type: type) else {
            navigationController.popToRootViewController(animated: animated)
            return nil
        }

        navigationController.popToViewController(viewController, animated: animated)
        return viewController
    }
}

public class Router {
    private weak var viewController: UIViewController?

    fileprivate init(viewController: UIViewController) {
        self.viewController = viewController
    }

    public func configure<T: RouteHandler>(_ handler: T) -> T {
        var handler = handler
        handler.viewController = viewController
        return handler
    }
}

// MARK: Extensions

extension UIViewController {
    private struct AssociatedKey {
        static var router = "router"
    }

    public var router: Router {
        get {
            let router: Router

            if let existingRouter: Router = associatedObject(&AssociatedKey.router) {
                router = existingRouter
            } else {
                router = Router(viewController: self)
                self.router = router
            }

            return router
        }
        set { setAssociatedObject(&AssociatedKey.router, value: newValue) }
    }
}

extension XCCollectionViewDataSource {
    public var router: Router {
        guard let router = collectionView?.viewController?.router else {
            #if DEBUG
            if isDebuggerAttached {
                fatalError("Datasource doesn't have a view controller.")
            }
            #endif
            return Router(viewController: UIViewController())
        }

        return router
    }
}

extension XCTableViewDataSource {
    public var router: Router {
        guard let router = tableView?.viewController?.router else {
            #if DEBUG
            if isDebuggerAttached {
                fatalError("Datasource doesn't have a view controller.")
            }
            #endif
            return Router(viewController: UIViewController())
        }

        return router
    }
}
