//
// Xcore
// Copyright © 2017 Xcore
// MIT license, see LICENSE file for details
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

    private enum AssociatedKey {
        static var didAddFauxChrome = "didAddFauxChrome"
    }

    private var didAddFauxChrome: Bool {
        get { associatedObject(&AssociatedKey.didAddFauxChrome, default: false) }
        set { setAssociatedObject(&AssociatedKey.didAddFauxChrome, value: newValue) }
    }

    @objc
    private func swizzled_viewWillAppear(_ animated: Bool) {
        swizzled_viewWillAppear(animated)

        if !didAddFauxChrome, navigationController is NavigationController {
            // Set navigation bar background based on `preferredNavigationBarBackground` value
            Chrome.setBackground(preferredNavigationBarBackground, for: .navigationBar, in: self)

            // Set status bar background based on `preferredStatusBarBackground` value
            Chrome.setBackground(preferredStatusBarBackground, for: .statusBar, in: self)
            didAddFauxChrome = true
        }
    }

    public func setNeedsNavigationBarAppearanceUpdate() {
        guard SwizzleManager.options.contains(.chrome) else {
            return
        }

        Chrome.setBackground(preferredNavigationBarBackground, for: .navigationBar, in: self)

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

    @objc
    private func swizzled_setNeedsStatusBarAppearanceUpdate() {
        swizzled_setNeedsStatusBarAppearanceUpdate()
        Chrome.setBackground(preferredStatusBarBackground, for: .statusBar, in: self)
    }
}
