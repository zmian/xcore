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

// MARK: RouteKind

public enum RouteKind {
    case viewController(UIViewController)

    case custom((UINavigationController) -> Void)

    public static var custom: RouteKind {
        return RouteKind.custom { _ in }
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

        let routeKind = route.configure(self)

        switch routeKind {
            case .viewController(let vc):
               navigationController.pushViewController(vc, animated: animated)
            case .custom(let block):
                block(navigationController)
        }
    }

    public func route(to routes: Route<Self>..., animated: Bool = true) {
        let routesGroup = Route<Self>.group(routes, animated: animated, routeHandler: self)
        route(to: routesGroup, animated: animated)
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
    public var configure: (Type) -> RouteKind

    public init(identifier: String? = nil, _ configure: @escaping ((Type) -> RouteKind)) {
        self.identifier = identifier ?? "___defaultIdentifier___"
        self.configure = configure
    }

    public init(identifier: String? = nil, _ configure: @escaping ((Type) -> UIViewController)) {
        self.identifier = identifier ?? "___defaultIdentifier___"
        self.configure = { router -> RouteKind in
            .viewController(configure(router))
        }
    }

    public init(_ configure: @escaping @autoclosure () -> UIViewController) {
        self.init { _ -> RouteKind in
            .viewController(configure())
        }
    }

    fileprivate static func group<Handler: RouteHandler>(_ routes: [Route<Handler>], animated: Bool = true, routeHandler: Handler) -> Route<Handler> {
        return Route<Handler> { router -> RouteKind in
            var viewControllers: [UIViewController] = []

            for route in routes {
                guard case .viewController(let vc) = route.configure(routeHandler) else {
                    #if DEBUG
                    Console.log("Route \(route.identifier) contains custom route. This will lead to unexpected behavior. Please handle the use case separately.")
                    #endif
                    continue
                }

                viewControllers.append(vc)
            }

            return .custom { navigationController in
                guard !viewControllers.isEmpty else {
                    return
                }

                navigationController.pushViewController(viewControllers, animated: animated)
            }
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
            let handler = handler()
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
