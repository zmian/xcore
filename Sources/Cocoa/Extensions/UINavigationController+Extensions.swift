//
// UINavigationController+Extensions.swift
//
// Copyright © 2014 Xcore
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
    /// Initializes and returns a newly created navigation controller that uses your
    /// custom bar subclasses.
    ///
    /// - Parameters:
    ///   - rootViewController: The view controller that resides at the bottom of
    ///                         the navigation stack. This object cannot be an
    ///                         instance of the `UITabBarController` class.
    ///   - navigationBarClass: Specify the custom `UINavigationBar` subclass you
    ///                         want to use, or specify `nil` to use the standard
    ///                         `UINavigationBar` class.
    ///   - toolbarClass: Specify the custom `UIToolbar` subclass you want to use,
    ///                   or specify `nil` to use the standard `UIToolbar` class.
    /// - Returns: The initialized navigation controller object.
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
    /// Pushes a view controller onto the receiver’s stack and updates the display.
    ///
    /// The object in the viewController parameter becomes the top view controller
    /// on the navigation stack. Pushing a view controller causes its view to be
    /// embedded in the navigation interface. If the animated parameter is `true`,
    /// the view is animated into position; otherwise, the view is simply displayed
    /// in its final location.
    ///
    /// In addition to displaying the view associated with the new view controller
    /// at the top of the stack, this method also updates the navigation bar and
    /// tool bar accordingly. For information on how the navigation bar is updated.
    ///
    /// - Parameters:
    ///   - viewController: The view controller to push onto the stack. This object
    ///                     cannot be a tab bar controller.
    ///                     If the view controller is already on the navigation
    ///                     stack, this method throws an exception.
    ///   - animated: Specify `true` to animate the transition or `false` if you do
    ///               not want the transition to be animated.
    ///               You might specify `false` if you are setting up the navigation
    ///               controller at launch time.
    ///   - completion: The block to execute after the presentation finishes.
    open func pushViewController(_ viewController: UIViewController, animated: Bool, completion: (() -> Void)?) {
        CATransaction.animationTransaction({
            pushViewController(viewController, animated: animated)
        }, completionHandler: completion)
    }

    /// Pushes a list of view controller onto the receiver’s stack and updates the
    /// display.
    ///
    /// The object in the viewController parameter becomes the top view controller
    /// on the navigation stack. Pushing a view controller causes its view to be
    /// embedded in the navigation interface. If the animated parameter is `true`,
    /// the view is animated into position; otherwise, the view is simply displayed
    /// in its final location.
    ///
    /// In addition to displaying the view associated with the new view controller
    /// at the top of the stack, this method also updates the navigation bar and
    /// tool bar accordingly. For information on how the navigation bar is updated.
    ///
    /// - Parameters:
    ///   - viewControllers: The view controller to push onto the stack. This object
    ///                     cannot be a tab bar controller.
    ///                     If the view controller is already on the navigation
    ///                     stack, this method throws an exception.
    ///   - animated: Specify `true` to animate the transition or `false` if you do
    ///               not want the transition to be animated.
    ///               You might specify `false` if you are setting up the navigation
    ///               controller at launch time.
    ///   - completion: The block to execute after the presentation finishes.
    open func pushViewController(_ viewControllers: [UIViewController], animated: Bool, completion: (() -> Void)? = nil) {
        var vcs = self.viewControllers
        vcs.append(contentsOf: viewControllers)

        CATransaction.animationTransaction({
            setViewControllers(vcs, animated: animated)
        }, completionHandler: completion)
    }

    /// A convenience method to pop to view controller of specified subclass of
    /// `UIViewController` type.
    ///
    /// - Parameters:
    ///   - type: The View controller type to pop to.
    ///   - animated: Set this value to `true` to animate the transition. Pass
    ///               `false` if you are setting up a navigation controller before
    ///               its view is displayed.
    ///   - reversedOrder: If multiple view controllers of specified type exists it
    ///                    pop the latest of type by default. Pass `false` to
    ///                    reverse the behavior.
    /// - Returns: An array containing the view controllers that were popped from
    ///            the stack.
    @discardableResult
    open func popToViewController(_ type: UIViewController.Type, animated: Bool, reversedOrder: Bool = true) -> [UIViewController]? {
        let viewControllers = reversedOrder ? self.viewControllers.reversed() : self.viewControllers

        for viewController in viewControllers {
            if viewController.isKind(of: type) {
                return popToViewController(viewController, animated: animated)
            }
        }

        return nil
    }

    /// A convenience method to pop to specified subclass of `UIViewController`
    /// type. If the given type of view controller is not found then it pops to the
    /// root view controller.
    ///
    /// - Parameters:
    ///   - type: The view controller type to pop to.
    ///   - animated: Set this value to `true` to animate the transition.
    ///               Pass `false` if you are setting up a navigation controller
    ///               before its view is displayed.
    /// - Returns: The view controller instance of the specified type `T`.
    @discardableResult
    public func popToViewControllerOrRootViewController<T: UIViewController>(_ type: T.Type, animated: Bool) -> T? {
        guard let viewController = viewControllers.lastElement(type: type) else {
            popToRootViewController(animated: animated)
            return nil
        }

        popToViewController(viewController, animated: animated)
        return viewController
    }

    /// A convenience method to pop view controllers until the one at specified
    /// index is on top. Returns the popped controllers.
    ///
    /// - Parameters:
    ///   - index: The View controller type to pop to.
    ///   - animated: Set this value to `true` to animate the transition.
    ///               Pass `false` if you are setting up a navigation controller
    ///               before its view is displayed.
    /// - Returns: An array containing the view controllers that were popped from
    ///            the stack.
    @discardableResult
    open func popToViewController(at index: Int, animated: Bool) -> [UIViewController]? {
        guard let viewController = viewControllers.at(index) else {
            return nil
        }

        return popToViewController(viewController, animated: animated)
    }

    open func pushOnFirstViewController(_ viewController: UIViewController, animated: Bool, completion: (() -> Void)? = nil) {
        var vcs = [UIViewController]()
        if let firstViewController = viewControllers.first {
            vcs.append(firstViewController)
        }
        vcs.append(viewController)

        CATransaction.animationTransaction({
            setViewControllers(vcs, animated: animated)
        }, completionHandler: completion)
    }

    open func replaceLastViewController(with viewController: UIViewController, animated: Bool, completion: (() -> Void)? = nil) {
        var vcs = viewControllers
        vcs.removeLast()
        vcs.append(viewController)

        CATransaction.animationTransaction({
            setViewControllers(vcs, animated: animated)
        }, completionHandler: completion)
    }

    /// A convenience method to push a view controller by replacing all view
    /// controllers from a specific view controller type, including this one. If the
    /// given type of view controller is not found then it pushes on top of the
    /// stack.
    ///
    /// - Parameters:
    ///   - viewController: The view controller to push
    ///   - location: The view controller type from where to perform the push
    ///   - replacing: Indicates if the view controller replaces or is pushed on top
    ///                of the 'location' one
    ///   - animated: Set this value to `true` to animate the transition. Pass
    ///               `false` if you are setting up a navigation controller before
    ///               its view is displayed.
    open func pushViewController(
        _ viewController: UIViewController,
        on location: UIViewController.Type,
        replacing: Bool,
        animated: Bool
    ) {
        guard let index = viewControllers.firstIndex(of: location) else {
            return pushViewController(viewController, animated: animated)
        }

        var remainingViewControllers = Array(replacing ? viewControllers.prefix(upTo: index) : viewControllers.prefix(through: index))
        remainingViewControllers.append(viewController)
        setViewControllers(remainingViewControllers, animated: animated)
    }
}

