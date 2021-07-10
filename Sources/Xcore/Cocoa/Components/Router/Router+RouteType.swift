//
// Xcore
// Copyright © 2019 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

extension Router {
    public enum RouteType {
        case viewController(UIViewController)

        case custom((UINavigationController) -> Void)

        public static var custom: Self {
            custom { _ in }
        }
    }
}
