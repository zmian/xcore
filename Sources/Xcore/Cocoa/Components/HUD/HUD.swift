//
// Xcore
// Copyright © 2019 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

extension UIWindow.Level {
    public static var top: Self {
        let topWindow = UIApplication.sharedOrNil?.windows.max { $0.windowLevel < $1.windowLevel }
        let windowLevel = topWindow?.windowLevel ?? .normal
        let maxWinLevel = max(windowLevel, .normal)
        return maxWinLevel + 1
    }
}

/// A base class to create a HUD that sets up blank canvas that can be
/// customized by subclasses to show anything in a fullscreen window.
open class HUD: Appliable {
    public private(set) var isHidden = true
    private var isTemporarilySuppressed = false
    private let window: UIWindow
    private lazy var viewController = ViewController().apply {
        $0.backgroundColor = appearance?.backgroundColor ?? backgroundColor
    }

    public var view: UIView {
        viewController.view
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
        get { window.windowLevel }
        set { setWindowLevel(newValue, animated: false) }
    }

    /// A succinct label that identifies the HUD window.
    open var windowLabel: String? {
        get { window.accessibilityLabel }
        set { window.accessibilityLabel = newValue }
    }

    public init() {
        if let windowScene = UIApplication.sharedOrNil?.firstWindowScene {
            window = UIWindow(windowScene: windowScene)
        } else {
            window = UIWindow(frame: UIScreen.main.bounds)
        }

        commonInit()
    }

    public init(frame: CGRect) {
        window = UIWindow(frame: frame)
        commonInit()
    }

    private func commonInit() {
        window.accessibilityLabel = "HUD"
        window.backgroundColor = .clear
        window.rootViewController = viewController
        window.accessibilityViewIsModal = true
    }

    private func setDefaultWindowLevel() {
        windowLevel = .top
        appearance?.adjustWindowAttributes?(window)
    }

    private lazy var adjustWindowAttributes: ((_ window: UIWindow) -> Void)? = { [weak self] _ in
        self?.setDefaultWindowLevel()
    }

    open func setWindowLevel(_ level: UIWindow.Level, animated: Bool) {
        guard animated, window.windowLevel != level else {
            window.windowLevel = level
            return
        }

        UIView.animate(withDuration: duration.hide) {
            self.view.alpha = 0
        } completion: { _ in
            self.window.windowLevel = level
            self.view.alpha = 1
        }
    }

    /// A closure to adjust window attributes (e.g., level or make it key) so this
    /// closure is displayed appropriately.
    ///
    /// For example, you can adjust the window level so this HUD is always shown
    /// behind the passcode screen to ensure that this HUD is not shown before user
    /// is fully authorized.
    ///
    /// - Note: By default, window level is set so it appears on the top of the
    ///   currently visible window.
    open func adjustWindowAttributes(_ callback: @escaping (_ window: UIWindow) -> Void) {
        adjustWindowAttributes = { [weak self] window in
            self?.setDefaultWindowLevel()
            callback(window)
        }
    }

