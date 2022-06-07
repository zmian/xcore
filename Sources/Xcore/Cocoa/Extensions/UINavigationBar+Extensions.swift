//
// Xcore
// Copyright © 2014 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

extension UINavigationBar {
    private enum AssociatedKey {
        static var isTransparent = "isTransparent"
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
}

extension UINavigationBar {
    /// The title’s text foreground color.
    @objc open dynamic var titleForegroundColor: UIColor? {
        get { titleTextAttributes?[.foregroundColor] as? UIColor }
        set { titleTextAttributes?[.foregroundColor] = newValue }
    }
}
