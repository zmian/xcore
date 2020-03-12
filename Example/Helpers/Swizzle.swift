//
// Xcore
// Copyright © 2017 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

extension UIApplication {
    open override var next: UIResponder? {
        SwizzleManager.start()
        return super.next
    }
}
