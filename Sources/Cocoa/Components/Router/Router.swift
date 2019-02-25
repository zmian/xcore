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

// MARK: RouteRepresentable

public protocol RouteRepresentable {
    var routeSource: RouteSourceType { get }
}

public enum RouteSourceType {
    case viewController(UIViewController)
}

extension UIViewController: RouteRepresentable {
    public var routeSource: RouteSourceType {
        return .viewController(self)
    }
}

// MARK: RouteHandler

public protocol RouteHandler: class {
    func route(to route: Route<Self>, animated: Bool)
}

extension RouteHandler {
    public func route(to route: Route<Self>, animated: Bool = true) {
        guard let navigationController = navigationController else {
            #if DEBUG
            Console.log("Unable to find \"navigationController\".")
            #endif
            return
        }

        let routeSource = route.configure(self).routeSource

        switch routeSource {
            case .viewController(let vc):
               navigationController.pushViewController(vc, animated: animated)
        }
    }
}

private struct RouteHandlerAssociatedKey {
    static var navigationController = "navigationController"
}

extension RouteHandler {
    public var navigationController: UINavigationController? {
        return objc_getAssociatedObject(self, &RouteHandlerAssociatedKey.navigationController) as? UINavigationController
    }

    fileprivate func setNavigationController(_ navigationController: UINavigationController?) {
        objc_setAssociatedObject(self, &RouteHandlerAssociatedKey.navigationController, navigationController, .OBJC_ASSOCIATION_ASSIGN)
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

// MARK: Route

/// A routes configuration.
///
/// Simple and powerful way to create multiple routers and navigate from any
/// where.
///
/// `UIViewController` has a router property (`UIViewController.router`) which
/// should be used to navigate to routes.
///
/// **Routes Declaration**
///
/// ```swift
/// final class AuthenticationRouter: RouteHandler { }
///
/// extension Route where Type == AuthenticationRouter {
///     static var login: Route {
///         return Route(LoginViewController())
///     }
/// }
///
/// final class MainRouter: RouteHandler { }
///
/// extension Route where Type == MainRouter {
///     static var home: Route {
///         return Route(HomeViewController())
///     }
///
///     static var profile(user: User) -> Route {
///         return Route(ProfileViewController(user: user))
///     }
///
///     static var likes(user: User) -> Route {
///         return Route { router in
///             return LikesViewController(user: user).apply {
///                 $0.didTapOnProfile {
///                    router.route(to: .profile(user: user))
///                 }
///             }
///         }
///     }
/// }
/// ```
///
/// **Register the child routers with the parent Router**
///
/// ```
/// extension Router {
///     var main: MainRouter {
///         return register(MainRouter())
///     }
///
///    var auth: AuthenticationRouter {
///        return register(AuthenticationRouter())
///    }
/// }
/// ```
///
/// **Usage**
///
/// ```swift
/// final class HomeViewController: UIViewController {
///     private let user: User
///
///     private func showProfile() {
///         router.main.route(to: .profile(user: user))
///     }
///
///     private func showLogin() {
///         router.auth.route(to: .login)
///     }
/// }
/// ```
public struct Route<Type: RouteHandler> {
    public var identifier: String
    public var configure: (Type) -> RouteRepresentable

    public init(identifier: String? = nil, _ configure: @escaping ((Type) -> RouteRepresentable)) {
        self.identifier = identifier ?? "___defaultIdentifier___"
        self.configure = configure
    }

    public init(_ configure: @escaping @autoclosure () -> RouteRepresentable) {
        self.init { _ -> RouteRepresentable in
            configure()
        }
    }
}

// MARK: Route

public class Router {
    private weak var navigationController: UINavigationController?
    private var routeHandlers: [String: Any] = [:]

    fileprivate init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }

    public func register<T: RouteHandler>(_ handler: @autoclosure () -> T) -> T {
        let key = NSStringFromClass(T.self)

        guard let existingHandler = routeHandlers[key] as? T else {
            var handler = handler()
            handler.setNavigationController(navigationController)
            routeHandlers[key] = handler
            return handler
        }

        return existingHandler
    }
}

// MARK: Extensions

extension UIViewController {
    public var router: Router {
        guard let navigationController = navigationController else {
            if let navController = self as? UINavigationController {
                return navController._navigationControllerRouter
            }

            fatalError("Router requires a navigation controller.")
        }

        return navigationController._navigationControllerRouter
    }
}

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
