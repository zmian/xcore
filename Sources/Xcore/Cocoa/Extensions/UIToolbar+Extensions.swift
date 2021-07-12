//
// Xcore
// Copyright © 2014 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

extension UIToolbar {
    private enum AssociatedKey {
        static var isTransparent = "isTransparent"
    }

    open var isTransparent: Bool {
        get { associatedObject(&AssociatedKey.isTransparent, default: false) }
        set {
            guard newValue != isTransparent else { return }
            setAssociatedObject(&AssociatedKey.isTransparent, value: newValue)

            guard newValue else {
                setBackgroundImage(nil, forToolbarPosition: .any, barMetrics: .default)
                return
            }

            setBackgroundImage(UIImage(), forToolbarPosition: .any, barMetrics: .default)
            isTranslucent = true
            backgroundColor = .clear
        }
    }
}
