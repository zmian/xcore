//
// Xcore
// Copyright © 2015 Xcore
// MIT license, see LICENSE file for details
//

import UIKit
import OSLog

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
            #if DEBUG
            Logger.xc.warning("Dynamic selector \(selector, privacy: .public) isn't available.")
            #endif
            return
        }

        typealias ClosureType = @convention(c) (UIApplication, Selector, URL, [UIApplication.OpenExternalURLOptionsKey: Any], ((Bool) -> Void)?) -> Void
        let _open: ClosureType = unsafeBitCast(method, to: ClosureType.self)
        _open(application, selector, url, [:], nil)
    }
}

// MARK: - TopViewController

extension UIApplication {
    public class func topViewController(_ base: UIViewController? = nil) -> UIViewController? {
        let base = base ?? UIApplication.sharedOrNil?.firstSceneKeyWindow?.rootViewController

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
        let visibleWindows = sceneWindows.filter { !$0.isHidden }.reversed()

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
    @objc open var topViewController: UIViewController? {
        UIApplication.topViewController(rootViewController)
    }
}

extension UIApplication {
    /// Returns the app's first currently active scene's first key window.
    public var firstSceneKeyWindow: UIWindow? {
        sceneWindow(\.isKeyWindow)
    }

    /// Iterates through app's first currently active scene's `windows` from top to
    /// bottom and returns window matching the given `keyPaths`.
    ///
    /// - Returns: Returns an optional window object based on attributes options.
    /// - Complexity: O(_n_), where _n_ is the length of the `windows` array.
    public func sceneWindow(_ keyPaths: KeyPath<UIWindow, Bool>...) -> UIWindow? {
        sceneWindows.first(keyPaths)
    }

    /// Returns windows associated with the app's first currently active scene.
    public var sceneWindows: [UIWindow] {
        firstWindowScene?
            .windows
            .lazy
            .reversed() ?? []
    }

    /// Returns the app's first window scene.
    public var firstWindowScene: UIWindowScene? {
        windowScenes.first
    }

    /// Returns all of the connected window scenes sorted by from active state to
    /// background state.
    public var windowScenes: [UIWindowScene] {
        connectedScenes
            .lazy
            .compactMap { $0 as? UIWindowScene }
            .sorted { $0.activationState.sortOrder < $1.activationState.sortOrder }
    }
}

// MARK: - ActivationState

extension UIScene.ActivationState: @retroactive CustomStringConvertible {
    public var description: String {
        switch self {
            case .foregroundActive: "foregroundActive"
            case .foregroundInactive: "foregroundInactive"
            case .background: "background"
            case .unattached: "unattached"
            @unknown default: "unknown"
        }
    }

    fileprivate var sortOrder: Int {
        switch self {
            case .foregroundActive: 0
            case .foregroundInactive: 1
            case .background: 2
            case .unattached: 3
            @unknown default: 4
        }
    }
}
