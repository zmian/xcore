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
    /// - parameter childController: The view controller to add as a child view controller.
    /// - parameter containerView:   A container view where this child view controller will be added. The default value is view controller's view.
    open func addContainerViewController(_ childController: UIViewController, containerView: UIView? = nil, enableConstraints: Bool = false, padding: UIEdgeInsets = .zero) {
        guard let containerView = containerView ?? view else { return }

        childController.beginAppearanceTransition(true, animated: false)
        childController.willMove(toParentViewController: self)
        addChildViewController(childController)
        containerView.addSubview(childController.view)
        childController.view.frame = containerView.bounds
        childController.didMove(toParentViewController: self)
        childController.endAppearanceTransition()

        if enableConstraints {
            NSLayoutConstraint.constraintsForViewToFillSuperview(childController.view, padding: padding).activate()
        }
    }

    /// A convenience method to easily remove child view controller.
    ///
    /// - parameter childController: The view controller to remove from its parent's children controllers.
    open func removeContainerViewController(_ childController: UIViewController) {
        guard childViewControllers.contains(childController) else { return }

        childController.beginAppearanceTransition(false, animated: false)
        childController.willMove(toParentViewController: nil)
        childController.view.removeFromSuperview()
        childController.removeFromParentViewController()
        childController.didMove(toParentViewController: nil)
        childController.endAppearanceTransition()
    }

    /// A boolean value to determine whether the view controller is being popped or is showing a subview controller.
    open var isBeingPopped: Bool {
        if isMovingFromParentViewController || isBeingDismissed {
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

    /// True iff `isDeviceLandscape` and `isInterfaceLandscape` both are true; false otherwise.
    public var isLandscape: Bool          { return isDeviceLandscape && isInterfaceLandscape }
    public var isInterfaceLandscape: Bool { return UIApplication.sharedOrNil?.statusBarOrientation.isLandscape ?? false }
    /// Returns the physical orientation of the device.
    public var isDeviceLandscape: Bool    { return UIDevice.current.orientation.isLandscape }
    /// This value represents the physical orientation of the device and may be different from the current orientation
    /// of your application’s user interface. See `UIDeviceOrientation` for descriptions of the possible values.
    public var deviceOrientation: UIDeviceOrientation { return UIDevice.current.orientation }

    /// Method to display view controller over current view controller as modal.
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
    /// - parameter viewControllerToPresent: The view controller to display over the current view controller's content.
    /// - parameter transitioningDelegate:   The delegate object that provides transition animator and interactive controller objects.
    /// - parameter animated:                Pass `true` to animate the presentation; otherwise, pass `false`.
    /// - parameter completion:              The block to execute after the presentation finishes.
    open func presentViewControllerWithTransition(_ viewControllerToPresent: UIViewController, modalPresentationStyle: UIModalPresentationStyle = .custom, transitioningDelegate: UIViewControllerTransitioningDelegate, animated: Bool = true, completion: (() -> Void)? = nil) {
        viewControllerToPresent.transitioningDelegate  = transitioningDelegate
        viewControllerToPresent.modalPresentationStyle = modalPresentationStyle
        present(viewControllerToPresent, animated: animated, completion: completion)
    }
}

extension UIViewController {
    fileprivate struct AssociatedKey {
        static var supportedInterfaceOrientations               = "XcoreSupportedInterfaceOrientations"
        static var preferredInterfaceOrientationForPresentation = "XcorePreferredInterfaceOrientationForPresentation"
        static var preferredStatusBarStyle                      = "XcorePreferredStatusBarStyle"
        static var preferredStatusBarUpdateAnimation            = "XcorePreferredStatusBarUpdateAnimation"
        static var prefersStatusBarHidden                       = "XcorePrefersStatusBarHidden"
        static var shouldAutorotate                             = "XcoreShouldAutorotate"
    }

    /// A convenience property to set `supportedInterfaceOrientations` without subclassing.
    /// This is useful when you don't have access to the actual class source code and need
    /// to set supported interface orientation.
    ///
    /// The default value is `nil` which means use the `supportedInterfaceOrientations` value.
    ///
    /// Setting this value on an instance of `UINavigationController` sets it for all of it's view controllers.
    /// And, any of its view controllers can override this on as needed basis.
    /// ```swift
    /// let vc = UIImagePickerController()
    /// vc.preferredInterfaceOrientations = .AllButUpsideDown
    /// ```
    open var preferredInterfaceOrientations: UIInterfaceOrientationMask? {
        get {
            if let intValue = objc_getAssociatedObject(self, &AssociatedKey.supportedInterfaceOrientations) as? UInt {
                return UIInterfaceOrientationMask(rawValue: intValue)
            } else {
                return nil
            }
        }
        set { objc_setAssociatedObject(self, &AssociatedKey.supportedInterfaceOrientations, newValue?.rawValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

    /// A convenience property to set `preferredInterfaceOrientationForPresentation` without subclassing.
    /// This is useful when you don't have access to the actual class source code and need
    /// to set supported interface orientation.
    ///
    /// The default value is `nil` which means use the `preferredInterfaceOrientationForPresentation` value.
    ///
    /// Setting this value on an instance of `UINavigationController` sets it for all of it's view controllers.
    /// And, any of its view controllers can override this on as needed basis.
    /// ```swift
    /// let vc = UIImagePickerController()
    /// vc.interfaceOrientationForPresentation = .Portrait
    /// ```
    open var interfaceOrientationForPresentation: UIInterfaceOrientation? {
        get {
            if let intValue = objc_getAssociatedObject(self, &AssociatedKey.preferredInterfaceOrientationForPresentation) as? Int {
                return UIInterfaceOrientation(rawValue: intValue)
            } else {
                return nil
            }
        }
        set { objc_setAssociatedObject(self, &AssociatedKey.preferredInterfaceOrientationForPresentation, newValue?.rawValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
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
    /// ```swift
    /// let vc = UIImagePickerController()
    /// vc.statusBarStyle = .LightContent
    /// ```
    open var statusBarStyle: UIStatusBarStyle? {
        get {
            if let intValue = objc_getAssociatedObject(self, &AssociatedKey.preferredStatusBarStyle) as? Int {
                return UIStatusBarStyle(rawValue: intValue)
            } else {
                return nil
            }
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKey.preferredStatusBarStyle, newValue?.rawValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
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
    /// ```swift
    /// let vc = UIImagePickerController()
    /// vc.statusBarUpdateAnimation = .Fade
    /// ```
    open var statusBarUpdateAnimation: UIStatusBarAnimation? {
        get {
            if let intValue = objc_getAssociatedObject(self, &AssociatedKey.preferredStatusBarUpdateAnimation) as? Int {
                return UIStatusBarAnimation(rawValue: intValue)
            } else {
                return nil
            }
        }
        set { objc_setAssociatedObject(self, &AssociatedKey.preferredStatusBarUpdateAnimation, newValue?.rawValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

    /// A convenience property to set `prefersStatusBarHidden` without subclassing.
    /// This is useful when you don't have access to the actual class source code and need
    /// to show/hide status bar.
    ///
    /// The default value is `nil` which means use the `prefersStatusBarHidden` value.
    ///
    /// Setting this value on an instance of `UINavigationController` sets it for all of it's view controllers.
    /// And, any of its view controllers can override this on as needed basis.
    /// ```swift
    /// let vc = UIImagePickerController()
    /// vc.isStatusBarHidden = false
    /// ```
    open var isStatusBarHidden: Bool? {
        get { return objc_getAssociatedObject(self, &AssociatedKey.prefersStatusBarHidden) as? Bool }
        set {
            objc_setAssociatedObject(self, &AssociatedKey.prefersStatusBarHidden, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
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
    /// ```swift
    /// let vc = UIImagePickerController()
    /// vc.enableAutorotate = false
    /// ```
    open var enableAutorotate: Bool? {
        get { return objc_getAssociatedObject(self, &AssociatedKey.shouldAutorotate) as? Bool }
        set { objc_setAssociatedObject(self, &AssociatedKey.shouldAutorotate, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
}
