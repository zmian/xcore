//
// UIViewController+Extensions.swift
//
// Copyright © 2014 Zeeshan Mian
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
import ObjectiveC

extension UIViewController {
    /// A convenience method to easily add child view controller.
    ///
    /// - Parameters:
    ///   - childViewController: The view controller to add as a child view controller.
    ///   - containerView:   A container view where this child view controller will be added. The default value is view controller's view.
    open func addViewController(_ childViewController: UIViewController, containerView: UIView? = nil, enableConstraints: Bool = false, padding: UIEdgeInsets = .zero) {
        guard let containerView = containerView ?? view else { return }

        addChild(childViewController)
        containerView.addSubview(childViewController.view)
        childViewController.view.frame = containerView.bounds
        childViewController.didMove(toParent: self)

        if enableConstraints {
            NSLayoutConstraint.constraintsForViewToFillSuperview(childViewController.view, padding: padding).activate()
        }
    }

    /// Removes the view controller from its parent.
    open func removeFromContainerViewController() {
        guard parent != nil else {
            return
        }

        willMove(toParent: nil)
        removeFromParent()
        view.removeFromSuperview()
    }

    /// A boolean value to determine whether the view controller is being popped or is showing a subview controller.
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

    /// A boolean value indicating whether the view is currently
    /// loaded into memory and presented on the screen.
    public var isPresented: Bool {
        return isViewLoaded && view.window != nil
    }

    /// Only `true` iff `isDeviceLandscape` and `isInterfaceLandscape` both are `true`; Otherwise, `false`.
    public var isLandscape: Bool {
        return isDeviceLandscape && isInterfaceLandscape
    }

    public var isInterfaceLandscape: Bool {
        return UIApplication.sharedOrNil?.statusBarOrientation.isLandscape ?? false
    }

    /// Returns the physical orientation of the device.
    public var isDeviceLandscape: Bool {
        return UIDevice.current.orientation.isLandscape
    }

    /// This value represents the physical orientation of the device and may be different
    /// from the current orientation of your application’s user interface.
    ///
    /// - seealso: `UIDeviceOrientation` for descriptions of the possible values.
    public var deviceOrientation: UIDeviceOrientation {
        return UIDevice.current.orientation
    }

    /// A function to display view controller over current view controller as modal.
    open func presentViewControllerAsModal(_ viewControllerToPresent: UIViewController, animated: Bool, completion: (() -> Void)? = nil) {
        let orginalStyle = viewControllerToPresent.modalPresentationStyle
        if orginalStyle != .overCurrentContext {
            viewControllerToPresent.modalPresentationStyle = .overCurrentContext
        }

        present(viewControllerToPresent, animated: animated, completion: completion)

        if orginalStyle != .overCurrentContext {
            viewControllerToPresent.modalPresentationStyle = orginalStyle
        }
    }

    /// Presents a view controller modally using a custom transition.
    ///
    /// - Parameters:
    ///   - viewControllerToPresent: The view controller to display over the current view controller's content.
    ///   - transitioningDelegate:   The delegate object that provides transition animator and interactive controller objects.
    ///   - animated:                Pass `true` to animate the presentation; otherwise, pass `false`.
    ///   - completion:              The block to execute after the presentation finishes.
    open func presentViewControllerWithTransition(_ viewControllerToPresent: UIViewController, modalPresentationStyle: UIModalPresentationStyle = .custom, transitioningDelegate: UIViewControllerTransitioningDelegate, animated: Bool = true, completion: (() -> Void)? = nil) {
        viewControllerToPresent.transitioningDelegate = transitioningDelegate
        viewControllerToPresent.modalPresentationStyle = modalPresentationStyle
        present(viewControllerToPresent, animated: animated, completion: completion)
    }
}

extension UIViewController {
    private struct AssociatedKey {
        static var supportedInterfaceOrientations = "supportedInterfaceOrientations"
        static var preferredInterfaceOrientationForPresentation = "preferredInterfaceOrientationForPresentation"
        static var preferredStatusBarStyle = "preferredStatusBarStyle"
        static var preferredStatusBarUpdateAnimation = "preferredStatusBarUpdateAnimation"
        static var prefersStatusBarHidden = "prefersStatusBarHidden"
        static var shouldAutorotate = "shouldAutorotate"
    }

    /// A convenience property to set `supportedInterfaceOrientations` without subclassing.
    /// This is useful when you don't have access to the actual class source code and need
    /// to set supported interface orientation.
    ///
    /// The default value is `nil` which means use the `supportedInterfaceOrientations` value.
    ///
    /// Setting this value on an instance of `UINavigationController` sets it for all of it's view controllers.
    /// And, any of its view controllers can override this on as needed basis.
    ///
    /// ```swift
    /// let vc = UIImagePickerController()
    /// vc.preferredInterfaceOrientations = .allButUpsideDown
    /// ```
    open var preferredInterfaceOrientations: UIInterfaceOrientationMask? {
        get {
            guard let intValue: UInt = associatedObject(&AssociatedKey.supportedInterfaceOrientations) else {
                return nil
            }

            return UIInterfaceOrientationMask(rawValue: intValue)
        }
        set { setAssociatedObject(&AssociatedKey.supportedInterfaceOrientations, value: newValue?.rawValue) }
    }

