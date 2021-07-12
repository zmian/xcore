//
// Xcore
// Copyright © 2019 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

extension Router {
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
    /// final class AuthenticationRouter: RouteHandler {}
    ///
    /// extension Router.Route where Type == AuthenticationRouter {
    ///     static var login: Self {
    ///         .init(LoginViewController())
    ///     }
    /// }
    ///
    /// final class MainRouter: RouteHandler {}
    ///
    /// extension Router.Route where Type == MainRouter {
    ///     static var home: Self {
    ///         .init(HomeViewController())
    ///     }
    ///
    ///     static var profile(user: User) -> Self {
    ///         .init(ProfileViewController(user: user))
    ///     }
    ///
    ///     static var likes(user: User) -> Self {
    ///         .init { router in
    ///             LikesViewController(user: user).apply {
    ///                 $0.didTapOnProfile {
    ///                    router.route(to: .profile(user: user))
    ///                 }
    ///             }
    ///         }
    ///     }
    ///
    ///     static var successAlert(message: String) -> Self {
    ///         .custom { _ in
    ///             alert(title: "Success", message: message)
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
    ///         register(.init())
    ///     }
    ///
    ///     var auth: AuthenticationRouter {
    ///         register(.init())
    ///     }
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
        public var id: String
        public var configure: (Type) -> RouteType

        public init(id: String? = nil, _ configure: @escaping ((Type) -> RouteType)) {
            self.id = id ?? "___defaultId___"
            self.configure = configure
        }

        public init(id: String? = nil, _ configure: @escaping ((Type) -> UIViewController)) {
            self.id = id ?? "___defaultId___"
            self.configure = { router -> RouteType in
                .viewController(configure(router))
            }
        }

        public init(_ configure: @autoclosure @escaping () -> UIViewController) {
            self.init { _ -> RouteType in
                .viewController(configure())
            }
        }

        public static func custom(id: String? = nil, _ configure: @escaping (Type) -> Void) -> Self {
            .init(id: id) { router -> RouteType in
                configure(router)
                return .custom
            }
        }
    }
}

// MARK: - Group

extension Router.Route {
    static func _group(_ routes: [Self], options: Self.Options) -> Self {
        .init { router -> Router.RouteType in
            var viewControllers: [UIViewController] = []

            for route in routes {
                guard case let .viewController(vc) = route.configure(router) else {
                    #if DEBUG
                    Console.log("Route \(route.id) contains custom route. This will lead to unexpected behavior. Please handle the use case separately.")
                    #endif
                    continue
                }

                viewControllers.append(vc)
            }

            return .custom { navigationController in
                guard !viewControllers.isEmpty else {
                    return
                }

                options.show(viewControllers, navigationController: navigationController)
            }
        }
    }
}
