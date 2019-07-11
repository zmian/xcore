//
// UIViewController+Swizzle.swift
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

// MARK: - UIViewController

extension UIViewController {
    static func runOnceSwapSelectors() {
        swizzle(
            UIViewController.self,
            originalSelector: #selector(UIViewController.viewDidAppear(_:)),
            swizzledSelector: #selector(UIViewController.swizzled_viewDidAppear(_:))
        )

        swizzle(
            UIViewController.self,
            originalSelector: #selector(UIViewController.viewWillDisappear(_:)),
            swizzledSelector: #selector(UIViewController.swizzled_viewWillDisappear(_:))
        )

        swizzle_hidesBottomBarWhenPushed_runOnceSwapSelectors()
        swizzle_chrome_runOnceSwapSelectors()
    }
}

extension UIViewController {
    private struct AssociatedKey {
        static var didAddKeyboardNotificationObservers = "didAddKeyboardNotificationObservers"
    }

    private var didAddKeyboardNotificationObservers: Bool {
        get { return associatedObject(&AssociatedKey.didAddKeyboardNotificationObservers, default: false) }
        set { setAssociatedObject(&AssociatedKey.didAddKeyboardNotificationObservers, value: newValue) }
    }

    @objc private func swizzled_viewDidAppear(_ animated: Bool) {
        swizzled_viewDidAppear(animated)
        // Swizzled `viewDidAppear` and `viewWillDisappear` for keyboard notifications.
        // Registering keyboard notifications in `viewDidLoad` results in unexpected
        // keyboard behavior: when popping the viewController while the keyboard is
        // presented, keyboard will not dismiss in concurrent with the popping progress.
        if !didAddKeyboardNotificationObservers {
            _addKeyboardNotificationObservers()
            didAddKeyboardNotificationObservers = true
        }
    }

    @objc private func swizzled_viewWillDisappear(_ animated: Bool) {
        swizzled_viewWillDisappear(animated)
        if didAddKeyboardNotificationObservers {
            _removeKeyboardNotificationObservers()
            didAddKeyboardNotificationObservers = false
        }
    }
}

// MARK: - UIView

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
        swizzled_view_layoutSubviews()
        if !didAddKeyboardNotificationObservers {
            _addKeyboardNotificationObservers()
            didAddKeyboardNotificationObservers = true
        }
    }
}
