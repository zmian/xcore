//
// Xcore
// Copyright © 2017 Xcore
// MIT license, see LICENSE file for details
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
    private enum AssociatedKey {
        static var didAddKeyboardNotificationObservers = "didAddKeyboardNotificationObservers"
    }

    private var didAddKeyboardNotificationObservers: Bool {
        get { associatedObject(&AssociatedKey.didAddKeyboardNotificationObservers, default: false) }
        set { setAssociatedObject(&AssociatedKey.didAddKeyboardNotificationObservers, value: newValue) }
    }

    @objc
    private func swizzled_viewDidAppear(_ animated: Bool) {
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

    @objc
    private func swizzled_viewWillDisappear(_ animated: Bool) {
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

    private enum AssociatedKey {
        static var didAddKeyboardNotificationObservers = "didAddKeyboardNotificationObservers"
    }

    private var didAddKeyboardNotificationObservers: Bool {
        get { associatedObject(&AssociatedKey.didAddKeyboardNotificationObservers, default: false) }
        set { setAssociatedObject(&AssociatedKey.didAddKeyboardNotificationObservers, value: newValue) }
    }

    @objc
    private func swizzled_view_layoutSubviews() {
        swizzled_view_layoutSubviews()
        if !didAddKeyboardNotificationObservers {
            _addKeyboardNotificationObservers()
            didAddKeyboardNotificationObservers = true
        }
    }
}
