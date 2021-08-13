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
/// struct ViewModel {
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
public struct OpenURLClient: Hashable, Identifiable {
    public let id: String
    private let open: (AdaptiveURL) -> Void

    public init(id: String = #function, open: @escaping (AdaptiveURL) -> Void) {
        self.id = id
        self.open = open
    }

    /// Attempts to asynchronously open the resource at the specified URL.
    public func callAsFunction(_ url: AdaptiveURL) {
        open(url)
    }

    /// Attempts to asynchronously open the resource at the specified URL.
    public func callAsFunction(_ url: URL?) {
        open(.init(title: "", url: url))
    }

    public static func ==(lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

// MARK: - Variants

extension OpenURLClient {
    /// Returns system variant of `OpenURLClient`.
    public static var system: Self {
        .init { adaptiveUrl in
            guard
                let app = UIApplication.sharedOrNil,
                let url = adaptiveUrl.url
            else {
                return
            }

            // Attempt to open standard urls using in-app Safari.
            if [.http, .https].contains(url.schemeType), let nvc = app.topNavigationController {
                let vc = SFSafariViewController(url: url)
                nvc.pushViewController(vc, animated: true)
            } else if app.canOpenURL(url) {
                app.appExtensionSafeOpen(url)
            }
        }
    }

    /// Returns noop variant of `OpenURLClient`.
    public static var noop: Self {
        .init { _ in }
    }

    #if DEBUG
    /// Returns failing variant of `OpenURLClient`.
    public static var failing: Self {
        .init { _ in
            internal_XCTFail("\(Self.self) is unimplemented")
        }
    }
    #endif
}

// MARK: - Dependency

extension DependencyValues {
    private struct OpenURLClientKey: DependencyKey {
        static let defaultValue: OpenURLClient = .system
    }

    /// Provides functionality for opening a URL.
    public var openUrl: OpenURLClient {
        get { self[OpenURLClientKey.self] }
        set { self[OpenURLClientKey.self] = newValue }
    }

    /// Provides functionality for opening a URL.
    @discardableResult
    public static func openUrl(_ value: OpenURLClient) -> Self.Type {
        set(\.openUrl, value)
        return Self.self
    }
}
