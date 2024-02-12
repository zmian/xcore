//
// Xcore
// Copyright © 2022 Xcore
// MIT license, see LICENSE file for details
//

import Foundation
import WebKit

/// A method to resolve the given url to handle any redirects.
///
/// It can resolve any wrapped link and once resolved it returns the resolved
/// url.
public func headlessResolve(url: URL) async -> URL? {
    await withCheckedContinuation { continuation in
        Task { @MainActor in
            HeadlessResolveURL(url: url) { url in
                continuation.resume(returning: url)
            }
            .start()
        }
    }
}

/// A class to resolve the given url to handle any redirects.
///
/// It can resolve any wrapped link and once resolved it invokes the completion
/// block.
private final class HeadlessResolveURL: UIView, WKNavigationDelegate {
    private let url: URL
    private let webView = WKWebView()
    private let completion: (URL?) -> Void

    init(url: URL, completion: @escaping (URL?) -> Void) {
        self.url = url
        self.completion = completion
        super.init(frame: .zero)
        webView.navigationDelegate = self
        addSubview(webView)
    }

    func start() {
        // We need to add the view to some parent; otherwise, some JS scripts won't work
        // correctly.
        UIApplication.sharedOrNil?.sceneWindows.first?.addSubview(self)
        webView.load(URLRequest(url: url))
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        completion(webView.url)
        removeFromSuperview()
    }

    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        debugLog(webView.url as Any, info: "didReceiveServerRedirectForProvisionalNavigation")
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        debugLog(error, info: "didFailNavigation")
        completion(webView.url)
        removeFromSuperview()
    }
}
