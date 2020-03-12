//
// Xcore
// Copyright © 2017 Xcore
// MIT license, see LICENSE file for details
//

import UIKit
import WebKit

extension WKWebView {
    public var scripts: WebViewScripts {
        .init(for: self)
    }
}

public struct WebViewScripts {
    public let webView: WKWebView

    fileprivate init(for webView: WKWebView) {
        self.webView = webView
    }

    @discardableResult
    public func disableLongPress() -> Self {
        webView.evaluateJavaScript("document.body.style.webkitTouchCallout='none';")
        return self
    }

    @discardableResult
    public func interceptLinkTap() -> Self {
        let script = """
        if (document.addEventListener) {
            document.addEventListener('click', interceptClickEvent);
        } else if (document.attachEvent) {
            document.attachEvent('onclick', interceptClickEvent);
        }
        function interceptClickEvent(e) {
            var target = e.target || e.srcElement;
            if (target.tagName === 'A') {
                window.webkit.messageHandlers.\(WebViewScripts.linkInnerTextEventName).postMessage(target.innerText);
            }
        }
        """

        webView.evaluateJavaScript(script)
        return self
    }

    /// The name of the `messageHandlers` where the link taps (`interceptLinkTap()`) will be posted.
    public static var linkInnerTextEventName: String {
        return "xcoreLinkInnerText"
    }
}
