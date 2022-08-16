//
// Xcore
// Copyright © 2014 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

extension UITabBar {
    open var isBorderHidden: Bool {
        get { value(forKey: "_hidesShadow") as? Bool ?? false }
        set { setValue(newValue, forKey: "_hidesShadow") }
    }
}