extension UINavigationController {
    /// The type of animation when view controller is push.
    public enum AnimationStyle {
        case `default`
        case fade

        private var transitionType: CATransitionType {
            switch self {
                case .default:
                    return .none
                case .fade:
                    return .fade
            }
        }

        fileprivate var transition: CATransition {
            return CATransition().apply {
                $0.duration = .slow
                $0.timingFunction = .easeInEaseOut
                $0.type = transitionType
            }
        }
    }

    /// Pushes a view controller onto the receiver’s stack and updates the
    /// display.
    ///
    /// The object in the `viewController` parameter becomes the top view controller
    /// on the navigation stack. Pushing a view controller causes its view to be
    /// embedded in the navigation interface. If the animated parameter is `true`,
    /// the view is animated into position; otherwise, the view is simply displayed
    /// in its final location.
    ///
    /// In addition to displaying the view associated with the new view controller
    /// at the top of the stack, this method also updates the navigation bar and
    /// tool bar accordingly. For information on how the navigation bar is updated.
    ///
    /// - Parameters:
    ///   - viewController: The view controller to push onto the stack. This object
    ///                     cannot be a tab bar controller.
    ///
    ///                     If the view controller is already on the navigation
    ///                     stack, this method throws an exception.
    ///   - animation: A property that indicates how the push animation is to be
    ///                animated, for example, fade in or slide in from right.
    open func pushViewController(_ viewController: UIViewController, with animation: AnimationStyle) {
        guard animation != .default else {
            return pushViewController(viewController, animated: true)
        }

        view.layer.add(animation.transition, forKey: nil)
        pushViewController(viewController, animated: false)
    }

