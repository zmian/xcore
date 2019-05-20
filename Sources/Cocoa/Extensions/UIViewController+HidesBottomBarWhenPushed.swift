//
// UIViewController+HidesBottomBarWhenPushed.swift
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
    private struct AssociatedKey {
        static var didAddKeyboardNotificationObservers = "didAddKeyboardNotificationObservers"
    }

    private var didAddKeyboardNotificationObservers: Bool {
        get { return associatedObject(&AssociatedKey.didAddKeyboardNotificationObservers, default: false) }
        set { setAssociatedObject(&AssociatedKey.didAddKeyboardNotificationObservers, value: newValue) }
    }

    static func runOnceSwapSelectors() {
        swizzle(
            UIViewController.self,
            originalSelector: #selector(UIViewController.viewDidAppear),
            swizzledSelector: #selector(UIViewController.swizzled_viewDidAppear)
        )

        swizzle(
            UIViewController.self,
            originalSelector: #selector(UIViewController.viewWillDisappear),
            swizzledSelector: #selector(UIViewController.swizzled_viewWillDisappear)
        )

        swizzle(
            UIViewController.self,
            originalSelector: #selector(getter: UIViewController.hidesBottomBarWhenPushed),
            swizzledSelector: #selector(getter: UIViewController.swizzled_hidesBottomBarWhenPushed)
        )
    }

    /// Swizzled viewDidAppear and viewWillDisappear for keyboard notifications.
    /// Registering keyboard notifications in `viewDidLoad` results in unexpected
    /// keyboard behavior: when popping the viewController while the keyboard is
    /// presented, keyboard will not dismiss in concurrent with the popping progress.
    @objc private func swizzled_viewDidAppear() {
        self.swizzled_viewDidAppear()
        if !didAddKeyboardNotificationObservers {
            _addKeyboardNotificationObservers()
            didAddKeyboardNotificationObservers = true
        }
    }

    @objc private func swizzled_viewWillDisappear() {
        self.swizzled_viewWillDisappear()
        if didAddKeyboardNotificationObservers {
            _removeKeyboardNotificationObservers()
            didAddKeyboardNotificationObservers = false
        }
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

extension UIView {
    private struct AssociatedKey {
        static var didAddKeyboardNotificationObservers = "didAddKeyboardNotificationObservers"
    }

    private var didAddKeyboardNotificationObservers: Bool {
        get { return associatedObject(&AssociatedKey.didAddKeyboardNotificationObservers, default: false) }
        set { setAssociatedObject(&AssociatedKey.didAddKeyboardNotificationObservers, value: newValue) }
    }

    static func _runOnceSwapSelectors() {
        swizzle(
            UIView.self,
            originalSelector: #selector(UIView.layoutSubviews),
            swizzledSelector: #selector(UIView.swizzled_view_layoutSubviews)
        )
    }

    @objc private func swizzled_view_layoutSubviews() {
        self.swizzled_view_layoutSubviews()
        if !didAddKeyboardNotificationObservers {
            _addKeyboardNotificationObservers()
            didAddKeyboardNotificationObservers = true
        }
    }
}
