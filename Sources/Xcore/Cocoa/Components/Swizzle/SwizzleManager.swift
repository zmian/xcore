//
// Xcore
// Copyright © 2017 Xcore
// MIT license, see LICENSE file for details
//

import UIKit
import WebKit

public final class SwizzleManager {
    private static var didSwizzle = false
    static var options: SwizzleOptions = .all

    private init() {}

    /// An entry point to enabled extra functionality for some properties that Xcore
    /// swizzles. It also provides a hook swizzle additional selectors.
    ///
    /// **Usage**
    /// Place any one of the snippet in your app:
    ///
    /// **Usage 1**
    ///
    /// ```swift
    /// extension UIApplication {
    ///     open override var next: UIResponder? {
    ///         // Called before applicationDidFinishLaunching
    ///         SwizzleManager.start()
    ///         return super.next
    ///     }
    /// }
    /// ```
    ///
    /// **Usage 2**
    /// With an option to provide additional selectors.
    ///
    /// ```swift
    /// extension UIApplication {
    ///     open override var next: UIResponder? {
    ///         // Called before applicationDidFinishLaunching
    ///         SwizzleManager.start([
    ///             UIViewController.runOnceSwapSelectors
    ///         ])
    ///         return super.next
    ///     }
    /// }
    /// ```
    ///
    /// **Usage 3**
    /// Or in the `AppDelegate` class
    ///
    /// ```swift
    /// func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    ///     SwizzleManager.start()
    ///     return true
    /// }
    /// ```
    ///
    /// - Parameters:
    ///   - options: A list of options to customize which Xcore classes to swizzle.
    ///   - additionalSelectors: additional selectors to swizzle.
    public static func start(
        options: SwizzleOptions = .all,
        _ additionalSelectors: @autoclosure () -> [() -> Void] = []
    ) {
        guard !didSwizzle else { return }
        defer { didSwizzle = true }

        self.options = options
        xcoreSwizzle(options: options)
        additionalSelectors().forEach {
            $0()
        }
    }

    private static func xcoreSwizzle(options: SwizzleOptions) {
        if options.contains(.view) {
            UIView._runOnceSwapSelectors()
        }

        if options.contains(.button) {
            UIButton.runOnceSwapSelectors()
        }

        if options.contains(.label) {
            UILabel.runOnceSwapSelectors()
        }

        if options.contains(.textField) {
            UITextField.runOnceSwapSelectors()
        }

        if options.contains(.imageView) {
            UIImageView.runOnceSwapSelectors()
        }

        if options.contains(.searchBar) {
            UISearchBar.runOnceSwapSelectors()
        }

        if options.contains(.tableViewCell) {
            UITableViewCell.runOnceSwapSelectors()
        }

        if options.contains(.collectionViewCell) {
            UICollectionViewCell.runOnceSwapSelectors()
        }

        if options.contains(.viewController) {
            UIViewController.runOnceSwapSelectors()
        }

        if options.contains(.userContentController) {
            WKUserContentController.runOnceSwapSelectors()
        }
    }
}

extension SwizzleManager {
    /// A list of features available to swizzle.
    public struct SwizzleOptions: OptionSet {
        public let rawValue: Int

        public init(rawValue: Int) {
            self.rawValue = rawValue
        }

        public static let view = Self(rawValue: 1 << 0)
        public static let button = Self(rawValue: 1 << 1)
        public static let label = Self(rawValue: 1 << 2)
        public static let textField = Self(rawValue: 1 << 3)
        public static let textView = Self(rawValue: 1 << 4)
        public static let imageView = Self(rawValue: 1 << 5)
        public static let searchBar = Self(rawValue: 1 << 6)
        public static let tableViewCell = Self(rawValue: 1 << 7)
        public static let collectionViewCell = Self(rawValue: 1 << 8)
        public static let viewController = Self(rawValue: 1 << 9)
        public static let userContentController = Self(rawValue: 1 << 10)
        public static let chrome = Self(rawValue: 1 << 11)
        public static let all: Self = [
            view,
            button,
            label,
            textField,
            textView,
            imageView,
            searchBar,
            tableViewCell,
            collectionViewCell,
            viewController,
            userContentController,
            chrome
        ]
    }
}
