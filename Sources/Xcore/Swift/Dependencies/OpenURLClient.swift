//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

/// Provides functionality for opening a URL.
///
/// **Usage**
///
/// ```swift
/// class ViewModel {
///     @Dependency(\.openURL) var openURL
///
///     func openMailApp() {
///         openURL(.mailApp)
///     }
///
///     func openSettingsApp() {
///         openURL(.settingsApp)
///     }
///
///     func openSomeUrl() {
///         openURL(URL(string: "https://example.com"))
///     }
/// }
/// ```
public struct OpenURLClient: Sendable {
    private let handler: @Sendable (URLDescriptor) async -> Bool

    /// Creates a client that opens a URL.
    ///
    /// - Parameter open: The closure to run for the given URL.
    public init(handler: @escaping @Sendable (URLDescriptor) async -> Bool) {
        self.handler = handler
    }

    /// Attempts to asynchronously open the resource at the specified URL.
    @discardableResult
    public func callAsFunction(_ url: URLDescriptor) async -> Bool {
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
    public func callAsFunction(_ url: URLDescriptor) {
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
    /// Returns the noop variant of `OpenURLClient`.
    public static var noop: Self {
        .init { _ in false }
    }

    /// Returns the unimplemented variant of `OpenURLClient`.
    public static var unimplemented: Self {
        .init { _ in
            reportIssue(#"Unimplemented: @Dependency(\.openURL)"#)
            return false
        }
    }

    /// Returns the system variant of `OpenURLClient`.
    public static var system: Self {
        .init { @MainActor urlDescriptor in
            let url = urlDescriptor.url
            let environment = EnvironmentValues()
            environment.openURL(url, prefersInApp: true)
            return true
        }
    }
}

// MARK: - Dependency

extension DependencyValues {
    private enum OpenURLClientKey: DependencyKey {
        static let liveValue: OpenURLClient = .system
    }

    /// Provides functionality for opening a URL.
    ///
    /// **Usage**
    ///
    /// ```swift
    /// class ViewModel {
    ///     @Dependency(\.openURL) var openURL
    ///
    ///     func openMailApp() {
    ///         openURL(.mailApp)
    ///     }
    ///
    ///     func openSettingsApp() {
    ///         openURL(.settingsApp)
    ///     }
    ///
    ///     func openSomeUrl() {
    ///         openURL(URL(string: "https://example.com"))
    ///     }
    /// }
    /// ```
    public var openURL: OpenURLClient {
        get { self[OpenURLClientKey.self] }
        set { self[OpenURLClientKey.self] = newValue }
    }
}
