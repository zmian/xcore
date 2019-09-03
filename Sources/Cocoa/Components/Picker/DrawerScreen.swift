//
// DrawerScreen.swift
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

// MARK: - DrawerScreenContent

public protocol DrawerScreenContent {
    var drawerContentView: UIView { get }
    func didDismiss()
}

extension DrawerScreenContent {
    public func didDismiss() {}
}

extension UIView: DrawerScreenContent {
    public var drawerContentView: UIView {
        return self
    }
}

// MARK: - DrawerScreen

final public class DrawerScreen: NSObject {
    public typealias Content = DrawerScreenContent

    private static let shared = DrawerScreen()

    private var notificationToken: NSObjectProtocol?
    private var presentedContent: Content?
    private let hud = HUD()

    private let modalView = BlurView().apply {
        $0.blurOpacity = 0.3
    }

    private var shownConstraint: NSLayoutConstraint?
    private var hiddenConstraint: NSLayoutConstraint?

    public override init() {
        super.init()
        hud.preferredStatusBarStyle = .inherit
        hud.backgroundColor = UIColor.black.alpha(0.1)
        hud.duration = .init(.fast)
        setupAccessibilitySupport()

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
    }

    deinit {
        NotificationCenter.remove(notificationToken)
    }

    private func setupAccessibilitySupport() {
        hud.view.accessibilityViewIsModal = true
        UIAccessibility.post(notification: .screenChanged, argument: nil)
    }

    func present(_ content: Content) {
        presentedContent = content
        let view = content.drawerContentView
        modalView.addSubview(view)
        view.anchor.make {
            $0.edges.equalToSuperviewSafeArea()
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
            self.hud.hide()
            presentedContent.drawerContentView.removeFromSuperview()
            presentedContent.didDismiss()
            self.presentedContent = nil
            callback?()
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
    public static func present(_ content: Content) {
        shared.dismiss {
            shared.present(content)
        }
    }

    public static func dismiss() {
        shared.dismiss()
    }
}
