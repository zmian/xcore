//
// Router+Route.swift
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
    /// extension Router.Route where Type == AuthenticationRouter {
    ///     static var login: Router.Route {
    ///         return .init(LoginViewController())
    ///     }
    /// }
    ///
    /// final class MainRouter: RouteHandler { }
    ///
    /// extension Router.Route where Type == MainRouter {
    ///     static var home: Router.Route {
    ///         return .init(HomeViewController())
    ///     }
    ///
    ///     static var profile(user: User) -> Router.Route {
    ///         return .init(ProfileViewController(user: user))
    ///     }
    ///
    ///     static var likes(user: User) -> Router.Route {
    ///         return .init { router in
    ///             return LikesViewController(user: user).apply {
    ///                 $0.didTapOnProfile {
    ///                    router.route(to: .profile(user: user))
    ///                 }
    ///             }
    ///         }
    ///     }
    ///
    ///     static var successAlert(message: String) -> Router.Route {
    ///         return .custom { _ in
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
        public var id: String
        public var configure: (Type) -> RouteKind

        public init(id: String? = nil, _ configure: @escaping ((Type) -> RouteKind)) {
            self.id = id ?? "___defaultId___"
            self.configure = configure
        }

        public init(id: String? = nil, _ configure: @escaping ((Type) -> UIViewController)) {
            self.id = id ?? "___defaultId___"
            self.configure = { router -> RouteKind in
                .viewController(configure(router))
            }
        }

        public init(_ configure: @escaping @autoclosure () -> UIViewController) {
            self.init { _ -> RouteKind in
                .viewController(configure())
            }
        }

        public static func custom(id: String? = nil, _ configure: @escaping (Type) -> Void) -> Route {
            return .init(id: id) { router -> RouteKind in
                configure(router)
                return .custom
            }
        }

        static func _group(_ routes: [Route<Type>], animated: Bool) -> Route<Type> {
            return Route { router -> RouteKind in
                var viewControllers: [UIViewController] = []

                for route in routes {
                    guard case .viewController(let vc) = route.configure(router) else {
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

                    navigationController.pushViewController(viewControllers, animated: animated)
                }
            }
        }
    }
}
