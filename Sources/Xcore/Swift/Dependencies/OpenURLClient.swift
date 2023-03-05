//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI
@_implementationOnly import SafariServices

/// Provides functionality for opening a URL.
///
/// **Usage**
///
/// ```swift
/// class ViewModel {
///     @Dependency(\.openUrl) var openUrl
///
///     func openMailApp() {
///         openUrl(.mailApp)
///     }
///
///     func openSettingsApp() {
///         openUrl(.settingsApp)
///     }
///
///     func openSomeUrl() {
///         openUrl(URL(string: "https://example.com"))
///     }
/// }
/// ```
public struct OpenURLClient {
    private let handler: @Sendable (AdaptiveURL) async -> Bool

    /// Creates a client that opens a URL.
    ///
    /// - Parameter open: The closure to run for the given URL.
    public init(handler: @escaping @Sendable (AdaptiveURL) async -> Bool) {
        self.handler = handler
    }

    /// Attempts to asynchronously open the resource at the specified URL.
    @discardableResult
    public func callAsFunction(_ url: AdaptiveURL) async -> Bool {
        await handler(url)
    }

    /// Attempts to asynchronously open the resource at the specified URL.
    @discardableResult
    public func callAsFunction(_ url: URL?) async -> Bool {
        guard let url else {
            return false
        }

        return await handler(.init(title: "", url: url))
    }

    /// Attempts to asynchronously open the resource at the specified URL.
    public func callAsFunction(_ url: AdaptiveURL) {
        Task {
            await callAsFunction(url)
        }
    }

    /// Attempts to asynchronously open the resource at the specified URL.
    public func callAsFunction(_ url: URL?) {
        Task {
            await callAsFunction(url)
        }
    }
}

// MARK: - Variants

extension OpenURLClient {
    /// Returns noop variant of `OpenURLClient`.
    public static var noop: Self {
        .init { _ in false }
    }

    /// Returns unimplemented variant of `OpenURLClient`.
    public static var unimplemented: Self {
        .init { _ in
            XCTFail("\(Self.self) is unimplemented")
            return false
        }
    }

    /// Returns system variant of `OpenURLClient`.
    public static var system: Self {
        .init { @MainActor adaptiveUrl in
            let url = adaptiveUrl.url
            let environment = EnvironmentValues()

            // Attempt to open standard urls using in-app Safari.
            guard
                [.http, .https].contains(url.schemeType),
                UIApplication.sharedOrNil != nil
            else {
                return await environment.openURL.run(url)
            }

            let vc = InAppSafariViewController(url: url).apply {
                $0.preferredControlTintColor = environment.theme.tintColor.uiColor
            }

            // Present shows the Safari VC correctly in SwiftUI.
            vc.show()
            return true
        }
    }

    private final class InAppSafariViewController: SFSafariViewController {
        private var hud = HUD().apply {
            $0.backgroundColor = .clear
            $0.windowLabel = "OpenURL Window"

            $0.adjustWindowAttributes {
                $0.makeKey()
            }
        }

        override func viewDidDisappear(_ animated: Bool) {
            super.viewDidDisappear(animated)
            hud.hide(animated: false)
        }

        func show() {
            hud.present(self, animated: true)
        }
    }
}

// MARK: - Dependency

extension DependencyValues {
    private struct OpenURLClientKey: DependencyKey {
        static var liveValue: OpenURLClient = .system
    }

    /// Provides functionality for opening a URL.
    public var openUrl: OpenURLClient {
        get { self[OpenURLClientKey.self] }
        set { self[OpenURLClientKey.self] = newValue }
    }

    /// Provides functionality for opening a URL.
    @discardableResult
    public static func openUrl(_ value: OpenURLClient) -> Self.Type {
        OpenURLClientKey.liveValue = value
        return Self.self
    }
}

// MARK: - Helpers

extension OpenURLAction {
    @available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
    fileprivate func run(_ url: URL) async -> Bool {
        #if os(watchOS)
        callAsFunction(url)
        return true
        #else
        return await withCheckedContinuation { continuation in
            callAsFunction(url) { canOpen in
                continuation.resume(returning: canOpen)
            }
        }
        #endif
    }
}
