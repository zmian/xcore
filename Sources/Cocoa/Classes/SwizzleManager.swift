//
// SwizzleManager.swift
//
// Copyright © 2017 Xcore
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
import WebKit

final public class SwizzleManager {
    private static var didSwizzle = false
    static var options: SwizzleOptions = .all

    private init() {}

    /// An entry point to enabled extra functionality for some properties
    /// that Xcore swizzles. It also provides a hook swizzle additional selectors.
    ///
    /// **Example**
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
    ///   - options: A list of options to customize which Xcore classes to swizzle. The default value is `.all`.
    ///   - additionalSelectors: additional selectors to swizzle.
    public static func start(options: SwizzleOptions = .all, _ additionalSelectors: @autoclosure () -> [() -> Void] = []) {
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
            UILabel.swizzle_runOnceSwapSelectors()
        }

        if options.contains(.textField) {
            UITextField.runOnceSwapSelectors()
        }

        if options.contains(.textView) {
            UITextView.swizzle_runOnceSwapSelectors()
        }

        if options.contains(.imageView) {
            UIImageView.runOnceSwapSelectors()
        }

        if options.contains(.searchBar) {
            UISearchBar.runOnceSwapSelectors()
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

        public static let view = SwizzleOptions(rawValue: 1 << 0)
        public static let button = SwizzleOptions(rawValue: 1 << 1)
        public static let label = SwizzleOptions(rawValue: 1 << 2)
        public static let textField = SwizzleOptions(rawValue: 1 << 3)
        public static let textView = SwizzleOptions(rawValue: 1 << 4)
        public static let imageView = SwizzleOptions(rawValue: 1 << 5)
        public static let searchBar = SwizzleOptions(rawValue: 1 << 6)
        public static let collectionViewCell = SwizzleOptions(rawValue: 1 << 7)
        public static let viewController = SwizzleOptions(rawValue: 1 << 8)
        public static let userContentController = SwizzleOptions(rawValue: 1 << 9)
        public static let chrome = SwizzleOptions(rawValue: 1 << 10)
        public static let all: SwizzleOptions = [
            view,
            button,
            label,
            textField,
            textView,
            imageView,
            searchBar,
            collectionViewCell,
            viewController,
            userContentController,
            chrome
        ]
    }
}
