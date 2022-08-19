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
public struct OpenURLClient {
    private let open: (AdaptiveURL) -> Void

    /// Creates a client that opens a URL.
    ///
    /// - Parameter open: The closure to run for the given URL.
    public init(open: @escaping (AdaptiveURL) -> Void) {
        self.open = open
    }

    /// Attempts to asynchronously open the resource at the specified URL.
    public func callAsFunction(_ url: AdaptiveURL) {
        open(url)
    }

    /// Attempts to asynchronously open the resource at the specified URL.
    public func callAsFunction(_ url: URL?) {
        guard let url = url else {
            return
        }

        open(.init(title: "", url: url))
    }
}

// MARK: - Variants

extension OpenURLClient {
    /// Returns noop variant of `OpenURLClient`.
    public static var noop: Self {
        .init { _ in }
    }

    #if DEBUG
    /// Returns unimplemented variant of `OpenURLClient`.
    public static var unimplemented: Self {
        .init { _ in
            internal_XCTFail("\(Self.self) is unimplemented")
        }
    }
    #endif

    /// Returns system variant of `OpenURLClient`.
    public static var system: Self {
        .init { adaptiveUrl in
            guard let app = UIApplication.sharedOrNil else {
                return
            }

            let url = adaptiveUrl.url

            // Attempt to open standard urls using in-app Safari.
            if [.http, .https].contains(url.schemeType) {
                let vc = InAppSafariViewController(url: url).apply {
                    $0.preferredControlTintColor = Theme.tintColor.uiColor
                }

                // Present shows the Safari VC correctly in SwiftUI.
                return vc.show()
            } else if app.canOpenURL(url) {
                app.appExtensionSafeOpen(url)
            } else {
                #if DEBUG
                Console.warn("Unable to open the url: \(url)")
                #endif
            }
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
        self[\.openUrl] = value
        return Self.self
    }
}
