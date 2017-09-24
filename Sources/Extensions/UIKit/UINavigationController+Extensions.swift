//
// UINavigationController+Extensions.swift
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

extension UINavigationController {
    /// Initializes and returns a newly created navigation controller that uses your custom bar subclasses.
    ///
    /// - parameter rootViewController: The view controller that resides at the bottom of the navigation stack. This object cannot be an instance of the `UITabBarController` class.
    /// - parameter navigationBarClass: Specify the custom `UINavigationBar` subclass you want to use, or specify `nil` to use the standard `UINavigationBar` class.
    /// - parameter toolbarClass:       Specify the custom `UIToolbar` subclass you want to use, or specify `nil` to use the standard `UIToolbar` class.
    ///
    /// - returns: The initialized navigation controller object.
    public convenience init(rootViewController: UIViewController, navigationBarClass: AnyClass?, toolbarClass: AnyClass?) {
        self.init(navigationBarClass: navigationBarClass, toolbarClass: toolbarClass)
        self.rootViewController = rootViewController
    }

    /// A convenience property to set root view controller without animation.
    open var rootViewController: UIViewController? {
        get { return viewControllers.first }
        set {
            var rvc: [UIViewController] = []
            if let vc = newValue {
                rvc = [vc]
            }
            setViewControllers(rvc, animated: false)
        }
    }
}

extension UINavigationController {
    /// A convenience method to pop to view controller of specified subclass of `UIViewController` type.
    ///
    /// - parameter type:            The View controller type to pop to.
    /// - parameter animated:        Set this value to `true` to animate the transition.
    ///                              Pass `false` if you are setting up a navigation controller
    ///                              before its view is displayed.
    /// - parameter isReversedOrder: If multiple view controllers of specified type exists it
    ///                              pop the latest of type by default. Pass `false` to reverse the behavior.
    ///
    /// - returns: An array containing the view controllers that were popped from the stack.
    @discardableResult
    open func popToViewController(_ type: UIViewController.Type, animated: Bool, isReversedOrder: Bool = true) -> [UIViewController]? {
        let viewControllers = isReversedOrder ? self.viewControllers.reversed() : self.viewControllers

        for viewController in viewControllers {
            if viewController.isKind(of: type) {
                return popToViewController(viewController, animated: animated)
            }
        }

        return nil
    }

    /// A convenience method to pop view controllers until the one at specified index is on top. Returns the popped controllers.
    ///
    /// - parameter index:    The View controller type to pop to.
    /// - parameter animated: Set this value to `true` to animate the transition.
    ///                       Pass `false` if you are setting up a navigation controller
    ///                       before its view is displayed.
    ///
    /// - returns: An array containing the view controllers that were popped from the stack.
    @discardableResult
    open func popToViewController(at index: Int, animated: Bool) -> [UIViewController]? {
        guard let viewController = viewControllers.at(index) else {
            return nil
        }

        return popToViewController(viewController, animated: animated)
    }

    open func pushOnFirstViewController(_ viewController: UIViewController, animated: Bool = true) {
        var vcs = [UIViewController]()
        if let firstViewController = viewControllers.first {
            vcs.append(firstViewController)
        }
        vcs.append(viewController)
        setViewControllers(vcs, animated: animated)
    }
}

extension UINavigationController {
    // Autorotation Fix. Simply override `supportedInterfaceOrientations`
    // method in any view controller and it would respect that orientation
    // setting per view controller.
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return topViewController?.preferredInterfaceOrientations ?? preferredInterfaceOrientations ?? topViewController?.supportedInterfaceOrientations ?? super.supportedInterfaceOrientations
    }

    open override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return topViewController?.interfaceOrientationForPresentation ?? interfaceOrientationForPresentation ?? topViewController?.preferredInterfaceOrientationForPresentation ?? super.preferredInterfaceOrientationForPresentation
    }

    // Setting `preferredStatusBarStyle` works.
    open override var childViewControllerForStatusBarStyle: UIViewController? {
        if topViewController?.statusBarStyle != nil || statusBarStyle != nil {
            return nil
        } else {
            return topViewController
        }
    }

    // Setting `prefersStatusBarHidden` works.
    open override var childViewControllerForStatusBarHidden: UIViewController? {
        if topViewController?.isStatusBarHidden != nil || isStatusBarHidden != nil {
            return nil
        } else {
            return topViewController
        }
    }

    open override var shouldAutorotate: Bool {
        return topViewController?.enableAutorotate ?? enableAutorotate ?? topViewController?.shouldAutorotate ?? super.shouldAutorotate
    }

    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return topViewController?.statusBarStyle ?? statusBarStyle ?? topViewController?.preferredStatusBarStyle ?? super.preferredStatusBarStyle
    }

    open override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return topViewController?.statusBarUpdateAnimation ?? statusBarUpdateAnimation ?? topViewController?.preferredStatusBarUpdateAnimation ?? super.preferredStatusBarUpdateAnimation
    }

    open override var prefersStatusBarHidden: Bool {
        return topViewController?.isStatusBarHidden ?? isStatusBarHidden ?? topViewController?.prefersStatusBarHidden ?? super.prefersStatusBarHidden
    }
}
