//
// Xcore
// Copyright © 2014 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

extension UIViewController {
    /// A convenience method to easily add child view controller.
    ///
    /// - Parameters:
    ///   - childViewController: The view controller to add as a child view
    ///     controller.
    ///   - containerView: A container view where this child view controller will be
    ///     added. The default value is view controller's view.
    open func addViewController(
        _ childViewController: UIViewController,
        containerView: UIView? = nil,
        enableConstraints: Bool = false,
        inset: UIEdgeInsets = 0
    ) {
        guard let containerView = containerView ?? view else {
            return
        }

        addChild(childViewController)
        containerView.addSubview(childViewController.view)
        childViewController.view.frame = containerView.bounds
        childViewController.didMove(toParent: self)

        if enableConstraints {
            childViewController.view.anchor.edges.equalToSuperview().inset(inset)
        }
    }

    /// Removes the view controller from its parent.
    open func removeFromContainerView() {
        guard parent != nil else {
            return
        }

        willMove(toParent: nil)
        removeFromParent()
        view.removeFromSuperview()
    }

    /// A boolean value to determine whether the view controller is the root view
    ///  controller of `UINavigationController` or `UITabBarController`.
    open var isRootViewController: Bool {
        if let rootViewController = navigationController?.rootViewController {
            return rootViewController == self
        }

        return tabBarController?.isRootViewController(self) ?? false
    }

    /// A boolean value to determine whether the view controller is being popped or
    /// is showing a subview controller.
    open var isBeingPopped: Bool {
        if isMovingFromParent || isBeingDismissed {
            return true
        }

        if let viewControllers = navigationController?.viewControllers, viewControllers.contains(self) {
            return false
        }

        return false
    }

    open var isModal: Bool {
        if presentingViewController != nil {
            return true
        }

        if presentingViewController?.presentedViewController == self {
            return true
        }

        if let navigationController = navigationController, navigationController.presentingViewController?.presentedViewController == navigationController {
            return true
        }

        if (tabBarController?.presentingViewController?.isKind(of: UITabBarController.self)) != nil {
            return true
        }

        return false
    }

    /// A boolean value indicating whether the view is currently loaded into memory
    /// and presented on the screen.
    public var isCurrentlyPresented: Bool {
        isViewLoaded && view.window != nil
    }

    /// A boolean value indicating whether the home indicator is currently present.
    public var isHomeIndicatorPresent: Bool {
        view.safeAreaInsets.bottom > 0
    }

    /// This value represents the physical orientation of the device and may be
    /// different from the current orientation of your application’s user interface.
    ///
    /// - SeeAlso: `UIDeviceOrientation` for descriptions of the possible values.
    public var deviceOrientation: UIDeviceOrientation {
        UIDevice.current.orientation
    }
}

// MARK: - Embed

extension UIViewController {
    /// Embed in navigation controller if needed.
    public func embedInNavigationControllerIfNeeded() -> UIViewController {
        guard canBeEmbeddedInNavigationController else {
            return self
        }

        return NavigationController(rootViewController: self)
    }

    /// A boolean value indicating whether the `self` can be embedded in
    /// `UINavigationController`.
    private var canBeEmbeddedInNavigationController: Bool {
        switch self {
            case is UINavigationController,
                 is UITabBarController:
                return false
            default:
                return true
        }
    }
}

extension UIWindow {
    public func setRootViewController(_ vc: UIViewController) {
        if rootViewController == vc {
            return
        }

        if let rvc = (rootViewController as? UINavigationController)?.rootViewController, rvc == vc {
            return
        }

        rootViewController = vc.embedInNavigationControllerIfNeeded()
        makeKeyAndVisible()
    }
}