    /// A convenience property to set `preferredInterfaceOrientationForPresentation` without subclassing.
    /// This is useful when you don't have access to the actual class source code and need
    /// to set supported interface orientation.
    ///
    /// The default value is `nil` which means use the `preferredInterfaceOrientationForPresentation` value.
    ///
    /// Setting this value on an instance of `UINavigationController` sets it for all of it's view controllers.
    /// And, any of its view controllers can override this on as needed basis.
    ///
    /// ```swift
    /// let vc = UIImagePickerController()
    /// vc.interfaceOrientationForPresentation = .portrait
    /// ```
    open var interfaceOrientationForPresentation: UIInterfaceOrientation? {
        get {
            guard let intValue: Int = associatedObject(&AssociatedKey.preferredInterfaceOrientationForPresentation) else {
                return nil
            }

            return UIInterfaceOrientation(rawValue: intValue)
        }
        set { setAssociatedObject(&AssociatedKey.preferredInterfaceOrientationForPresentation, value: newValue?.rawValue) }
    }

    /// A convenience property to set `preferredStatusBarStyle` without subclassing.
    /// This is useful when you don't have access to the actual class source code and need
    /// to update the status bar style to match with the app's look and feel.
    ///
    /// The default value is `nil` which means use the `preferredStatusBarStyle` value.
    ///
    /// Setting this value on an instance of `UINavigationController` sets it for all of it's view controllers.
    /// And, any of its view controllers can override this on as needed basis.
    /// This enables `info.plist`'s `View controller-based status bar appearance: NO` like behavior
    /// but allowing any of its view controllers to override the value.
    ///
    /// ```swift
    /// let vc = UIImagePickerController()
    /// vc.statusBarStyle = .lightContent
    /// ```
    open var statusBarStyle: UIStatusBarStyle? {
        get {
            guard let intValue: Int = associatedObject(&AssociatedKey.preferredStatusBarStyle) else {
                return nil
            }

            return UIStatusBarStyle(rawValue: intValue)
        }
        set {
            setAssociatedObject(&AssociatedKey.preferredStatusBarStyle, value: newValue?.rawValue)
            setNeedsStatusBarAppearanceUpdate()
        }
    }

    /// A convenience property to set `preferredStatusBarUpdateAnimation` without subclassing.
    /// This is useful when you don't have access to the actual class source code and need
    /// to update the status bar animation.
    ///
    /// The default value is `nil` which means use the `preferredStatusBarUpdateAnimation` value.
    ///
    /// Setting this value on an instance of `UINavigationController` sets it for all of it's view controllers.
    /// And, any of its view controllers can override this on as needed basis.
    ///
    /// ```swift
    /// let vc = UIImagePickerController()
    /// vc.statusBarUpdateAnimation = .fade
    /// ```
    open var statusBarUpdateAnimation: UIStatusBarAnimation? {
        get {
            guard let intValue: Int = associatedObject(&AssociatedKey.preferredStatusBarUpdateAnimation) else {
                return nil
            }

            return UIStatusBarAnimation(rawValue: intValue)
        }
        set { setAssociatedObject(&AssociatedKey.preferredStatusBarUpdateAnimation, value: newValue?.rawValue) }
    }

    /// A convenience property to set `prefersStatusBarHidden` without subclassing.
    /// This is useful when you don't have access to the actual class source code and need
    /// to show/hide status bar.
    ///
    /// The default value is `nil` which means use the `prefersStatusBarHidden` value.
    ///
    /// Setting this value on an instance of `UINavigationController` sets it for all of it's view controllers.
    /// And, any of its view controllers can override this on as needed basis.
    ///
    /// ```swift
    /// let vc = UIImagePickerController()
    /// vc.isStatusBarHidden = false
    /// ```
    open var isStatusBarHidden: Bool? {
        get { return associatedObject(&AssociatedKey.prefersStatusBarHidden) }
        set {
            setAssociatedObject(&AssociatedKey.prefersStatusBarHidden, value: newValue)
            setNeedsStatusBarAppearanceUpdate()
        }
    }

    /// A convenience property to set `shouldAutorotate` without subclassing.
    /// This is useful when you don't have access to the actual class source code and need
    /// to enable/disable rotation.
    ///
    /// The default value is `nil` which means use the `shouldAutorotate` value.
    ///
    /// Setting this value on an instance of `UINavigationController` sets it for all of it's view controllers.
    /// And, any of its view controllers can override this on as needed basis.
    ///
    /// ```swift
    /// let vc = UIImagePickerController()
    /// vc.isAutorotateEnabled = false
    /// ```
    open var isAutorotateEnabled: Bool? {
        get { return associatedObject(&AssociatedKey.shouldAutorotate) }
        set { setAssociatedObject(&AssociatedKey.shouldAutorotate, value: newValue) }
    }
}
