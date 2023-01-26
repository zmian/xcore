//
// Xcore
// Copyright © 2022 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI
import WebKit

public struct WebView: View {
    @State private var configuration: Configuration

    public init(configuration: Configuration) {
        self._configuration = .init(initialValue: configuration)
    }

    public var body: some View {
        Representable(configuration: configuration)
    }
}

// MARK: - Representable

extension WebView {
    private struct Representable: UIViewRepresentable {
        fileprivate let configuration: Configuration

        init(configuration: Configuration) {
            self.configuration = configuration
        }

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
                $0.customUserAgent = configuration.userAgent
            }
        }

        func updateUIView(_ webView: WKWebView, context: Context) {
            updateConfiguration(webView.configuration, context: context)

            let request = URLRequest(
                url: configuration.url,
                cachePolicy: configuration.cachePolicy,
                timeoutInterval: configuration.timeoutInterval
            )
            webView.load(request)
        }

        private func updateConfiguration(_ wkConfig: WKWebViewConfiguration, context: Context) {
            // Before re-injecting any script message handler, we need to ensure to remove
            // any existing ones to prevent crashes.
            wkConfig.userContentController.removeAllScriptMessageHandlers()

            // 1. Set up message handlers
            configuration.messageHandlers.forEach { messageHandler in
                wkConfig.userContentController.addScriptMessageHandler(
                    context.coordinator,
                    contentWorld: .page,
                    name: messageHandler.name
                )
            }

            // 2. Set up cookies
            configuration.cookies.forEach {
                wkConfig.websiteDataStore.httpCookieStore.setCookie($0)
            }

            // 3. Set up user scripts
            configuration.localStorageItems.forEach { key, value in
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
        let parent: Representable

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
            parent.configuration.localStorageItems.forEach { key, expectedValue in
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

        func userContentController(
            _ userContentController: WKUserContentController,
            didReceive message: WKScriptMessage,
            replyHandler: @escaping (Any?, String?) -> Void
        ) {
            guard let messageHandler = parent.configuration.messageHandlers.first(where: { $0.name == message.name }) else {
                return replyHandler(nil, nil)
            }

            messageHandler.send(.init(
                body: message.body,
                reply: .init(handler: replyHandler)
            ))
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
