//
// HUD.swift
//
// Copyright © 2019 Xcore
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

/// A base class to create a HUD that sets up blank canvas that can be
/// customized by subclasses to show anything in a fullscreen window.
open class HUD {
    private var isEnabled = false
    private var temporaryUnavailable = false
    private let window = UIWindow(frame: UIScreen.main.bounds)
    private lazy var viewController = ViewController().apply {
        $0.backgroundColor = appearance?.backgroundColor ?? backgroundColor
    }
    var view: UIView {
        return viewController.view
    }

    /// The default value is `.white`.
    open var backgroundColor: UIColor = .white {
        didSet {
            viewController.backgroundColor = backgroundColor
        }
    }

    /// The default value is `.normal`.
    open var duration: Duration = .default

    open var windowLevel: UIWindow.Level {
        get { return window.windowLevel }
        set { window.windowLevel = newValue }
    }

    public init() {
        window.backgroundColor = .clear
        window.rootViewController = viewController
    }

    private func setDefaultWindowLevel() {
        let windowLevel = UIApplication.sharedOrNil?.windows.last?.windowLevel ?? .normal
        let maxWinLevel = max(windowLevel, .normal)
        self.windowLevel = maxWinLevel + 1
    }

    private lazy var adjustWindowAttributes: ((_ window: UIWindow) -> Void)? = { [weak self] _ in
        self?.setDefaultWindowLevel()
    }

    /// A block to adjust window attributes (e.g., level or make it key) so this HUD
    /// is displayed appropriately.
    ///
    /// For example, you can adjust the window level so this HUD is always shown
    /// behind the passcode screen to ensure that this HUD is not shown before user
    /// is fully authorized.
    ///
    /// - Note: By default, window level is set so it appears on the top of the
    /// currently visible window.
    open func adjustWindowAttributes(_ callback: @escaping (_ window: UIWindow) -> Void) {
        adjustWindowAttributes = { [weak self] window in
            self?.setDefaultWindowLevel()
            callback(window)
        }
    }

    private func setNeedsStatusBarAppearanceUpdate() {
        switch preferredStatusBarStyle {
            case .style(let value):
                viewController.statusBarStyle = value
            case .inherit:
                let value = UIApplication.sharedOrNil?.keyWindow?.topViewController?.preferredStatusBarStyle
                viewController.statusBarStyle = value ?? .default
        }
    }

    /// A property to set status bar style when HUD is displayed.
    ///
    /// The default value is `.default`.
    open var preferredStatusBarStyle: StatusBarAppearance = .default

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
    open func add(_ view: UIView) {
        self.view.addSubview(view)
    }

    /// This method creates a parent-child relationship between the hud view
    /// controller and the object in the `viewController` parameter. This
    /// relationship is necessary when embedding the child view controller’s view
    /// into the current view controller’s content. If the new child view controller
    /// is already the child of a container view controller, it is removed from that
    /// container before being added.
    ///
    /// This method is only intended to be called by an implementation of a custom
    /// container view controller. If you override this method, you must call super
    /// in your implementation.
    ///
    ///
    ///
    /// - Parameter viewController: The view controller to be added as a child.
    open func add(_ viewController: UIViewController) {
        self.viewController.addViewController(viewController, enableConstraints: true)
    }

