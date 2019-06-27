//
// Chrome+Swizzle.swift
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
    static func swizzle_chrome_runOnceSwapSelectors() {
        guard SwizzleManager.options.contains(.chrome) else {
            return
        }

        swizzle(
            UIViewController.self,
            originalSelector: #selector(UIViewController.viewWillAppear(_:)),
            swizzledSelector: #selector(UIViewController.swizzled_viewWillAppear(_:))
        )

        swizzle(
            UIViewController.self,
            originalSelector: #selector(UIViewController.setNeedsStatusBarAppearanceUpdate),
            swizzledSelector: #selector(UIViewController.swizzled_setNeedsStatusBarAppearanceUpdate)
        )
    }

    private struct AssociatedKey {
        static var didAddFauxChrome = "didAddFauxChrome"
    }

    private var didAddFauxChrome: Bool {
        get { return associatedObject(&AssociatedKey.didAddFauxChrome, default: false) }
        set { setAssociatedObject(&AssociatedKey.didAddFauxChrome, value: newValue) }
    }

    @objc private func swizzled_viewWillAppear(_ animated: Bool) {
        swizzled_viewWillAppear(animated)

        if !didAddFauxChrome, navigationController is NavigationController {
            // Set navigation bar background based on `preferredNavigationBarBackground` value
            Chrome.setBackground(style: preferredNavigationBarBackground, for: .navBar, in: self)

            // Set status bar background based on `preferredStatusBarBackground` value
            Chrome.setBackground(style: preferredStatusBarBackground, for: .statusBar, in: self)
            didAddFauxChrome = true
        }
    }

    public func setNeedsNavigationBarAppearanceUpdate() {
        guard SwizzleManager.options.contains(.chrome) else {
            return
        }

        Chrome.setBackground(style: preferredNavigationBarBackground, for: .navBar, in: self)

        guard let navigationController = navigationController as? NavigationController else {
            return
        }

        navigationController._internalUpdateNavigationBar(for: self)
    }

    public func setNeedsChromeAppearanceUpdate() {
        guard SwizzleManager.options.contains(.chrome) else {
            return
        }

        setNeedsStatusBarAppearanceUpdate()
        setNeedsNavigationBarAppearanceUpdate()
    }

    @objc private func swizzled_setNeedsStatusBarAppearanceUpdate() {
        swizzled_setNeedsStatusBarAppearanceUpdate()
        Chrome.setBackground(style: preferredStatusBarBackground, for: .statusBar, in: self)
    }
}
