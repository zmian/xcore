//
// Xcore
// Copyright © 2014 Xcore
// MIT license, see LICENSE file for details
//

#if canImport(UIKit)
import UIKit

extension UITabBar {
    @objc open var isBorderHidden: Bool {
        get { value(forKey: "_hidesShadow") as? Bool ?? false }
        set { setValue(newValue, forKey: "_hidesShadow") }
    }
}
#endif
