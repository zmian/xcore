//
// Xcore
// Copyright © 2015 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

extension UIWindow {
    /// A Boolean property indicating whether the window is visible.
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
        let topWindow = UIApplication.sharedOrNil?.sceneWindows.max { $0.windowLevel < $1.windowLevel }
        let windowLevel = topWindow?.windowLevel ?? .normal
        let maxWinLevel = max(windowLevel, .normal)
        return maxWinLevel + 1
    }

    /// The level for a privacy screen.
    ///
    /// Windows at this level appear on top of the status bar and alerts.
    public static var privacy: Self {
        alert + 1000
    }
}

// MARK: - Style

extension WindowStyle {
    /// The style for a privacy screen.
    ///
    /// It appear on top of your app's main window, status bar and alerts.
    public static var privacy: Self {
        .init(label: "Privacy Screen", level: .privacy)
    }
}
