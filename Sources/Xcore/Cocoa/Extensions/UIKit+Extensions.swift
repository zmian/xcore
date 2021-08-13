//
// Xcore
// Copyright © 2014 Xcore
// MIT license, see LICENSE file for details
//

import UIKit
import ObjectiveC

extension UIDatePicker {
    @nonobjc
    open var textColor: UIColor? {
        get { value(forKey: "textColor") as? UIColor }
        set { setValue(newValue, forKey: "textColor") }
    }
}
