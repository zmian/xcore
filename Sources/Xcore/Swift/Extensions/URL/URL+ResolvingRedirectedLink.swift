//
// Xcore
// Copyright © 2022 Xcore
// MIT license, see LICENSE file for details
//

import Foundation
import WebKit

extension URL {
    /// Resolves a potentially shortened or redirected URL by following HTTP
    /// redirects.
    ///
    /// This method attempts to retrieve the final destination of a given URL,
    /// making it useful for expanding shortened URLs (e.g., `bit.ly`, `t.co`) and
    /// tracking links that wrap another destination.
    ///
    /// If the URL is a local file (`isFileURL == true`), it returns `self`
    /// immediately without attempting resolution.
    ///
    /// The resolution process will automatically cancel if it exceeds the specified
    /// timeout.
    ///
    /// **Usage**
    ///
    /// ```swift
    /// Task {
    ///     let shortUrl = URL(string: "https://git.new/swift")!
    ///     let resolvedUrl = await shortUrl.resolvingRedirectedLink()
    ///     print(resolvedUrl)
    ///     // Prints "https://github.com/swiftlang/swift"
    /// }
    /// ```
    ///
    /// - Parameter timeoutDuration: The maximum duration to wait before cancelling
    ///   the resolution process.
    ///
    /// - Returns: The final resolved URL if redirection occurs; otherwise, returns
    ///   `self` if the original URL is already the final destination, or if the
    ///   resolution process fails or is canceled due to a timeout.
    @MainActor
    public func resolvingRedirectedLink(timeout timeoutDuration: Duration = .seconds(15)) async -> URL? {
        guard !isFileURL else {
            return self
        }

        return await withCheckedContinuation { continuation in
            let resolver = URLRedirectResolver(url: self) { resolvedUrl in
                continuation.resume(returning: resolvedUrl)
            }

            resolver.start()

            // Cancel if resolution takes too long
            Task {
                try? await Task.sleep(for: timeoutDuration)
                resolver.cancel()
            }
        }
    }
}

/// Resolves a URL by following redirects in a hidden `WKWebView` instance.
///
/// This class loads the given URL in a `WKWebView` and monitors navigation
/// events to determine the final destination URL after redirection.
///
/// **How It Works:**
/// 1. Loads the URL inside a hidden `WKWebView`.
/// 2. Detects the final redirected URL when navigation completes.
/// 3. Cleans up after resolving to free up memory and resources.
///
/// - Note: This is useful when resolving URLs that require JavaScript execution
///   (e.g., some tracking URLs that depend on client-side redirection).
private final class URLRedirectResolver: UIView, WKNavigationDelegate {
    private var isCancelled = false
    private let url: URL
    private let webView = WKWebView()
    private let completion: (URL?) -> Void

    /// Initializes the resolver with a URL and a completion handler.
    ///
    /// - Parameters:
    ///   - url: The URL to resolve.
    ///   - completion: A closure that receives the resolved URL once the
    ///     redirection process completes.
    init(url: URL, completion: @escaping (URL?) -> Void) {
        self.url = url
        self.completion = completion
        super.init(frame: .zero)
        webView.navigationDelegate = self
        addSubview(webView)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }

    /// Starts the URL resolution process.
    ///
    /// - The web view is temporarily added to the app’s window hierarchy to
    ///   ensure JavaScript redirects function correctly.
    /// - The page is loaded asynchronously, and navigation events are monitored.
    func start() {
        UIApplication.sharedOrNil?.sceneWindows.first?.addSubview(self)
        webView.load(URLRequest(url: url))
    }

    /// Cancels the resolution process.
    func cancel() {
        isCancelled = true
        completeResolution(with: nil)
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        guard !isCancelled else { return }
        completeResolution(with: webView.url)
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        guard !isCancelled else { return }
        reportIssue(error, "didFailNavigation")
        completeResolution(with: webView.url)
    }

    /// Completes the resolution process, returning the resolved URL and cleaning up
    /// resources.
    ///
    /// - Parameter resolvedUrl: The final URL after resolution, or `nil` if the
    ///   process failed.
    private func completeResolution(with resolvedUrl: URL?) {
        // Invoke completion handler with resolved url
        completion(resolvedUrl)

        // Cleanup to prevent memory leaks.
        webView.navigationDelegate = nil
        webView.stopLoading()
        removeFromSuperview()
    }
}
