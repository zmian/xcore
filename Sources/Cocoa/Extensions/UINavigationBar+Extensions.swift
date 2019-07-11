//
// UINavigationBar+Extensions.swift
//
// Copyright © 2014 Xcore
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

extension UINavigationBar {
    private struct AssociatedKey {
        static var isTransparent = "isTransparent"
        static var prefersNavigationBarBackground = "prefersNavigationBarBackground"
    }

    open var isTransparent: Bool {
        get { return associatedObject(&AssociatedKey.isTransparent, default: false) }
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
        get { return associatedObject(&AssociatedKey.prefersNavigationBarBackground, default: false) }
        set { setAssociatedObject(&AssociatedKey.prefersNavigationBarBackground, value: newValue) }
    }
}

// MARK: Transparent Hit Area Accommodation

extension UINavigationBar {
    open override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        guard isTransparent, !prefersNavigationBarBackground else {
            return super.point(inside: point, with: event)
        }

        // If the bar is transparent, we want to allow the user to tap
        // on UI elements that are not directly behind the `UINavigationBar`'s
        // tappable areas, such as back button, left and right bar button items.
        // To enable such functionality we are using transparent pixel mapping.
        // However, this approach doesn't respect the hit areas of the `UINavigationBar`
        // elements. To fix this the following logic is applied:

        let relativePoint = convert(point, from: nil)

        if barButtonHitAreaRectContains(point) {
            for view in subviews where view.frame.contains(relativePoint) {
                return true
            }
        }

        // Ignore touches on transparent pixels of navigation bar
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
