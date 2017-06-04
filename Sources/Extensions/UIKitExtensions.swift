//
// UIKitExtensions.swift
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
import SafariServices
import ObjectiveC

/// Attempts to open the resource at the specified URL.
///
/// Requests are made using `SafariViewController` if available;
/// otherwise it uses `UIApplication:openURL`.
///
/// - parameter url:  The url to open.
/// - parameter from: A view controller that wants to open the url.
public func open(url: URL, from viewController: UIViewController) {
    let svc = SFSafariViewController(url: url)
    viewController.present(svc, animated: true, completion: nil)
}

// MARK: UIApplication Extension

extension UIApplication {
    open class func topViewController(_ base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
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
}

// MARK: UIWindow Extension

extension UIWindow {
    /// The view controller at the top of the window's `rootViewController` stack.
    open var topViewController: UIViewController? {
        return UIApplication.topViewController(rootViewController)
    }
}

// MARK: UITabBarController Extension

extension UITabBarController {
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return selectedViewController?.supportedInterfaceOrientations ?? super.supportedInterfaceOrientations
    }

    open override var shouldAutorotate: Bool {
        return selectedViewController?.shouldAutorotate ?? super.shouldAutorotate
    }
}

extension UINib {
    public convenience init?(named: String, bundle: Bundle? = nil) {
        let bundle = bundle ?? .main

        guard bundle.path(forResource: named, ofType: "nib") != nil else {
            return nil
        }

        self.init(nibName: named, bundle: bundle)
    }
}

@IBDesignable
extension UIDatePicker {
    @IBInspectable
    @nonobjc
    open var textColor: UIColor? {
        get { return value(forKey: "textColor") as? UIColor }
        set { setValue(newValue, forKey: "textColor") }
    }
}

extension UIRefreshControl {
    private struct AssociatedKey {
        static var timeoutTimer = "timeoutTimer"
    }

    private var timeoutTimer: Timer? {
        get { return objc_getAssociatedObject(self, &AssociatedKey.timeoutTimer) as? Timer }
        set { objc_setAssociatedObject(self, &AssociatedKey.timeoutTimer, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

    open func refreshingTimeout(after timeoutInterval: TimeInterval, completion: (() -> Void)? = nil) {
        timeoutTimer?.invalidate()
        timeoutTimer = Timer.schedule(delay: timeoutInterval) { [weak self] _ in
            guard let weakSelf = self else { return }
            weakSelf.endRefreshing()
            completion?()
        }
    }
}

extension IndexPath {
    public func with(_ globalSection: Int) -> IndexPath {
        return IndexPath(row: row, section: globalSection + section)
    }
}

extension UIStackView {
    open func moveArrangedSubviews(_ view: UIView, at stackIndex: Int) {
        guard arrangedSubviews.at(stackIndex) != view else { return }
        removeArrangedSubview(view)
        insertArrangedSubview(view, at: stackIndex)
    }
}
