//
// Xcore
// Copyright © 2022 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI
import WebKit

/// A view that displays interactive web content, such as for an in-app browser.
public struct WebView: View {
    public typealias PolicyDecision = (
        _ webView: WKWebView,
        _ decidePolicyForNavigationAction: WKNavigationAction
    ) -> WKNavigationActionPolicy

    private let urlRequest: URLRequest
    private var messageHandler: [String: ((Any) async throws -> Any?)?] = [:]
    private var localStorageItems: [String: String] = [:]
    private var cookies: [HTTPCookie] = []
    private var policyDecision: PolicyDecision = { _, _ in .allow }
    private var showLoader = false
    private var showRefreshControl = true
    private var additionalConfiguration: (WKWebView) -> Void = { _ in }
    private var pullToRefreshHandler: () -> Void = {}
    private var createWebViewHandler: (URLRequest) -> WKWebView? = { _ in nil }

    public init(url: URL) {
        self.init(urlRequest: .init(url: url))
    }

    public init(urlRequest: URLRequest) {
        self.urlRequest = urlRequest
    }

    public var body: some View {
        Representable(
            urlRequest: urlRequest,
            messageHandler: messageHandler,
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
    public func onMessageHandler(name: String, handler: ((_ body: Any) async throws -> Any?)?) -> Self {
        apply {
            $0.messageHandler[name] = handler
        }
    }

    public func cookies(_ cookies: [HTTPCookie]) -> Self {
        apply {
            $0.cookies = cookies
        }
    }

    public func localStorageItem(_ item: String, forKey key: String) -> Self {
        apply {
            $0.localStorageItems[key] = item
        }
    }

    public func policyDecision(_ decision: @escaping PolicyDecision) -> Self {
        apply {
            $0.policyDecision = decision
        }
    }

    public func showLoader(_ value: Bool) -> Self {
        apply {
            $0.showLoader = value
        }
    }

    public func hideRefreshControl(_ value: Bool) -> Self {
        apply {
            $0.showRefreshControl = !value
        }
    }

    public func additionalConfiguration(_ configuration: @escaping (WKWebView) -> Void) -> Self {
        apply {
            $0.additionalConfiguration = configuration
        }
    }

    public func onPullToRefresh(_ handler: @escaping () -> Void) -> Self {
        apply {
            $0.pullToRefreshHandler = handler
        }
    }

    public func onNewWebViewWindow(_ handler: @escaping (URLRequest) -> WKWebView?) -> Self {
        apply {
            $0.createWebViewHandler = handler
        }
    }

    private func apply(_ configure: (inout Self) throws -> Void) rethrows -> Self {
        var object = self
        try configure(&object)
        return object
    }
}

// MARK: - Representable

extension WebView {
    private struct Representable: UIViewRepresentable {
        fileprivate let urlRequest: URLRequest
        fileprivate var messageHandler: [String: ((Any) async throws -> Any?)?]
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
                if #available(iOS 16.4, *) {
                    webView.isInspectable = true
                }
                if showRefreshControl {
                    webView.scrollView.refreshControl = UIRefreshControl().apply {
                        $0.addAction(.valueChanged) { sender in
                            Task {
                                // Sleep under a second to properly show the control.
                                try await Task.sleep(seconds: 0.75)
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
            messageHandler.forEach { name, _ in
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
                            print("\"\(key)\" value in local storage:", value)
                        }
                    }

                    if let error {
                        print("Failed to get the value for the \"\(key)\":", error)
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

        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            decisionHandler(parent.policyDecision(webView, navigationAction))
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

        @MainActor
        func userContentController(
            _ userContentController: WKUserContentController,
            didReceive message: WKScriptMessage,
            replyHandler: @escaping (Any?, String?) -> Void
        ) {
            guard let messageHandler = parent.messageHandler[message.name] else {
                return replyHandler(nil, nil)
            }

            Task {
                replyHandler(try? await messageHandler?(message.body), nil)
            }
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
