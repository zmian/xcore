//
// Xcore
// Copyright © 2019 Xcore
// MIT license, see LICENSE file for details
//

#if canImport(UIKit)
import UIKit

/// A base class for creating a HUD (Heads-Up Display) that presents a customizable
/// fullscreen window overlay.
///
/// This class provides an empty canvas that subclasses can extend to display custom
/// UI components. The HUD is managed via a dedicated `UIWindow` instance.
///
/// **Usage**
///
/// ```swift
/// final class InAppSafariViewController: SFSafariViewController {
///     private let hud = HUD().apply {
///         $0.backgroundColor = .clear
///         $0.windowLabel = "OpenURL Window"
///         $0.adjustWindowAttributes {
///             $0.makeKey()
///         }
///     }
///
///     override func viewDidDisappear(_ animated: Bool) {
///         super.viewDidDisappear(animated)
///         hud.hide(animated: false)
///     }
///
///     func show() {
///         hud.present(self, animated: true)
///     }
/// }
///
/// let vc = InAppSafariViewController()
/// vc.show()
/// ```
@MainActor
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

    /// The background color of the HUD.
    open var backgroundColor: UIColor = .white {
        didSet {
            viewController.backgroundColor = backgroundColor
        }
    }

    /// The duration of show and hide animations.
    open var animationDuration: AnimationDuration = .default

    /// The position of the window in the z-axis.
    ///
    /// Window levels provide a relative grouping of windows along the z-axis. All
    /// windows assigned to the same window level appear in front of (or behind) all
    /// windows assigned to a different window level. The ordering of windows within
    /// a given window level is not guaranteed.
    ///
    /// By default, the window appears above all other windows (`.top`).
    open var windowLevel: UIWindow.Level {
        get { window.windowLevel }
        set { setWindowLevel(newValue, animated: false) }
    }

    /// A succinct label identifying the HUD window.
    open var windowLabel: String? {
        get { window.accessibilityLabel }
        set { window.accessibilityLabel = newValue }
    }

    public convenience init() {
        self.init(frame: nil)
    }

    public init(frame: CGRect? = nil) {
        if let frame {
            window = .init(frame: frame)
        } else if let windowScene = UIApplication.sharedOrNil?.firstWindowScene {
            window = .init(windowScene: windowScene)
        } else {
            window = .init(frame: Screen.main.bounds)
        }

        commonInit()
    }

    private func commonInit() {
        window.accessibilityLabel = "HUD"
        window.backgroundColor = .clear
        window.rootViewController = viewController
        window.accessibilityViewIsModal = true
    }

    private func setDefaultWindowLevel() {
        windowLevel = .topMost
        appearance?.adjustWindowAttributes?(window)
    }

    private lazy var adjustWindowAttributes: ((_ window: UIWindow) -> Void)? = { [weak self] _ in
        self?.setDefaultWindowLevel()
    }

    /// A closure to adjust window attributes (e.g., level or make it key) so this
    /// window is displayed appropriately.
    ///
    /// For example, you can adjust the window level so this HUD is always shown
    /// behind the passcode screen to ensure that this HUD is not shown before user
    /// is fully authorized.
    ///
    /// By default, the HUD is shown on top of the currently visible window.
    open func adjustWindowAttributes(_ callback: @escaping (_ window: UIWindow) -> Void) {
        adjustWindowAttributes = { [weak self] window in
            self?.setDefaultWindowLevel()
            callback(window)
        }
    }

    open func setWindowLevel(_ level: UIWindow.Level, animated: Bool) {
        guard animated, window.windowLevel != level else {
            window.windowLevel = level
            return
        }

        UIView.animate(withDuration: animationDuration.hide.seconds) {
            self.view.alpha = 0
        } completion: { _ in
            self.window.windowLevel = level
            self.view.alpha = 1
        }
    }

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

    open func show(delay delayDuration: Duration = .zero, animated: Bool = true, _ completion: (() -> Void)? = nil) {
        setHidden(false, delay: delayDuration, animated: animated, completion)
    }

    open func hide(delay delayDuration: Duration = .zero, animated: Bool = true, _ completion: (() -> Void)? = nil) {
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

        let duration = (hide ? animationDuration.hide : animationDuration.show).seconds

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

    private func setHidden(_ hide: Bool, delay delayDuration: Duration, animated: Bool, _ completion: (() -> Void)?) {
        guard delayDuration > .zero else {
            return setHidden(hide, animated: animated, completion)
        }

        Task {
            try await Task.sleep(for: delayDuration)
            setHidden(hide, animated: animated, completion)
        }
    }
}

// MARK: - AnimationDuration

extension HUD {
    /// A structure representing the duration for showing and hiding the HUD.
    ///
    /// This struct allows precise control over animation timings, making it
    /// configurable for different UX needs. It provides a default duration and
    /// supports both uniform and distinct durations for show and hide animations.
    ///
    /// **Usage**
    ///
    /// ```swift
    /// let duration = HUD.AnimationDuration(show: 0.3, hide: 0.2)
    /// print(duration.show) // 0.3
    /// print(duration.hide) // 0.2
    ///
    /// let instant = HUD.AnimationDuration(0)
    /// print(instant.show) // 0
    /// print(instant.hide) // 0
    ///
    /// let defaultDuration = HUD.AnimationDuration.default
    /// print(defaultDuration.show) // Uses system default timing
    /// ```
    public struct AnimationDuration: Sendable, Hashable {
        /// The duration for the HUD show animation.
        public let show: Duration

        /// The duration for the HUD hide animation.
        public let hide: Duration

        /// Initializes the duration with the same value for both show and hide
        /// animations.
        ///
        /// - Parameter duration: The duration for both animations.
        public init(_ duration: Duration) {
            self.show = duration
            self.hide = duration
        }

        /// Initializes the duration with separate values for show and hide animations.
        ///
        /// - Parameters:
        ///   - show: The duration for the show animation.
        ///   - hide: The duration for the hide animation.
        public init(show: Duration, hide: Duration) {
            self.show = show
            self.hide = hide
        }

        /// Returns the default HUD animation duration.
        ///
        /// This value is defined to ensure a smooth user experience while keeping
        /// animations responsive.
        ///
        /// - Returns: A duration instance with system-default values.
        public static var `default`: Self {
            .init(.seconds(0.25)) // Default animation duration for UIKit elements
        }
    }
}

// MARK: - ViewController

extension HUD {
    private final class ViewController: UIViewController {
        var backgroundColor: UIColor? {
            didSet {
                viewIfLoaded?.backgroundColor = backgroundColor
            }
        }

        override func viewDidLoad() {
            super.viewDidLoad()
            view.backgroundColor = backgroundColor
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
#endif
