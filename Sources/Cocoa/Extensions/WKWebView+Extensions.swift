//
// WKWebView+Extensions.swift
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
    /// Navigates to the first item in the back-forward list.
    /// A new navigation to the requested item, or nil if there is no back
    /// item in the back-forward list.
    @discardableResult
    public func goToFirstItem() -> WKNavigation? {
        guard let firstItem = backForwardList.backList.at(0) else {
            return nil
        }

        return go(to: firstItem)
    }

    /// Navigates to the last item in the back-forward list.
    /// A new navigation to the requested item, or nil if there is no back
    /// item in the back-forward list.
    @discardableResult
    public func goToLastItem() -> WKNavigation? {
        let forwardList = backForwardList.forwardList

        guard let lastItem = forwardList.at(forwardList.count - 1) else {
            return nil
        }

        return go(to: lastItem)
    }
}
