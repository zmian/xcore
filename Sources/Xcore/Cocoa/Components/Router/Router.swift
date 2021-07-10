//
// Xcore
// Copyright © 2019 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

public class Router {
    private weak var navigationController: UINavigationController?
    private var routeHandlers: [ObjectIdentifier: Any] = [:]

    public init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }

    public func register<T: RouteHandler>(_ handler: @autoclosure () -> T) -> T {
        let key = ObjectIdentifier(T.self)

        guard let existingHandler = routeHandlers[key] as? T else {
            let handler = handler()
            handler._setNavigationController(navigationController)
            routeHandlers[key] = handler
            return handler
        }

        return existingHandler
    }
}