    private func setNeedsStatusBarAppearanceUpdate() {
        switch preferredStatusBarStyle {
            case let .style(value):
                viewController.statusBarStyle = value
            case .inherit:
                let value = UIApplication.sharedOrNil?.firstSceneKeyWindow?.topViewController?.preferredStatusBarStyle
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
    ///   on top of any other subviews.
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
    /// `viewControllerToPresent`, you can modify the presentation style
    /// dynamically.
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
    /// transition style in the `modalTransitionStyle` property of the presented
    /// view controller. For custom presentations, the view is animated onscreen
    /// using the presented view controller’s transitioning delegate. For current
    /// context presentations, the view may be animated onscreen using the current
    /// view controller’s transition style.
    ///
    /// The completion handler is called after the `viewDidAppear(_:)` method is
    /// called on the presented view controller.
    ///
    /// - Parameters:
    ///   - viewControllerToPresent: The view controller to display over the current
    ///     view controller’s content.
    ///   - flag: Pass `true` to animate the presentation; otherwise, pass `false`.
    ///   - completion: The block to execute after the presentation finishes. This
    ///     block has no return value and takes no parameters. You may specify `nil`
    ///     for this parameter.
    open func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, _ completion: (() -> Void)? = nil) {
        show(animated: false) { [weak self, unowned viewControllerToPresent] in
            self?.viewController.present(viewControllerToPresent, animated: flag, completion: completion)
        }
    }

    private func _setHidden(_ hide: Bool, animated: Bool, _ completion: (() -> Void)?) {
        guard isHidden != hide else {
            completion?()
            return
        }

        // If `hide` is `false` and `isTemporarilySuppressed` flag is `true`. Then, call
        // completion handler and return to respect `isTemporarilySuppressed` flag.
        if !hide, isTemporarilySuppressed {
            isTemporarilySuppressed = false
            completion?()
            return
        }

        let duration = hide ? self.duration.hide : self.duration.show

        isHidden = hide

        if hide {
            guard animated else {
                view.alpha = 0
                window.isHidden = true
                completion?()
                return
            }
            UIView.animate(withDuration: duration) {
                self.view.alpha = 0
            } completion: { _ in
                self.window.isHidden = true
                completion?()
            }
        } else {
            adjustWindowAttributes?(window)
            setNeedsStatusBarAppearanceUpdate()
            window.isHidden = false

            guard animated else {
                view.alpha = 1
                completion?()
                return
            }

            view.alpha = 0
            UIView.animate(withDuration: duration) {
                self.view.alpha = 1
            } completion: { _ in
                completion?()
            }
        }
    }

    private func setHidden(_ hide: Bool, animated: Bool, _ completion: (() -> Void)?) {
        guard let presentedViewController = viewController.presentedViewController else {
            return _setHidden(hide, animated: animated, completion)
        }

        presentedViewController.dismiss(animated: animated) { [weak self] in
            self?._setHidden(true, animated: false, completion)
        }
    }

    private func setHidden(_ hide: Bool, delay delayDuration: TimeInterval, animated: Bool, _ completion: (() -> Void)?) {
        guard delayDuration > 0 else {
            return setHidden(hide, animated: animated, completion)
        }

        Timer.after(delayDuration) { [weak self] in
            self?.setHidden(hide, animated: animated, completion)
        }
    }

    open func show(delay delayDuration: TimeInterval = 0, animated: Bool = true, _ completion: (() -> Void)? = nil) {
        setHidden(false, delay: delayDuration, animated: animated, completion)
    }

    open func hide(delay delayDuration: TimeInterval = 0, animated: Bool = true, _ completion: (() -> Void)? = nil) {
        setHidden(true, delay: delayDuration, animated: animated, completion)
    }

    /// Suppress next call to `show(delay:animated:_:)` method.
    ///
    /// Consider a scenario where you have a splash screen that shows up whenever
    /// app resign active state. Later on, you want to request Push Notifications
    /// permission, this will cause the splash screen to appear. However, if you
    /// call `suppressTemporarily()` on the splash screen HUD before asking for
    /// permission then splash screen is suppressed when system permission dialog
    /// appears.
    open func suppressTemporarily() {
        isTemporarilySuppressed = true
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
        public static var `default`: Self {
            .style(.default)
        }

        /// A light status bar, intended for use on dark backgrounds.
        public static var lightContent: Self {
            .style(.lightContent)
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

        public static var `default`: Self {
            .init(.default)
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
            statusBarStyle ?? .default
        }
    }
}

// MARK: - Appearance

extension HUD {
    /// This configuration exists to allow some of the properties to be configured
    /// to match app's appearance style. The `UIAppearance` protocol doesn't work
    /// when the stored properites are set using associated object.
    ///
    /// **Usage**
    ///
    /// ```swift
    /// HUD.appearance().backgroundColor = .gray
    /// LaunchScreen.View.appearance().backgroundColor = .blue
    /// ```
    public final class Appearance: Appliable {
        public var backgroundColor: UIColor = .white
        fileprivate var adjustWindowAttributes: ((_ window: UIWindow) -> Void)?

        /// A closure to adjust window attributes (e.g., level or make it key) so this
        /// HUD is displayed appropriately.
        ///
        /// For example, you can adjust the window level so this HUD is always shown
        /// behind the passcode screen to ensure that this HUD is not shown before user
        /// is fully authorized.
        ///
        /// - Note: By default, window level is set so it appears on the top of the
        ///   currently visible window.
        public func adjustWindowAttributes(_ callback: @escaping (_ window: UIWindow) -> Void) {
            adjustWindowAttributes = callback
        }
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

    private var appearance: Appearance? {
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
