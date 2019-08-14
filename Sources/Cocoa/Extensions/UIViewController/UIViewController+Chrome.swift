//
// UIViewController+Chrome.swift
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

extension UIViewController {
    /// This configuration exists to allow some of the properties
    /// to be configured to match app's appearance style.
    /// The `UIAppearance` protocol doesn't work when the stored properites
    /// are set using associated object.
    ///
    /// **For example:**
    ///
    /// ```swift
    /// UIViewController.defaultAppearance.tintColor = .gray
    /// ```
    @objc(UIViewControllerDefaultAppearance)
    final public class DefaultAppearance: NSObject {
        /// The default value is `.app(style: .body)`
        public var font: UIFont = .app(style: .body)
        /// The default value is `.appTint`.
        public var tintColor: UIColor = .appTint
        /// The default value is `.transparent`.
        public var preferredStatusBarBackground: Chrome.Style = .transparent
        /// The default value is `.blurred`.
        public var preferredNavigationBarBackground: Chrome.Style = .blurred
        /// The default value is `false`.
        public var prefersTabBarHidden: Bool = false
        fileprivate override init() {}
    }
}

@objc extension UIViewController {
    public dynamic static let defaultAppearance = DefaultAppearance()

    private var defaultAppearance: DefaultAppearance {
        return type(of: self).defaultAppearance
    }
}

extension UIViewController {
    private struct AssociatedKey {
        static var supportedInterfaceOrientations = "supportedInterfaceOrientations"
        static var preferredInterfaceOrientationForPresentation = "preferredInterfaceOrientationForPresentation"
        static var preferredStatusBarStyle = "preferredStatusBarStyle"
        static var preferredStatusBarUpdateAnimation = "preferredStatusBarUpdateAnimation"
        static var prefersStatusBarHidden = "prefersStatusBarHidden"
        static var isTabBarHidden = "isTabBarHidden"
        static var shouldAutorotate = "shouldAutorotate"
        static var isSwipeBackGestureEnabled = "isSwipeBackGestureEnabled"
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

    /// A boolean value indicating whether the swipe gesture to peek or pop view
    /// controller is enabled.
    ///
    /// The default value is `true`.
    @objc open var isSwipeBackGestureEnabled: Bool {
        get { return associatedObject(&AssociatedKey.isSwipeBackGestureEnabled, default: true) }
        set { setAssociatedObject(&AssociatedKey.isSwipeBackGestureEnabled, value: newValue) }
    }

    /// A convenience property to set `prefersTabBarHidden` without subclassing.
    /// This is useful when you don't have access to the actual class source code and need
    /// to show/hide tab bar.
    ///
    /// The default value is `nil` which means use the `prefersTabBarHidden` value.
    ///
    /// Setting this value on an instance of `UINavigationController` sets it for all of it's view controllers.
    /// And, any of its view controllers can override this on as needed basis.
    ///
    /// ```swift
    /// let vc = UIImagePickerController()
    /// vc.isTabBarHidden = false
    /// ```
    open var isTabBarHidden: Bool? {
        get { return associatedObject(&AssociatedKey.isTabBarHidden) }
        set { setAssociatedObject(&AssociatedKey.isTabBarHidden, value: newValue) }
    }
}

@objc extension UIViewController {
    /// The default value is of property `isTabBarHidden` if it's set, otherwise, `false`.
    open var prefersTabBarHidden: Bool {
        return isTabBarHidden ?? defaultAppearance.prefersTabBarHidden
    }

    /// The default value is `false`.
    open var prefersNavigationBarHidden: Bool {
        return false
    }

    /// The default value is `false`.
    open var prefersNavigationBarFadeAnimation: Bool {
        return false
    }

    /// The default value is `.appTint`.
    open var preferredNavigationBarTintColor: UIColor {
        return defaultAppearance.tintColor
    }

    /// The default value is `.transparent`.
    open var preferredStatusBarBackground: Chrome.Style {
        if prefersStatusBarHidden {
            return .transparent
        }

        return defaultAppearance.preferredStatusBarBackground
    }

    /// The default value is `.blurred`.
    open var preferredNavigationBarBackground: Chrome.Style {
        if prefersNavigationBarHidden {
            return .transparent
        }

        return defaultAppearance.preferredNavigationBarBackground
    }

    /// Display attributes for the bar’s title text.
    ///
    /// You can specify the font, text color, text shadow color, and text shadow offset
    /// for the title in the text attributes dictionary, using the text attribute keys
    /// described in Character Attributes.
    open var preferredNavigationBarTitleAttributes: [NSAttributedString.Key: Any] {
        var attributes = UIViewController.defaultNavigationBarTextAttributes
        attributes[.foregroundColor] = preferredNavigationBarTintColor
        return attributes
    }

    /// The default value is `true`.
    open var prefersDismissButtonHiddenWhenPresentedModally: Bool {
        return true
    }

    public static var defaultNavigationBarTextAttributes: [NSAttributedString.Key: Any] {
        return [
            .font: defaultAppearance.font,
            .foregroundColor: defaultAppearance.tintColor
        ]
    }
}

// MARK: - ObstructableView

@objc extension UIViewController {
    /// A property to indicate that view controller is obstructing the screen.
    ///
    /// Such information is useful when certain actions can't be triggered,
    /// for example, in-app deep-linking routing.
    ///
    /// The default value for any `ObstructableView` conforming `UIViewController`
    /// is `true`; otherwise, `false`.
    open var isObstructive: Bool {
        if self is ObstructableView {
            return true
        }
        return false
    }
}
