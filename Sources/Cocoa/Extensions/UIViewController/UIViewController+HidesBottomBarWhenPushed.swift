//
// UIViewController+HidesBottomBarWhenPushed.swift
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

extension UIViewController {
    static func swizzle_hidesBottomBarWhenPushed_runOnceSwapSelectors() {
        swizzle(
            UIViewController.self,
            originalSelector: #selector(getter: UIViewController.hidesBottomBarWhenPushed),
            swizzledSelector: #selector(getter: UIViewController.swizzled_hidesBottomBarWhenPushed)
        )
    }

    /// A swizzled function to ensure that `hidesBottomBarWhenPushed` value is
    /// respected when a view controller is pushed on to a navigation controller.
    ///
    /// The default behavior of the `hidesBottomBarWhenPushed` property of
    /// `UIViewController` is to ignores the value of any subsequent view
    /// controllers that are pushed on to the stack.
    ///
    /// According to the documentation: **If true, the bottom bar remains hidden
    /// until the view controller is popped from the stack.**
    @objc private var swizzled_hidesBottomBarWhenPushed: Bool {
        let value = self.swizzled_hidesBottomBarWhenPushed

        if value, navigationController?.topViewController != self {
            return false
        }

        return value
    }
}
