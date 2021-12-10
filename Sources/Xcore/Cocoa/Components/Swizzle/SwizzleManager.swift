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
    ///
    /// Start the `SwizzleManager` when your app launches:
    ///
    ///
    /// ```swift
    /// func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    ///     SwizzleManager.start([
    ///         UIViewController.runOnceSwapSelectors
    ///     ])
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

        public static let userContentController = Self(rawValue: 1 << 0)
        public static let all: Self = [
            userContentController
        ]
    }
}
