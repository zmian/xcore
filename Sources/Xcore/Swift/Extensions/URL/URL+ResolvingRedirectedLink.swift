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

        let resolver = URLRedirectResolver(url: self)
        return await resolver.resolve(timeout: timeoutDuration)
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
    private var continuation: CheckedContinuation<URL?, Never>?
    private var timeoutTask: Task<(), any Error>?

    /// Initializes the resolver with a URL and a completion handler.
    ///
    /// - Parameter url: The URL to resolve.
    init(url: URL) {
        self.url = url
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
    ///
    /// - Parameter timeout: The maximum duration before cancellation.
    /// - Returns: The resolved URL or `nil` if resolution fails.
    func resolve(timeout timeoutDuration: Duration) async -> URL? {
        await withCheckedContinuation {
            continuation = $0

            UIApplication.sharedOrNil?.sceneWindows.first?.addSubview(self)
            webView.load(URLRequest(url: url))

            // Cancel if resolution takes too long
            timeoutTask = Task {
                try await Task.sleep(for: timeoutDuration)
                cancel()
            }
        }
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

    /// Cancels the resolution process.
    private func cancel() {
        guard !isCancelled else { return }
        completeResolution(with: nil)
    }

    /// Completes the resolution process, returning the resolved URL and cleaning up
    /// resources.
    ///
    /// - Parameter resolvedUrl: The final URL after resolution, or `nil` if the
    ///   process failed.
    private func completeResolution(with resolvedUrl: URL?) {
        timeoutTask?.cancel()
        // Mark "isCancelled" as true to prevent further events being send to
        // continuation. This avoids potential crashes due to multiple resumptions of
        // the continuation.
        isCancelled = true

        // Resume the awaiting task with the resolved URL.
        continuation?.resume(returning: resolvedUrl)

        // Cleanup resources to prevent memory leaks and ensure proper deallocation.
        continuation = nil
        webView.navigationDelegate = nil
        webView.stopLoading()
        removeFromSuperview()
    }
}