    /// Presents a view controller modally.
    ///
    /// In a horizontally regular environment, the view controller is presented in
    /// the style specified by the `modalPresentationStyle` property. In a
    /// horizontally compact environment, the view controller is presented full
    /// screen by default. If you associate an adaptive delegate with the
    /// presentation controller associated with the object in
    /// `viewControllerToPresent`, you can modify the presentation style dynamically.
    ///
    /// The object on which you call this method may not always be the one that
    /// handles the presentation. Each presentation style has different rules
    /// governing its behavior. For example, a full-screen presentation must be made
    /// by a view controller that itself covers the entire screen. If the current
    /// view controller is unable to fulfill a request, it forwards the request up
    /// the view controller hierarchy to its nearest parent, which can then handle
    /// or forward the request.
    ///
    /// Before displaying the view controller, this method resizes the presented
    /// view controller's view based on the presentation style. For most
    /// presentation styles, the resulting view is then animated onscreen using the
    /// transition style in the `modalTransitionStyle` property of the presented view
    /// controller. For custom presentations, the view is animated onscreen using
    /// the presented view controller’s transitioning delegate. For current context
    /// presentations, the view may be animated onscreen using the current view
    /// controller’s transition style.
    ///
    /// The completion handler is called after the `viewDidAppear(_:)` method is
    /// called on the presented view controller.
    ///
    /// - Parameters:
    ///   - viewControllerToPresent: The view controller to display over the current
    ///                              view controller’s content.
    ///   - flag: Pass `true` to animate the presentation; otherwise, pass `false`.
    ///   - completion: The block to execute after the presentation finishes. This
    ///                 block has no return value and takes no parameters. You may
    ///                 specify `nil` for this parameter.
    open func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, _ completion: (() -> Void)? = nil) {
        show(animated: false) { [weak self, unowned viewControllerToPresent] in
            self?.viewController.present(viewControllerToPresent, animated: flag, completion: completion)
        }
    }

    private func internalToggle(enabled: Bool, animated: Bool, _ completion: (() -> Void)?) {
        guard isEnabled != enabled, !temporaryUnavailable else {
            temporaryUnavailable = false
            completion?()
            return
        }

        let duration = enabled ? self.duration.show : self.duration.hide

        isEnabled = enabled

        if enabled {
            adjustWindowAttributes?(window)
            setNeedsStatusBarAppearanceUpdate()
            window.isHidden = false

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

    private func toggle(enabled: Bool, animated: Bool, _ completion: (() -> Void)?) {
        guard let presentedViewController = viewController.presentedViewController else {
            return internalToggle(enabled: enabled, animated: animated, completion)
        }

        presentedViewController.dismiss(animated: animated) { [weak self] in
            self?.internalToggle(enabled: false, animated: false) {
                completion?()
            }
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

// MARK: - StatusBarAppearance

extension HUD {
    public enum StatusBarAppearance {
        /// Specifies whether HUD inherits status bar style from the presenting view
        /// controller.
        case inherit

        /// Specifies HUD status bar style.
        case style(UIStatusBarStyle)

        /// A dark status bar, intended for use on light backgrounds.
        public static var `default`: StatusBarAppearance {
            return .style(.default)
        }

        /// A light status bar, intended for use on dark backgrounds.
        public static var lightContent: StatusBarAppearance {
            return .style(.lightContent)
        }
    }
}

// MARK: - Duration

extension HUD {
    public struct Duration: ExpressibleByFloatLiteral, ExpressibleByIntegerLiteral {
        public let show: TimeInterval
        public let hide: TimeInterval

        public init(floatLiteral value: FloatLiteralType) {
            self.init(TimeInterval(value))
        }

        public init(integerLiteral value: IntegerLiteralType) {
            self.init(TimeInterval(value))
        }

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

// MARK: - ViewController

extension HUD {
    private final class ViewController: UIViewController {
        var backgroundColor: UIColor? {
            didSet {
                guard isViewLoaded else {
                    return
                }

                view.backgroundColor = backgroundColor
            }
        }

        override func viewDidLoad() {
            super.viewDidLoad()
            view.backgroundColor = backgroundColor
        }

        override var preferredStatusBarStyle: UIStatusBarStyle {
            return statusBarStyle ?? .default
        }
    }
}

// MARK: - Appearance

extension HUD {
    /// This configuration exists to allow some of the properties to be configured
    /// to match app's appearance style. The `UIAppearance` protocol doesn't work
    /// when the stored properites are set using associated object.
    ///
    /// **Usage:**
    ///
    /// ```swift
    /// HUD.appearance().backgroundColor = .gray
    /// LaunchScreen.View.appearance().backgroundColor = .blue
    /// ```
    final public class Appearance: With {
        public var backgroundColor: UIColor = .white
    }

    private static var appearanceStorage: [String: Appearance] = [:]
    public class func appearance() -> Appearance {
        let instanceName = name(of: self)

        if let proxy = appearanceStorage[instanceName] {
            return proxy
        }

        let proxy = Appearance()
        appearanceStorage[instanceName] = proxy
        return proxy
    }

    fileprivate var appearance: Appearance? {
        let instanceName = name(of: self)

        // Return the type proxy if exists.
        if let proxy = HUD.appearanceStorage[instanceName] {
            return proxy
        }

        let baseInstanceName = name(of: HUD.self)

        // Return the base type proxy if exists.
        return HUD.appearanceStorage[baseInstanceName]
    }
}
