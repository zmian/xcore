//
// Xcore
// Copyright © 2022 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI
import WebKit

/// A view that displays interactive web content, such as for an in-app browser.
public struct WebView: View {
    private let urlRequest: URLRequest
    private var messageHandler: [String: ((Any) async throws -> Any?)?] = [:]
    private var localStorageItems: [String: String] = [:]
    private var cookies: [HTTPCookie] = []
    private var policyDecision: ((WKWebView, WKNavigationAction) -> WKNavigationActionPolicy) = { _, _ in .allow }

    public init(url: URL) {
        urlRequest = .init(url: url)
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
            policyDecision: policyDecision
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

    public func policyDecision(_ decision:  @escaping ((WKWebView, WKNavigationAction) -> WKNavigationActionPolicy)) -> Self {
        apply {
            $0.policyDecision = decision
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
        fileprivate var policyDecision: ((WKWebView, WKNavigationAction) -> WKNavigationActionPolicy)

        func makeCoordinator() -> Coordinator {
            Coordinator(parent: self)
        }

        func makeUIView(context: Context) -> WKWebView {
            let webkitConfiguration = WKWebViewConfiguration().apply { wkConfig in
                updateConfiguration(wkConfig, context: context)
            }

            return WKWebView(frame: .zero, configuration: webkitConfiguration).apply {
                $0.navigationDelegate = context.coordinator
                $0.uiDelegate = context.coordinator
                $0.allowsBackForwardNavigationGestures = true
                $0.allowsLinkPreview = false
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
        private var didAddLoader = false
        private let loader = UIActivityIndicatorView(style: .medium)
        private let parent: Representable

        init(parent: Representable) {
            self.parent = parent
        }

        func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
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
            webView.load(navigationAction.request)
            return nil
        }

        private func showLoader(_ show: Bool, _ view: WKWebView) {
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
