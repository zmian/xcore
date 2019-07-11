//
// UITabBar+Extensions.swift
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

extension UITabBar {
    private struct AssociatedKey {
        static var isTransparent = "isTransparent"
        static var borderColor = "borderColor"
        static var borderWidth = "borderWidth"
    }

    open var isTransparent: Bool {
        get { return associatedObject(&AssociatedKey.isTransparent, default: false) }
        set {
            guard newValue != isTransparent else { return }
            setAssociatedObject(&AssociatedKey.isTransparent, value: newValue)

            guard newValue else {
                backgroundImage = nil
                return
            }

            backgroundImage = UIImage()
            shadowImage = UIImage()
            isTranslucent = true
            backgroundColor = .clear
        }
    }

    open var isBorderHidden: Bool {
        get { return value(forKey: "_hidesShadow") as? Bool ?? false }
        set { setValue(newValue, forKey: "_hidesShadow") }
    }

    @objc dynamic open override var borderWidth: CGFloat {
        get { return associatedObject(&AssociatedKey.borderWidth, default: 0) }
        set {
            setAssociatedObject(&AssociatedKey.borderWidth, value: newValue)
            guard borderWidth != 0 else { return }
            topBorderView.constraint(forAttribute: .height)?.constant = newValue
        }
    }

    @objc dynamic open override var borderColor: UIColor {
        get { return associatedObject(&AssociatedKey.borderColor, default: layer.borderColor?.uiColor ?? .black) }
        set {
            setAssociatedObject(&AssociatedKey.borderColor, value: newValue)
            guard borderWidth != 0 else { return }
            topBorderView.backgroundColor = newValue
        }
    }

    private var topBorderView: UIView {
        let tag = "topBorderView".hashValue

        if let view = viewWithTag(tag) {
            return view
        }

        setBorder(color: borderColor, thickness: borderWidth)
        return viewWithTag(tag)!
    }

    private func setBorder(color: UIColor, thickness: CGFloat = 1) {
        isBorderHidden = true
        addBorder(edges: .top, color: color, thickness: thickness)
    }
}
