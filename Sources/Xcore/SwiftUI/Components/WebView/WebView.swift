//
// Xcore
// Copyright © 2022 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI
import WebKit
import OSLog

/// A view that displays interactive web content, such as for an in-app browser.
///
/// This view wraps a WKWebView and provides configuration for message handlers,
/// cookies, local storage, and policy decisions. It also supports a pull-to-refresh
/// mechanism and a loader.
public struct WebView: View {
    /// A closure to handle JavaScript messages from the web content.
    public typealias MessageHandler = @MainActor (_ body: Any) async throws -> (any Sendable)?
    /// A closure to decide the navigation policy for a given action.
    public typealias PolicyDecision = @MainActor (
        _ webView: WKWebView,
        _ decidePolicyForNavigationAction: WKNavigationAction
    ) async -> WKNavigationActionPolicy

    /// The URLRequest used to load the web content.
    private let urlRequest: URLRequest
    /// A dictionary mapping message names to their handlers.
    private var messageHandlers: [String: MessageHandler] = [:]
    /// Local storage items to inject into the web view.
    private var localStorageItems: [String: String] = [:]
    /// Cookies to set in the web view's HTTP cookie store.
    private var cookies: [HTTPCookie] = []
    /// A Boolean property indicating whether a loader is shown.
    private var showLoader = false
    /// A Boolean property indicating whether the refresh control is enabled.
    private var showRefreshControl = true
    /// Additional configuration for the WKWebView.
    private var additionalConfiguration: (WKWebView) -> Void = { _ in }
    /// The pull-to-refresh action handler.
    private var pullToRefreshHandler: () -> Void = {}
    /// A closure that allows creating a new WKWebView for opening new windows.
    private var createWebViewHandler: (URLRequest) -> WKWebView? = { _ in nil }
    /// A closure that defines the navigation policy decision.
    private var policyDecision: PolicyDecision = { _, action in
        guard let scheme = action.request.url?.schemeType else {
            return .allow
        }

        // Handle email, SMS, and telephone URLs natively.
        switch scheme {
            case .email, .sms, .tel:
                @Dependency(\.openUrl) var openUrl
                await openUrl(action.request.url)
                return .cancel
            default:
                return .allow
        }
    }

    /// Creates a WebView that loads the given URL.
    public init(url: URL) {
        self.init(urlRequest: .init(url: url))
    }

    /// Creates a WebView that loads the given URLRequest.
    public init(urlRequest: URLRequest) {
        self.urlRequest = urlRequest
    }

    /// The view's body. It returns a Representable that wraps a WKWebView.
    public var body: some View {
        Representable(
            urlRequest: urlRequest,
            messageHandlers: messageHandlers,
            localStorageItems: localStorageItems,
            cookies: cookies,
            policyDecision: policyDecision,
            showLoader: showLoader,
            showRefreshControl: showRefreshControl,
            additionalConfiguration: additionalConfiguration,
            pullToRefreshHandler: pullToRefreshHandler,
            createWebViewHandler: createWebViewHandler
        )
    }
}

// MARK: - Public API

extension WebView {
    /// Adds a message handler for a given name.
    ///
    /// **Usage**
    ///
    /// ```swift
    /// WebView(url: myURL)
    ///     .onMessageHandler(name: "xcore") { body in
    ///         if let body = body as? String {
    ///             switch body {
    ///                 case "accessTokenExpired":
    ///                     // Handle message asynchronously
    ///                     return try await tokenRenewal.refresh()
    ///                 default:
    ///                     return nil
    ///             }
    ///         }
    ///     }
    /// ```
    public func onMessageHandler(name: String, handler: MessageHandler?) -> Self {
        apply {
            $0.messageHandlers[name] = handler
        }
    }

    /// Sets cookies for the WebView.
    public func cookies(_ cookies: [HTTPCookie]) -> Self {
        apply {
            $0.cookies = cookies
        }
    }

    /// Sets a local storage item for the WebView.
    public func localStorageItem(_ item: String, forKey key: String) -> Self {
        apply {
            $0.localStorageItems[key] = item
        }
    }

    /// Sets a custom policy decision handler.
    public func policyDecision(_ decision: @escaping PolicyDecision) -> Self {
        apply {
            $0.policyDecision = decision
        }
    }

    /// Controls whether a loader is shown.
    public func showLoader(_ value: Bool) -> Self {
        apply {
            $0.showLoader = value
        }
    }

    /// Controls whether the refresh control is visible.
    public func hideRefreshControl(_ value: Bool) -> Self {
        apply {
            $0.showRefreshControl = !value
        }
    }

    /// Adds additional configuration to the WKWebView.
    public func additionalConfiguration(_ configuration: @escaping (WKWebView) -> Void) -> Self {
        apply {
            $0.additionalConfiguration = configuration
        }
    }

    /// Sets the pull-to-refresh action handler.
    ///
    /// **Usage**
    ///
    /// ```swift
    /// WebView(url: myURL)
    ///     .onPullToRefresh {
    ///         // Handle refresh
    ///     }
    /// ```
    public func onPullToRefresh(_ handler: @escaping () -> Void) -> Self {
        apply {
            $0.pullToRefreshHandler = handler
        }
    }

    /// Sets the handler for creating a new WebView window.
    public func onNewWebViewWindow(_ handler: @escaping (URLRequest) -> WKWebView?) -> Self {
        apply {
            $0.createWebViewHandler = handler
        }
    }

    /// A helper method that applies a configuration closure to a copy of self.
    private func apply(_ configure: (inout Self) throws -> Void) rethrows -> Self {
        var copy = self
        try configure(&copy)
        return copy
    }
}

// MARK: - Representable

