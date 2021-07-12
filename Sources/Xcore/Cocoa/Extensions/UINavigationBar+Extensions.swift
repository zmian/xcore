//
// Xcore
// Copyright © 2014 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

extension UINavigationBar {
    private enum AssociatedKey {
        static var isTransparent = "isTransparent"
        static var prefersNavigationBarBackground = "prefersNavigationBarBackground"
    }

    open var isTransparent: Bool {
        get { associatedObject(&AssociatedKey.isTransparent, default: false) }
        set {
            guard newValue != isTransparent else { return }
            setAssociatedObject(&AssociatedKey.isTransparent, value: newValue)

            guard newValue else {
                setBackgroundImage(nil, for: .default)
                return
            }

            setBackgroundImage(UIImage(), for: .default)
            shadowImage = UIImage()
            isTranslucent = true
            backgroundColor = .clear
        }
    }

    open var prefersNavigationBarBackground: Bool {
        get { associatedObject(&AssociatedKey.prefersNavigationBarBackground, default: false) }
        set { setAssociatedObject(&AssociatedKey.prefersNavigationBarBackground, value: newValue) }
    }
}

// MARK: - Transparent Hit Area Accommodation

extension UINavigationBar {
    open override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        guard isTransparent, !prefersNavigationBarBackground else {
            return super.point(inside: point, with: event)
        }

        // If the bar is transparent, we want to allow the user to tap on UI elements
        // that are not directly behind the `UINavigationBar`'s tappable areas, such as
        // back button, left and right bar button items.
        //
        // To enable such functionality, we are using transparent pixel mapping.
        // However, this approach doesn't respect the hit areas of the `UINavigationBar`
        // elements. To fix this the following logic is applied:

        let relativePoint = convert(point, from: nil)

        if barButtonHitAreaRectContains(point) {
            for view in subviews where view.frame.contains(relativePoint) {
                return true
            }
        }

        // Ignore touches on transparent pixels of navigation bar.
        return layer.color(at: point).alpha != 0
    }

    private func barButtonHitAreaRectContains(_ point: CGPoint) -> Bool {
        if backButtonHitAreaRect.contains(point) {
            return true
        }

        if hitAreaRect(for: topItem?.rightBarButtonItems).contains(point) {
            return true
        }

        if hitAreaRect(for: topItem?.leftBarButtonItems).contains(point) {
            return true
        }

        if let titleView = topItem?.titleView, titleView.convert(titleView.bounds, to: self).contains(point) {
            return true
        }

        return false
    }

    private func hitAreaRect(for barButtonItems: [UIBarButtonItem]?) -> CGRect {
        guard let barButtonItems = barButtonItems else {
            return .zero
        }

        var finalFrame: CGRect?

        for item in barButtonItems {
            guard let itemView = item.frameView else {
                continue
            }

            let frame = itemView.convert(itemView.bounds, to: self)

            if let unionFrame = finalFrame {
                finalFrame = unionFrame.union(frame)
            } else {
                finalFrame = frame
            }
        }

        return finalFrame ?? .zero
    }

    private var backButtonHitAreaRect: CGRect {
        guard backItem?.backBarButtonItem != nil else {
            return .zero
        }

        return CGRect(x: 0, y: 0, width: 72, height: 34)
    }
}

extension UIBarButtonItem {
    fileprivate var frameView: UIView? {
        var theView = customView

        let viewSelector = NSSelectorFromString("view")

        if customView == nil, responds(to: viewSelector) {
            theView = perform(viewSelector)?.takeUnretainedValue() as? UIView
        }

        return theView
    }
}
