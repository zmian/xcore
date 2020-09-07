//
// Xcore
// Copyright © 2017 Xcore
// MIT license, see LICENSE file for details
//

import UIKit
import WebKit

extension WKWebView {
    /// Navigates to the first item in the back-forward list.
    ///
    /// A new navigation to the requested item, or nil if there is no back item in
    /// the back-forward list.
    @discardableResult
    public func goToFirstItem() -> WKNavigation? {
        guard let firstItem = backForwardList.backList.at(0) else {
            return nil
        }

        return go(to: firstItem)
    }

    /// Navigates to the last item in the back-forward list.
    ///
    /// A new navigation to the requested item, or nil if there is no back item in
    /// the back-forward list.
    @discardableResult
    public func goToLastItem() -> WKNavigation? {
        let forwardList = backForwardList.forwardList

        guard let lastItem = forwardList.at(forwardList.count - 1) else {
            return nil
        }

        return go(to: lastItem)
    }
}
