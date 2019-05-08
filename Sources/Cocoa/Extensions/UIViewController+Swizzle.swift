//
// UIViewController+Swizzle.swift
//
// Copyright © 2017 Zeeshan Mian
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
    static func runOnceSwapSelectors() {
        swizzle(
            UIViewController.self,
            originalSelector: #selector(UIViewController.viewDidLoad),
            swizzledSelector: #selector(UIViewController.swizzled_viewDidLoad)
        )

        swizzle_hidesBottomBarWhenPushed_runOnceSwapSelectors()
        swizzle_chrome_runOnceSwapSelectors()
    }

    @objc private func swizzled_viewDidLoad() {
        self.swizzled_viewDidLoad()
        _addKeyboardNotificationObservers()
    }
}

extension UIView {
    static func _runOnceSwapSelectors() {
        swizzle(
            UIView.self,
            originalSelector: #selector(UIView.layoutSubviews),
            swizzledSelector: #selector(UIView.swizzled_view_layoutSubviews)
        )
    }

    private struct AssociatedKey {
        static var didAddKeyboardNotificationObservers = "didAddKeyboardNotificationObservers"
    }

    private var didAddKeyboardNotificationObservers: Bool {
        get { return associatedObject(&AssociatedKey.didAddKeyboardNotificationObservers, default: false) }
        set { setAssociatedObject(&AssociatedKey.didAddKeyboardNotificationObservers, value: newValue) }
    }

    @objc private func swizzled_view_layoutSubviews() {
        self.swizzled_view_layoutSubviews()
        if !didAddKeyboardNotificationObservers {
            _addKeyboardNotificationObservers()
            didAddKeyboardNotificationObservers = true
        }
    }
}
