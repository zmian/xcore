//
// Xcore
// Copyright © 2015 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

extension UIWindow {
    /// A boolean value that determines whether the window is visible.
    ///
    /// Useful in KeyPaths (e.g., `UIApplication.shared.window(\.isVisible)`)
    ///
    /// - SeeAlso: https://forums.swift.org/t/19587/46
    public var isVisible: Bool {
        !isHidden
    }
}
