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
            super.init(frame: UIScreen.main.bounds)
        }

        backgroundColor = .clear
        rootViewController = hostingController
        accessibilityViewIsModal = true
        if #unavailable(iOS 14.5) {
            // iOS 14.4 and lower have a bug where UIHostingController doesn't
            // call the viewDidLoad() method where the view's background color
            // is set. Hence this little snippet to set it explicitly from here.
            rootViewController?.view.backgroundColor = .clear
        }
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError()
    }

    open override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hitView = super.hitTest(point, with: event)

        if passthroughNonContentTouches {
            return rootViewController?.viewIfLoaded == hitView ? nil : hitView
        } else {
            return hitView
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
        isHidden = true
        windowScene = nil
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
