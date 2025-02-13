//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

/// A UIKit window that manages a SwiftUI view hierarchy.
open class UIHostingWindow<Content: View>: UIWindow {
    private let hostingController: HostingController

    var rootView: Content {
        get { hostingController.rootView }
        set { hostingController.rootView = newValue }
    }

    /// A Boolean property indicating whether to passthrough touches that are not
    /// inside the root view.
    public var passthroughNonContentTouches = true

    /// A succinct label that identifies the window.
    open var windowLabel: String? {
        get { accessibilityLabel }
        set { accessibilityLabel = newValue }
    }

    public init(rootView: Content) {
        self.hostingController = .init(rootView: rootView)

        if let windowScene = UIApplication.sharedOrNil?.firstWindowScene {
            super.init(windowScene: windowScene)
        } else {
            super.init(frame: Screen.main.bounds)
        }

        backgroundColor = .clear
        rootViewController = hostingController
        accessibilityViewIsModal = true
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError()
    }

    open override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hitView = super.hitTest(point, with: event)

        guard passthroughNonContentTouches else {
            return hitView
        }

        guard let rootView = rootViewController?.view else {
            return nil
        }

        // iOS 18 hit testing functionality differs from iOS 17
        // - SeeAlso: https://forums.developer.apple.com/forums/thread/762292
        if #available(iOS 18, *) {
            for subview in rootView.subviews.reversed() {
                let convertedPoint = subview.convert(point, from: rootView)
                if subview.hitTest(convertedPoint, with: event) != nil {
                    return hitView
                }
            }

            return nil
        } else {
            return rootView == hitView ? nil : hitView
        }
    }

    // MARK: - Presentation

    public var preferredKey = false

    public var isPresented: Bool {
        get { !isHidden }
        set { newValue ? show() : hide() }
    }

    private func show() {
        if windowScene == nil, let scene = UIApplication.sharedOrNil?.firstWindowScene {
            windowScene = scene
        }

        isHidden = false

        if preferredKey {
            makeKey()
        }
    }

    private func hide() {
        UIView.animate(withDuration: .default) {
            self.alpha = 0
        } completion: { _ in
            self.isHidden = true
            self.windowScene = nil
            self.alpha = 1
        }
    }
}

// MARK: - ViewController

extension UIHostingWindow {
    private final class HostingController: UIHostingController<Content> {
        override func viewDidLoad() {
            super.viewDidLoad()
            view.backgroundColor = .clear
        }
    }
}
