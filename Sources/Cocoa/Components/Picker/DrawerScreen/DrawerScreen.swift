//
// Xcore
// Copyright © 2019 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

// MARK: - DrawerScreenContent

public protocol DrawerScreenContent {
    var drawerContentView: UIView { get }
    func didDismiss()
    var isToolbarHidden: Bool { get }
}

extension DrawerScreenContent {
    public func didDismiss() {}
    public var isToolbarHidden: Bool {
        true
    }
}

extension UIView: DrawerScreenContent {
    public var drawerContentView: UIView {
        self
    }
}

// MARK: - DrawerScreen

final public class DrawerScreen: NSObject {
    public typealias Content = DrawerScreenContent
    private static let shared = DrawerScreen()
    private var drawerCaller: Any?

    private var shownConstraint: NSLayoutConstraint?
    private var hiddenConstraint: NSLayoutConstraint?
    private var notificationToken: NSObjectProtocol?
    private var presentedContent: Content?
    private let hud = HUD().apply {
        $0.windowLabel = "DrawerScreen Window"
        $0.preferredStatusBarStyle = .inherit
        $0.backgroundColor = appearance().overlayColor
        $0.duration = .init(.fast)
    }

    private lazy var toolbar = Toolbar().apply {
        $0.height = Self.appearance().toolbarHeight
        $0.dismissButton.action { [weak self] _ in
            self?.dismiss()
        }
    }

    private let modalView = BlurView().apply {
        let corners = appearance().corners
        $0.roundCorners(corners.mask, radius: corners.radius)
        $0.blurOpacity = appearance().blurOpacity
    }

    public override init() {
        super.init()
        hud.add(modalView)
        modalView.anchor.make {
            $0.horizontally.equalToSuperview()
            hiddenConstraint = $0.top.equalTo(hud.view.anchor.bottom).constraints.first
            shownConstraint = $0.bottom.equalToSuperview().constraints.first
        }
        shownConstraint?.deactivate()

        notificationToken = NotificationCenter.on.applicationDidEnterBackground { [weak self] in
            self?.dismiss()
        }

        hud.view.addGestureRecognizer(UITapGestureRecognizer().apply {
            $0.delegate = self
            $0.addAction { [weak self] _ in
                self?.dismiss()
            }
        })

        setupToolbar()
    }

    private func setupToolbar() {
        modalView.addSubview(toolbar)
        toolbar.anchor.make {
            $0.top.equalToSuperview()
            $0.horizontally.equalToSuperview()
        }
    }

    deinit {
        NotificationCenter.remove(notificationToken)
    }

    func present(_ content: Content) {
        toolbar.isHidden = content.isToolbarHidden
        presentedContent = content
        let view = content.drawerContentView
        modalView.addSubview(view)
        view.anchor.make {
            let inset = content.isToolbarHidden ? 0 : toolbar.intrinsicContentSize.height
            $0.edges.equalToSuperviewSafeArea().inset(UIEdgeInsets(top: inset))
        }

        // Presentation
        hud.view.layoutSubviews()
        hud.show()
        shownConstraint?.activate()
        hiddenConstraint?.deactivate()
        UIView.animate(withDuration: .fast) {
            self.hud.view.layoutSubviews()
        }
    }

    func setCaller(caller: Any?) {
        drawerCaller = caller
    }

    func dismiss(_ callback: (() -> Void)? = nil) {
        guard let presentedContent = presentedContent else {
            callback?()
            return
        }
        shownConstraint?.deactivate()
        hiddenConstraint?.activate()

        UIView.animate(withDuration: .fast, animations: {
            self.hud.view.layoutSubviews()
        }, completion: { _ in
            self.hud.hide { [weak self] in
                presentedContent.drawerContentView.removeFromSuperview()
                presentedContent.didDismiss()
                self?.presentedContent = nil
                UIAccessibility.post(notification: .layoutChanged, argument: self?.drawerCaller)
                callback?()
            }
        })
    }
}

// MARK: - UIGestureRecognizerDelegate

extension DrawerScreen: UIGestureRecognizerDelegate {
    // Prevents dismiss gesture to be detected inside the modal view, conflicts with TableView/CollectionView tap gestures
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        let location = touch.location(in: modalView)
        return !modalView.point(inside: location, with: nil)
    }
}

// MARK: - Public API

extension DrawerScreen {
    public static func present(_ content: Content, caller: Any? = nil) {
        shared.dismiss {
            shared.setCaller(caller: caller)
            shared.present(content)
        }
    }

    public static func dismiss(caller: Any? = nil) {
        shared.setCaller(caller: caller)
        shared.dismiss()
    }
}

// MARK: - Appearance

extension DrawerScreen {
    /// This configuration exists to allow some of the properties to be configured
    /// to match app's appearance style. The `UIAppearance` protocol doesn't work
    /// when the stored properites are set using associated object.
    ///
    /// **Usage:**
    ///
    /// ```swift
    /// DrawerScreen.appearance().overlayColor = UIColor.black.alpha(0.8)
    /// ```
    final public class Appearance: Appliable {
        fileprivate static var shared = Appearance()
        public var overlayColor = UIColor.black.alpha(0.3)

        /// A property to determine opacity for the blur effect. Use this property to
        /// soften the blur effect if needed.
        ///
        /// The default value is `0.3`.
        public var blurOpacity: CGFloat = 0.3

        /// The default value is `.top, 11`.
        public var corners: (mask: CACornerMask, radius: CGFloat) = (.top, 11)

        /// The default value is `AppConstants.uiControlsHeight`.
        public var toolbarHeight: CGFloat = AppConstants.uiControlsHeight
    }

    public static func appearance() -> Appearance {
        .shared
    }
}
