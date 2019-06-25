//
// NavigationController.swift
//
// Copyright © 2016 Xcore
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

open class NavigationController: UINavigationController {
    // swiftlint:disable:next weak_delegate
    private let zoomAnimatorNavigationControllerDelegate = ZoomAnimatorNavigationControllerDelegate()
    private let emptyBackBarButtonItem = UIBarButtonItem(title: "")
    /// A boolean value that determines whether the back button text is hidden.
    /// The default value is `true`.
    public var hideBackButtonText = true {
        didSet {
            backButtonTextOverride()
        }
    }

    open override func viewDidLoad() {
        super.viewDidLoad()
        isAutorotateEnabled = false
        preferredInterfaceOrientations = .portrait
        delegate = self
    }

    open override func awakeFromNib() {
        backButtonTextOverride()
        super.awakeFromNib()
    }

    open override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        backButtonTextOverride()
        updateNavigationBar(for: viewController)
        super.pushViewController(viewController, animated: animated)
    }

    open override func setViewControllers(_ viewControllers: [UIViewController], animated: Bool) {
        if let viewController = viewControllers.last {
            updateNavigationBar(for: viewController)
        }
        viewControllers.forEach { $0.hidesBottomBarWhenPushed = $0.prefersTabBarHidden }
        backButtonTextOverride(targetViewControllers: viewControllers)
        updateNavigationBarAnimation(for: viewControllers.last)
        super.setViewControllers(viewControllers, animated: animated)
    }

    private func backButtonTextOverride(targetViewControllers: [UIViewController]? = nil) {
        let targetViewControllers = targetViewControllers ?? viewControllers
        targetViewControllers.forEach {
            $0.navigationItem.backBarButtonItem = hideBackButtonText ? emptyBackBarButtonItem : nil
        }
    }

    // MARK: - Hooks

    private var willShow: ((_ viewController: UIViewController) -> Void)?
    public func willShow(_ callback: @escaping (_ viewController: UIViewController) -> Void) {
        willShow = callback
    }

    private var willTransition: ((_ fromVC: UIViewController, _ toVC: UIViewController) -> Void)?
    public func willTransition(_ callback: @escaping (_ fromVC: UIViewController, _ toVC: UIViewController) -> Void) {
        willTransition = callback
    }
}

extension NavigationController {
    /// Returns a bar button item that dismisses `self`.
    private func dismissButtonItem() -> UIBarButtonItem {
        return UIBarButtonItem(barButtonSystemItem: .done).apply {
            $0.accessibilityIdentifier = "dismissButton"
            $0.addAction { [weak self] _ in
                self?.dismiss(animated: true)
            }
        }
    }
}

// MARK: - UINavigationControllerDelegate

extension NavigationController: UINavigationControllerDelegate {
    func _internalUpdateNavigationBar(for viewController: UIViewController) {
        updateNavigationBar(for: viewController)
    }

    private func updateNavigationBar(for viewController: UIViewController, didShow: Bool = false) {
        updateNavigationBarAnimation(for: viewController)
        isNavigationBarHidden = viewController.prefersNavigationBarHidden

        // If the `prefersNavigationBarHidden` is true then the user shouldn't be able
        // to navigate back using the swipe back gesture.
        if viewController.prefersNavigationBarHidden {
            viewController.isSwipeBackGestureEnabled = false
        }

        navigationBar.isTransparent = true
        navigationBar.prefersNavigationBarBackground = !viewController.preferredNavigationBarBackground.isTransparent
        interactivePopGestureRecognizer?.isEnabled = viewController.isSwipeBackGestureEnabled
        updateBarButtonItemsAttributes(for: viewController)

        // Update navigation bar tint color to the preferred navigation bar tint color for the new view controller.
        navigationBar.tintColor = viewController.preferredNavigationBarTintColor

        // Modal Presentation Support
        if didShow, isModal, let viewController = viewControllers.last, viewController.navigationItem.rightBarButtonItem == nil {
            if viewControllers.count == 1, !viewController.prefersDismissButtonHiddenWhenPresentedModally {
                viewController.navigationItem.rightBarButtonItem = dismissButtonItem()
            }
        }

        var attributes = UIViewController.defaultNavigationBarTextAttributes
        attributes.merge(viewController.preferredNavigationBarTitleAttributes)
        if navigationBar.titleTextAttributes != nil {
            navigationBar.titleTextAttributes?.merge(attributes)
        } else {
            navigationBar.titleTextAttributes = attributes
        }

        viewController.hidesBottomBarWhenPushed = viewController.prefersTabBarHidden
    }

    private func updateBarButtonItemsAttributes(for viewController: UIViewController) {
        func update(item: UIBarButtonItem?) {
            guard let item = item else { return }
            // If current tint color is default color then switch over to the preferred tint color
            if item.tintColor == defaultTintColor && item.tintColor != viewController.preferredNavigationBarTintColor {
                item.tintColor = viewController.preferredNavigationBarTintColor
            }

            // If current text color is default color then switch over to the preferred tint color
            if item.textColor == defaultTintColor && item.textColor != viewController.preferredNavigationBarTintColor {
                item.textColor = viewController.preferredNavigationBarTintColor
            }

            if let font = UIViewController.defaultNavigationBarTextAttributes[.font] as? UIFont {
                item.font = font
            }
        }

        viewController.navigationItem.leftBarButtonItems?.forEach {
            update(item: $0)
        }

        viewController.navigationItem.rightBarButtonItems?.forEach {
            update(item: $0)
        }
    }

    private var defaultTintColor: UIColor {
        return UIViewController.defaultAppearance.tintColor
    }

    private func updateNavigationBarAnimation(for viewController: UIViewController?) {
        let fadeTitleKey = "fadeTitle"

        guard let viewController = viewController, viewController.prefersNavigationBarFadeAnimation else {
            navigationBar.layer.removeAnimation(forKey: fadeTitleKey)
            return
        }

        CATransition().apply {
            $0.duration = 1.5
            $0.timingFunction = .easeInEaseOut
            $0.type = .fade
            navigationBar.layer.add($0, forKey: fadeTitleKey)
        }
    }

    open func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        guard let transitionCoordinator = transitionCoordinator else {
            return updateNavigationBar(for: viewController)
        }

        transitionCoordinator.notifyWhenInteractionChanges { [weak self] context in
            let vc: UITransitionContextViewControllerKey = context.isCancelled ? .from : .to
            guard let strongSelf = self, let viewController = context.viewController(forKey: vc) else {
                return
            }

            strongSelf.updateNavigationBar(for: viewController)
        }

        willShow?(viewController)
    }

    open func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        zoomAnimatorNavigationControllerDelegate.navigationController(navigationController, didShow: viewController, animated: animated)
        updateNavigationBar(for: viewController, didShow: true)
    }

    open func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        willTransition?(fromVC, toVC)
        return zoomAnimatorNavigationControllerDelegate.navigationController(navigationController, animationControllerFor: operation, from: fromVC, to: toVC)
    }
}

// MARK: - UINavigationControllerDelegate Forward Calls

extension NavigationController {
    open override func responds(to aSelector: Selector!) -> Bool {
        if zoomAnimatorNavigationControllerDelegate.responds(to: aSelector) {
            return true
        }

        return super.responds(to: aSelector)
    }

    open override func forwardingTarget(for aSelector: Selector!) -> Any? {
        if zoomAnimatorNavigationControllerDelegate.responds(to: aSelector) {
            return zoomAnimatorNavigationControllerDelegate
        }

        return super.forwardingTarget(for: aSelector)
    }
}
