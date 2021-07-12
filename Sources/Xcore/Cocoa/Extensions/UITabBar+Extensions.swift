//
// Xcore
// Copyright © 2014 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

extension UITabBar {
    private enum AssociatedKey {
        static var isTransparent = "isTransparent"
        static var borderColor = "borderColor"
        static var borderWidth = "borderWidth"
    }

    open var isTransparent: Bool {
        get { associatedObject(&AssociatedKey.isTransparent, default: false) }
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
        get { value(forKey: "_hidesShadow") as? Bool ?? false }
        set { setValue(newValue, forKey: "_hidesShadow") }
    }

    @objc open override dynamic var borderWidth: CGFloat {
        get { associatedObject(&AssociatedKey.borderWidth, default: 0) }
        set {
            setAssociatedObject(&AssociatedKey.borderWidth, value: newValue)
            topBorderView.constraint(forAttribute: .height)?.constant = newValue
        }
    }

    @objc open override dynamic var borderColor: UIColor {
        get { associatedObject(&AssociatedKey.borderColor, default: layer.borderColor?.uiColor ?? .black) }
        set {
            setAssociatedObject(&AssociatedKey.borderColor, value: newValue)
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
        clipsToBounds = true
        addBorder(edges: .top, color: color, thickness: thickness)
    }
}
