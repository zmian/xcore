//
// HUD.swift
//
// Copyright © 2019 Zeeshan Mian
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

extension HUD {
    public struct Duration {
        public let show: TimeInterval
        public let hide: TimeInterval

        public init(_ duration: TimeInterval) {
            self.show = duration
            self.hide = duration
        }

        public init(show: TimeInterval, hide: TimeInterval) {
            self.show = show
            self.hide = hide
        }

        public static var `default`: Duration {
            return Duration(.normal)
        }
    }
}

extension HUD {
    private final class ViewController: UIViewController {
        override func viewDidLoad() {
            view.backgroundColor = .white
        }

        override var preferredStatusBarStyle: UIStatusBarStyle {
            return statusBarStyle ?? .default
        }
    }
}

/// A base class to create a HUD that sets up blank canvas that can be
/// customized by subclasses to show anything in a fullscreen window.
open class HUD {
    private let window = UIWindow(frame: UIScreen.main.bounds)
    private let viewController = ViewController()
    private var isEnabled = false
    private var temporaryUnavailable = false
    private var view: UIView {
        return viewController.view
    }

    /// The default value is `.white`.
    open var backgroundColor: UIColor = .white {
        didSet {
            view.backgroundColor = backgroundColor
        }
    }

    /// The default value is `.normal`.
    open var duration: Duration {
        return .default
    }

    open var windowLevel: UIWindow.Level {
        get { return window.windowLevel }
        set { window.windowLevel = newValue }
    }

    public init() {
        window.backgroundColor = .clear
        window.rootViewController = viewController
    }

    private lazy var adjustWindowLevel: (() -> Void)? = { [weak self] in
        self?.setDefaultWindowLevel()
    }

    private func setDefaultWindowLevel() {
        let windowLevel = UIApplication.sharedOrNil?.windows.last?.windowLevel ?? .normal
        let maxWinLevel = max(windowLevel, .normal)
        self.windowLevel = maxWinLevel + 1
    }

    /// A block to adjust window level so this HUD is displayed appropriately.
    ///
    /// For example, you can adjust the window level so this HUD is always shown
    /// behind the passcode screen to ensure that this HUD is not shown before user
    /// is fully authorized.
    ///
    /// - Note: By default, window level is set so it appears on the top of the
    /// currently visible window.
    open func adjustWindowLevel(_ callback: @escaping () -> Void) {
        adjustWindowLevel = { [weak self] in
            self?.setDefaultWindowLevel()
            callback()
        }
    }

    private func setNeedsStatusBarAppearanceUpdate() {
        viewController.statusBarStyle = preferredStatusBarStyle
    }

    /// A property to set statusbar style when HUD is displayed.
    ///
    /// The default value is `.default`.
    open var preferredStatusBarStyle: UIStatusBarStyle = .default

    /// Adds a view to the end of the receiver’s list of subviews.
    ///
    /// This method establishes a strong reference to view and sets its next
    /// responder to the receiver, which is its new `superview`.
    ///
    /// Views can have only one `superview`. If view already has a `superview` and
    /// that view is not the receiver, this method removes the previous `superview`
    /// before making the receiver its new `superview`.
    ///
    /// - Parameter view: The view to be added. After being added, this view appears
    ///                   on top of any other subviews.
    open func addSubview(_ view: UIView) {
        self.view.addSubview(view)
    }

    private func toggle(enabled: Bool, animated: Bool, _ completion: (() -> Void)?) {
        guard isEnabled != enabled, !temporaryUnavailable else {
            temporaryUnavailable = false
            completion?()
            return
        }

        let duration = enabled ? self.duration.show : self.duration.hide

        isEnabled = enabled
        adjustWindowLevel?()
        setNeedsStatusBarAppearanceUpdate()

        if enabled {
            window.isHidden = false
            window.makeKey()

            guard animated else {
                view.alpha = 1
                completion?()
                return
            }

            view.alpha = 0
            UIView.animate(withDuration: duration, animations: {
                self.view.alpha = 1
            }, completion: { _ in
                completion?()
            })
        } else {
            guard animated else {
                view.alpha = 0
                window.isHidden = true
                completion?()
                return
            }
            UIView.animate(withDuration: duration, animations: {
                self.view.alpha = 0
            }, completion: { _ in
                self.window.isHidden = true
                completion?()
            })
        }
    }

    private func toggle(enabled: Bool, delay delayDuration: TimeInterval, animated: Bool, _ completion: (() -> Void)?) {
        guard delayDuration > 0 else {
            return toggle(enabled: enabled, animated: animated, completion)
        }

        delay(by: delayDuration) { [weak self] in
            self?.toggle(enabled: enabled, animated: animated, completion)
        }
    }

    open func show(delay delayDuration: TimeInterval = 0, animated: Bool = true, _ completion: (() -> Void)? = nil) {
        toggle(enabled: true, delay: delayDuration, animated: animated, completion)
    }

    open func hide(delay delayDuration: TimeInterval = 0, animated: Bool = true, _ completion: (() -> Void)? = nil) {
        toggle(enabled: false, delay: delayDuration, animated: animated, completion)
    }

    open func disableOnNextCall() {
        temporaryUnavailable = true
    }
}
