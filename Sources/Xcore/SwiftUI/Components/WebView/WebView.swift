//
// Xcore
// Copyright © 2022 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI
import WebKit

// MARK: Public Interface

public struct WebView: UIViewRepresentable {
    private var urlRequest: URLRequest
    private var messageHandler: [String: ((Any) async throws -> Any?)?] = [:]
    private var localStorageItems: [String: String] = [:]
    private var cookies: [HTTPCookie] = []

    public init(url: URL) {
        urlRequest = .init(url: url)
    }

    public init(urlRequest: URLRequest) {
        self.urlRequest = urlRequest
    }
}

// MARK: Extensions

extension WebView {
    public func onMessageHandler(name: String, handler: ((_ body: Any) async throws -> Any?)?) -> WebView {
        var copy = self
        copy.messageHandler[name] = handler
        return copy
    }

    public func cookies(_ cookies: [HTTPCookie]) -> WebView {
        var copy = self
        copy.cookies = cookies
        return copy
    }

    public func localStorageItem(_ item: String, forKey key: String) -> WebView {
        var copy = self
        copy.localStorageItems[key] = item
        return copy
    }
}

// MARK: - Implementation

extension WebView {
    public func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    public func makeUIView(context: Context) -> WKWebView {
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

    public func updateUIView(_ webView: WKWebView, context: Context) {
        updateConfiguration(webView.configuration, context: context)
        webView.load(urlRequest)
    }

    private func updateConfiguration(_ wkConfig: WKWebViewConfiguration, context: Context) {
        // Before re-injecting any script message handler, we need to ensure to remove
        // any existing ones to prevent crashes.
        wkConfig.userContentController.removeAllScriptMessageHandlers()

        // 1. Set up message handlers
        messageHandler.forEach { key, value in
            wkConfig.userContentController.addScriptMessageHandler(
                context.coordinator,
                contentWorld: .page,
                name: key
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

// MARK: - Coordinator

extension WebView {
    public final class Coordinator: NSObject, WKNavigationDelegate, WKUIDelegate, WKScriptMessageHandlerWithReply {
        private var didAddLoader = false
        private let loader = UIActivityIndicatorView(style: .medium)
        let parent: WebView

        init(parent: WebView) {
            self.parent = parent
        }

        public func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
            showLoader(false, webView)
        }

        public func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
            showLoader(true, webView)
        }

        public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
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

        public func webView(_ webView: WKWebView, didFail navigation: WKNavigation, withError error: Error) {
            showLoader(false, webView)
        }

        public func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation) {
            showLoader(true, webView)
        }

        public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            // TODO: Can add restrtiction based on urls from configuration
            decisionHandler(.allow)
        }

        func showLoader(_ show: Bool, _ view: WKWebView) {
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

        @MainActor public func userContentController(
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
        public func webView(_ webView: WKWebView, respondTo challenge: URLAuthenticationChallenge) async -> (URLSession.AuthChallengeDisposition, URLCredential?) {
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
