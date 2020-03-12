//
// Router+RouteKind.swift
// Copyright © 2019 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

extension Router {
    public enum RouteKind {
        case viewController(UIViewController)

        case custom((UINavigationController) -> Void)

        public static var custom: RouteKind {
            custom { _ in }
        }
    }
}