extension WebView {
    private struct Representable: UIViewRepresentable {
        fileprivate let urlRequest: URLRequest
        fileprivate var messageHandlers: [String: MessageHandler]
        fileprivate var localStorageItems: [String: String]
        fileprivate var cookies: [HTTPCookie]
        fileprivate var policyDecision: PolicyDecision
        fileprivate var showLoader: Bool
        fileprivate var showRefreshControl: Bool
        fileprivate let additionalConfiguration: (WKWebView) -> Void
        fileprivate let pullToRefreshHandler: () -> Void
        fileprivate let createWebViewHandler: (URLRequest) -> WKWebView?

        func makeCoordinator() -> Coordinator {
            Coordinator(parent: self)
        }

        func makeUIView(context: Context) -> WKWebView {
            let webkitConfiguration = WKWebViewConfiguration().apply { wkConfig in
                updateConfiguration(wkConfig, context: context)
            }

            return WKWebView(frame: .zero, configuration: webkitConfiguration).apply { webView in
                webView.navigationDelegate = context.coordinator
                webView.uiDelegate = context.coordinator
                webView.allowsBackForwardNavigationGestures = true
                webView.allowsLinkPreview = false
                webView.isInspectable = true
                if showRefreshControl {
                    webView.scrollView.refreshControl = UIRefreshControl().apply {
                        $0.addAction(.valueChanged) { sender in
                            Task {
                                // Sleep under a second to properly show the control.
                                try await Task.sleep(for: .seconds(0.75))
                                sender.endRefreshing()
                                webView.reload()
                                pullToRefreshHandler()
                            }
                        }
                    }
                }
                additionalConfiguration(webView)
            }
        }

        func updateUIView(_ webView: WKWebView, context: Context) {
            updateConfiguration(webView.configuration, context: context)
            webView.load(urlRequest)
        }

        private func updateConfiguration(_ wkConfig: WKWebViewConfiguration, context: Context) {
            // Before re-injecting any script message handler, we need to ensure to remove
            // any existing ones to prevent crashes.
            wkConfig.userContentController.removeAllScriptMessageHandlers()

            // 1. Set up message handlers
            messageHandlers.forEach { name, _ in
                wkConfig.userContentController.addScriptMessageHandler(
                    context.coordinator,
                    contentWorld: .page,
                    name: name
                )
            }

            // 2. Set up cookies
            cookies.forEach {
                wkConfig.websiteDataStore.httpCookieStore.setCookie($0)
            }

            // 3. Set up user scripts
            localStorageItems.forEach { key, value in
                let script = WKUserScript(
                    source: "window.localStorage.setItem(\"\(key)\", \"\(value)\");",
                    injectionTime: .atDocumentStart,
                    forMainFrameOnly: true
                )
                wkConfig.userContentController.addUserScript(script)
            }
        }
    }
}

// MARK: - Coordinator

extension WebView {
    private final class Coordinator: NSObject, WKNavigationDelegate, WKUIDelegate, WKScriptMessageHandlerWithReply {
        @Dependency(\.openUrl) var openUrl
        private var didAddLoader = false
        private let loader = UIActivityIndicatorView(style: .medium)
        private let parent: Representable

        init(parent: Representable) {
            self.parent = parent
        }

        func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
            webView.reload()
            showLoader(false, webView)
        }

        func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
            showLoader(true, webView)
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            #if DEBUG
            // Dump local storage keys and values when the current value is different than
            // the expected value.
            parent.localStorageItems.forEach { key, expectedValue in
                webView.evaluateJavaScript("localStorage.getItem(\"\(key)\")") { (value, error) in
                    if let value = value as? String {
                        if expectedValue != value {
                            Logger.xc.debug("\"\(key, privacy: .public)\" value in local storage: \(value, privacy: .public)")
                        }
                    }

                    if let error {
                        Logger.xc.error("Failed to get the value for the \"\(key, privacy: .public)\": \(error, privacy: .public)")
                    }
                }
            }
            #endif

            showLoader(false, webView)
        }

        func webView(_ webView: WKWebView, didFail navigation: WKNavigation, withError error: Error) {
            showLoader(false, webView)
        }

        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation) {
            showLoader(true, webView)
        }

        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction) async -> WKNavigationActionPolicy {
            await parent.policyDecision(webView, navigationAction)
        }

        func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
            guard let webView = parent.createWebViewHandler(navigationAction.request) else {
                openUrl(navigationAction.request.url)
                return nil
            }

            return webView
        }

        private func showLoader(_ show: Bool, _ view: WKWebView) {
            guard parent.showLoader else {
                return
            }

            if !didAddLoader {
                view.addSubview(loader)
                loader.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    loader.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                    loader.centerYAnchor.constraint(equalTo: view.centerYAnchor)
                ])
            }

            show ? loader.startAnimating() : loader.stopAnimating()
            loader.isHidden = !show
        }

        func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) async -> (Any?, String?) {
            guard let messageHandler = parent.messageHandlers[message.name] else {
                return (nil, nil)
            }

            return (try? await messageHandler(message.body), nil)
        }

        // MARK: - Dev environment support

        #if DEBUG
        func webView(_ webView: WKWebView, respondTo challenge: URLAuthenticationChallenge) async -> (URLSession.AuthChallengeDisposition, URLCredential?) {
            // Enable accepting untrusted urls in debug mode only.
            guard let trust = challenge.protectionSpace.serverTrust else {
                return (.performDefaultHandling, nil)
            }

            let exceptions = SecTrustCopyExceptions(trust)
            SecTrustSetExceptions(trust, exceptions)
            return (.useCredential, URLCredential(trust: trust))
        }
        #endif
    }
}
