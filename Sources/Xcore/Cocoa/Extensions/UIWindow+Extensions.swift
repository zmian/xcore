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

// MARK: - Level

extension UIWindow.Level {
    /// Returns the top most level of the window.
    public static var topMost: Self {
        let topWindow = UIApplication.sharedOrNil?.windows.max { $0.windowLevel < $1.windowLevel }
        let windowLevel = topWindow?.windowLevel ?? .normal
        let maxWinLevel = max(windowLevel, .normal)
        return maxWinLevel + 1
    }
}
