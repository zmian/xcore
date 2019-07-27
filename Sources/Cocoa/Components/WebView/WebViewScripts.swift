//
// WebViewScripts.swift
//
// Copyright © 2017 Xcore
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

import UIKit
import WebKit

extension WKWebView {
    public var scripts: WebViewScripts {
        return WebViewScripts(for: self)
    }
}

public struct WebViewScripts {
    public let webView: WKWebView

    fileprivate init(for webView: WKWebView) {
        self.webView = webView
    }

    @discardableResult
    public func disableLongPress() -> WebViewScripts {
        webView.evaluateJavaScript("document.body.style.webkitTouchCallout='none';")
        return self
    }

    @discardableResult
    public func interceptLinkTap() -> WebViewScripts {
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
