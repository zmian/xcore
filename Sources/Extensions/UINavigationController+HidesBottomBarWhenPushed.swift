//
// UINavigationController+HidesBottomBarWhenPushed.swift
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

extension UINavigationController {
    private struct AssociatedKey {
        static var viewControllersWithHiddenBottomBar = "viewControllersWithHiddenBottomBar"
    }

    fileprivate var viewControllersWithHiddenBottomBar: Set<String> {
        get { return objc_getAssociatedObject(self, &AssociatedKey.viewControllersWithHiddenBottomBar) as? Set<String> ?? Set<String>() }
        set { objc_setAssociatedObject(self, &AssociatedKey.viewControllersWithHiddenBottomBar, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
}

extension UINavigationController {
    /// A helper function to ensure that `hidesBottomBarWhenPushed` value is respected when a view controller
    /// is pushed on to a navigation controller.
    ///
    /// The default behavior of the `hidesBottomBarWhenPushed` property of `UIViewController` is to ignores the value of
    /// any subsequent view controllers that are pushed on to the stack.
    ///
    /// According to the documentation: **If true, the bottom bar remains hidden until the view controller is popped from the stack.**
    ///
    /// **Usage:**
    /// ```swift
    /// override func pushViewController(_ viewController: UIViewController, animated: Bool) {
    ///     updateHidesBottomBarWhenPushed(viewController.prefersBottomBarHidden, for: viewController)
    ///     super.pushViewController(viewController, animated: animated)
    /// }
    ///
    /// override func setViewControllers(_ viewControllers: [UIViewController], animated: Bool) {
    ///     if let viewController = viewControllers.last {
    ///         updateHidesBottomBarWhenPushed(viewController.prefersBottomBarHidden, for: viewController)
    ///     }
    ///     super.setViewControllers(viewControllers, animated: animated)
    /// }
    /// ```
    open func updateHidesBottomBarWhenPushed(_ hidesBottomBar: Bool, for viewController: UIViewController?) {
        guard let viewController = viewController else {
            return
        }

        if hidesBottomBar {
            viewController.hidesBottomBarWhenPushed = false
            viewControllersWithHiddenBottomBar.insert(viewController.memoryAddress)
            rootViewController?.hidesBottomBarWhenPushed = true
        } else {
            rootViewController?.hidesBottomBarWhenPushed = false
        }
    }

    /// A helper function to ensure that `hidesBottomBarWhenPushed` value is respected when a view controller
    /// is pushed on to a navigation controller.
    ///
    /// The default behavior of the `hidesBottomBarWhenPushed` property of `UIViewController` is to ignores the value of
    /// any subsequent view controllers that are pushed on to the stack.
    ///
    /// According to the documentation: **If true, the bottom bar remains hidden until the view controller is popped from the stack.**
    ///
    /// **Usage:**
    /// ```swift
    /// override func popViewController(animated: Bool) -> UIViewController? {
    ///    return updateHidesBottomBarWhenPopped(super.popViewController, animated: animated)
    /// }
    /// ```
    open func updateHidesBottomBarWhenPopped(_ popViewController: (_ animated: Bool) -> UIViewController?, animated: Bool) -> UIViewController? {
        guard let previousViewController = viewControllers.at(viewControllers.count - 2) else {
            return popViewController(animated)
        }

        if viewControllersWithHiddenBottomBar.contains(previousViewController.memoryAddress) {
            rootViewController?.hidesBottomBarWhenPushed = true
        } else {
            rootViewController?.hidesBottomBarWhenPushed = false
        }

        let poppedViewController = popViewController(animated)

        if let poppedViewController = poppedViewController {
            viewControllersWithHiddenBottomBar.remove(poppedViewController.memoryAddress)
        }

        return poppedViewController
    }
}

