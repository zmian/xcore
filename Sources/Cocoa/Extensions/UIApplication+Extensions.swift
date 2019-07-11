//
// UIApplication+Extensions.swift
//
// Copyright © 2015 Xcore
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

extension UIApplication {
    /// Swift doesn't allow marking parts of Swift framework unavailable for the App Extension target.
    /// This solution let's us overcome this limitation for now.
    ///
    /// `UIApplication.shared` is marked as unavailable for these for App Extension target.
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
}

extension UIApplication {
    /// A property to determine whether it's the Main App or App Extension target.
    ///
    /// - [Creating an App Extension](https://developer.apple.com/library/archive/documentation/General/Conceptual/ExtensibilityPG/ExtensionCreation.html)
    public static var isAppExtension: Bool {
        return Bundle.main.bundlePath.hasSuffix(".appex")
    }
}

// MARK: TopViewController

extension UIApplication {
    open class func topViewController(_ base: UIViewController? = UIApplication.sharedOrNil?.keyWindow?.rootViewController) -> UIViewController? {
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

    /// Iterates through `windows` from top to bottom and returns the visible window.
    ///
    /// - Returns: Returns an optional window object based on visibility.
    /// - Complexity: O(_n_), where _n_ is the length of the `windows` array.
    open var visibleWindow: UIWindow? {
        return windows.reversed().first { !$0.isHidden }
    }
}

// MARK: UIWindow - TopViewController

extension UIWindow {
    /// The view controller at the top of the window's `rootViewController` stack.
    open var topViewController: UIViewController? {
        return UIApplication.topViewController(rootViewController)
    }
}