    /// Pops the top view controller from the navigation stack and updates the
    /// display.
    ///
    /// This method removes the top view controller from the stack and makes the new
    /// top of the stack the active view controller. If the view controller at the
    /// top of the stack is the root view controller, this method does nothing. In
    /// other words, you cannot pop the last item on the stack.
    ///
    /// In addition to displaying the view associated with the new view controller
    /// at the top of the stack, this method also updates the navigation bar and
    /// tool bar accordingly. For information on how the navigation bar is updated.
    ///
    /// - Parameter animation: A property that indicates how the pop animation is to
    ///                        be animated, for example, fade out or slide out to
    ///                        right.
    /// - Returns: The view controller that was popped from the stack.
    @discardableResult
    open func popViewController(with animation: AnimationStyle) -> UIViewController? {
        guard animation != .default else {
            return popViewController(animated: true)
        }

        view.layer.add(animation.transition, forKey: nil)
        return popViewController(animated: false)
    }
}

extension UINavigationController {
    // Autorotation Fix. Simply override `supportedInterfaceOrientations` method in
    // any view controller and it would respect that orientation setting per view
    // controller.
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return topViewController?.preferredInterfaceOrientations ?? preferredInterfaceOrientations ?? topViewController?.supportedInterfaceOrientations ?? super.supportedInterfaceOrientations
    }

    open override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return topViewController?.interfaceOrientationForPresentation ?? interfaceOrientationForPresentation ?? topViewController?.preferredInterfaceOrientationForPresentation ?? super.preferredInterfaceOrientationForPresentation
    }

    // Setting `preferredStatusBarStyle` works.
    open override var childForStatusBarStyle: UIViewController? {
        if topViewController?.statusBarStyle != nil || statusBarStyle != nil {
            return nil
        } else {
            return topViewController
        }
    }

    // Setting `prefersStatusBarHidden` works.
    open override var childForStatusBarHidden: UIViewController? {
        if topViewController?.isStatusBarHidden != nil || isStatusBarHidden != nil {
            return nil
        } else {
            return topViewController
        }
    }

    open override var shouldAutorotate: Bool {
        return topViewController?.isAutorotateEnabled ?? isAutorotateEnabled ?? topViewController?.shouldAutorotate ?? super.shouldAutorotate
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
