//
// Xcore
// Copyright © 2017 Xcore
// MIT license, see LICENSE file for details
//

import UIKit
import WebKit

extension WebViewController {
    /// A wrapper type to hold autofill script.
    ///
    /// Script will be injected right when the page loads.
    public struct Autofill {
        private let script: (_ webView: WKWebView) -> WebViewScripts

        public init(_ script: @escaping (_ webView: WKWebView) -> WebViewScripts) {
            self.script = script
        }

        func execute(_ webView: WKWebView) {
            _ = script(webView)
        }
    }
}
