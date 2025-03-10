//
// Xcore
// Copyright © 2017 Xcore
// MIT license, see LICENSE file for details
//

#if canImport(WebKit)
import WebKit
#endif

@MainActor
public enum SwizzleManager {
    private static var didSwizzle = false
    static var options: SwizzleOptions = .all

    /// An entry point to enabled extra functionality for some properties that Xcore
    /// swizzles. It also provides a hook to add additional swizzle selectors.
    ///
    /// Start the `SwizzleManager` when your app launches:
    ///
    ///
    /// ```swift
    /// @main
    /// struct ExampleApp: App {
    ///     init() {
    ///         SwizzleManager.start([
    ///             UIViewController.runOnceSwapSelectors
    ///         ])
    ///     }
    ///
    ///     var body: some Scene {
    ///         // ...
    ///     }
    /// }
    /// ```
    ///
    /// - Parameters:
    ///   - options: A list of options to customize which Xcore classes to swizzle.
    ///   - additionalSelectors: A list of additional selectors to swizzle.
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
        #if canImport(WebKit)
        if options.contains(.userContentController) {
            WKUserContentController.runOnceSwapSelectors()
        }
        #endif
    }
}

extension SwizzleManager {
    /// A list of features available to swizzle.
    public struct SwizzleOptions: OptionSet, Sendable, Hashable {
        public let rawValue: Int

        public init(rawValue: Int) {
            self.rawValue = rawValue
        }

        #if canImport(WebKit)
        public static let userContentController = Self(rawValue: 1 << 0)
        #endif

        public static let all: Self = [
            userContentController
        ]
    }
}
