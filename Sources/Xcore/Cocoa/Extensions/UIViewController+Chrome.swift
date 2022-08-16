//
// Xcore
// Copyright © 2016 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

extension UIViewController {
    /// This configuration exists to allow some of the properties to be configured
    /// to match app's appearance style.
    ///
    /// The `UIAppearance` protocol doesn't work when the stored properites
    /// are set using associated object.
    ///
    /// **For example:**
    ///
    /// ```swift
    /// UIViewController.defaultAppearance.tintColor = .gray
    /// ```
    public final class DefaultAppearance: NSObject {
        /// The default value is `.app(.body)`
        public lazy var font: UIFont = .app(.body)
        /// The default value is `Theme.tintColor`.
        public lazy var tintColor: UIColor = Theme.tintColor.uiColor
        /// The default value is `Theme.textColor`.
        public lazy var navigationBarTitleColor: UIColor = Theme.textColor.uiColor
        fileprivate override init() {}
    }
}

extension UIViewController {
    public dynamic static let defaultAppearance = DefaultAppearance()

    private var defaultAppearance: DefaultAppearance {
        Self.defaultAppearance
    }

    public static var defaultNavigationBarTextAttributes: [NSAttributedString.Key: Any] {
        [
            .font: defaultAppearance.font,
            .foregroundColor: defaultAppearance.navigationBarTitleColor
        ]
    }

    public static var defaultBarButtonItemTextAttributes: [NSAttributedString.Key: Any] {
        [
            .font: defaultAppearance.font,
            .foregroundColor: defaultAppearance.tintColor
        ]
    }
}
