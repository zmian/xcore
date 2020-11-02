//
// Xcore
// Copyright © 2015 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

extension UIApplication {
    /// Swift doesn't allow marking parts of Swift framework unavailable for the App
    /// Extension target. This solution let's us overcome this limitation for now.
    ///
    /// `UIApplication.shared` is marked as unavailable for these for App Extension
    /// target.
    ///
    /// https://bugs.swift.org/browse/SR-1226 is still unresolved
    /// and cause problems. It seems that as of now, marking API as unavailable
    /// for extensions in Swift still doesn’t let you compile for App extensions.
    public static var sharedOrNil: UIApplication? {
        let sharedApplicationSelector = NSSelectorFromString("sharedApplication")

        guard UIApplication.responds(to: sharedApplicationSelector) else {
            return nil
        }

        guard let unmanagedSharedApplication = UIApplication.perform(sharedApplicationSelector) else {
            return nil
        }

        return unmanagedSharedApplication.takeUnretainedValue() as? UIApplication
    }

    /// Swift doesn't allow marking parts of Swift framework unavailable for the App
    /// Extension target. This solution let's us overcome this limitation for now.
    ///
    /// `UIApplication.shared.open(_:options:completionHandler:)"` is marked as
    /// unavailable for these for App Extension target.
    ///
    /// https://bugs.swift.org/browse/SR-1226 is still unresolved
    /// and cause problems. It seems that as of now, marking API as unavailable
    /// for extensions in Swift still doesn’t let you compile for App extensions.
    public func appExtensionSafeOpen(_ url: URL) {
        guard let application = UIApplication.sharedOrNil else {
            return
        }

        let selector = NSSelectorFromString("openURL:options:completionHandler:")

        guard let method = application.method(for: selector) else {
            Console.warn("Dynamic selector \(selector) isn't available.")
            return
        }

        typealias ClosureType = @convention(c) (UIApplication, Selector, URL, [UIApplication.OpenExternalURLOptionsKey: Any], ((Bool) -> Void)?) -> Void
        let _open: ClosureType = unsafeBitCast(method, to: ClosureType.self)
        _open(application, selector, url, [:], nil)
    }
}

extension UIApplication {
    /// A property to determine whether it's the Main App or App Extension target.
    ///
    /// - [Creating an App Extension](https://developer.apple.com/library/archive/documentation/General/Conceptual/ExtensibilityPG/ExtensionCreation.html)
    public static var isAppExtension: Bool {
        Bundle.main.bundlePath.hasSuffix(".appex")
    }
}

// MARK: - TopViewController

extension UIApplication {
    open class func topViewController(_ base: UIViewController? = UIApplication.sharedOrNil?.firstSceneKeyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(nav.visibleViewController)
        }

        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(selected)
            }
        }

        if let presented = base?.presentedViewController {
            return topViewController(presented)
        }

        return base
    }

    /// Returns the top navigation controller from top windows in this application
    /// instance.
    public var topNavigationController: UINavigationController? {
        let visibleWindows = windows.filter { !$0.isHidden }.reversed()

        for window in visibleWindows {
            let topViewController = window.topViewController

            if let topNavigationController = topViewController?.navigationController {
                return topNavigationController
            }

            // Look for child view controllers
            for childViewController in topViewController?.children ?? [] {
                if let topNavigationController = childViewController as? UINavigationController {
                    return topNavigationController
                }
            }
        }

        return nil
    }
}

// MARK: - UIWindow - TopViewController

extension UIWindow {
    /// The view controller at the top of the window's `rootViewController` stack.
    open var topViewController: UIViewController? {
        UIApplication.topViewController(rootViewController)
    }
}

extension UIApplication {
    /// Iterates through `windows` from top to bottom and returns window matching
    /// the given `keyPaths`.
    ///
    /// - Returns: Returns an optional window object based on attributes options.
    /// - Complexity: O(_n_), where _n_ is the length of the `windows` array.
    public func window(_ keyPaths: KeyPath<UIWindow, Bool>...) -> UIWindow? {
        windows.reversed().first(keyPaths)
    }

    /// Iterates through app's first currently active scene's `windows` from top to
    /// bottom and returns window matching the given `keyPaths`.
    ///
    /// - Returns: Returns an optional window object based on attributes options.
    /// - Complexity: O(_n_), where _n_ is the length of the `windows` array.
    public func sceneWindow(_ keyPaths: KeyPath<UIWindow, Bool>...) -> UIWindow? {
        firstWindowScene?
            .windows
            .lazy
            .reversed()
            .first(keyPaths)
    }

    /// Returns the app's first currently active scene's first key window.
    public var firstSceneKeyWindow: UIWindow? {
        sceneWindow(\.isKeyWindow)
    }

    /// Returns the app's first currently active window scene.
    public var firstWindowScene: UIWindowScene? {
        connectedScenes
            .lazy
            .filter { $0.activationState == .foregroundActive }
            .compactMap { $0 as? UIWindowScene }
            .first
    }
}
