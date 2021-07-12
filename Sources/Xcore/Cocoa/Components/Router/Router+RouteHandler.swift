//
// Xcore
// Copyright © 2019 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

public protocol RouteHandler: AnyObject {
    typealias Options = Router.Route<Self>.Options

    func route(to route: Router.Route<Self>, options: Options)
}

extension RouteHandler {
    public func route(to route: Router.Route<Self>, options: Options = .push) {
        guard let navigationController = navigationController else {
            #if DEBUG
            Console.log("Unable to find \"navigationController\".")
            #endif
            return
        }

        let routeType = route.configure(self)

        switch routeType {
            case let .viewController(vc):
                options.show(vc, navigationController: navigationController)
            case let .custom(block):
                block(navigationController)
        }
    }

    public func route(to viewController: UIViewController, options: Options = .push) {
        route(to: .init(viewController), options: options)
    }

    public func route(to routes: [Router.Route<Self>], options: Options = .push) {
        route(to: ._group(routes, options: options), options: options)
    }
}

private enum RouteHandlerAssociatedKey {
    static var navigationController = "navigationController"
}

extension RouteHandler {
    public var navigationController: UINavigationController? {
        objc_getAssociatedObject(self, &RouteHandlerAssociatedKey.navigationController) as? UINavigationController
    }

    func _setNavigationController(_ navigationController: UINavigationController?) {
        objc_setAssociatedObject(self, &RouteHandlerAssociatedKey.navigationController, navigationController, .OBJC_ASSOCIATION_ASSIGN)
    }
}
