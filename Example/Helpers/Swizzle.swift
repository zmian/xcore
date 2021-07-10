//
// Xcore
// Copyright © 2017 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

extension UIApplication {
    static func swizzle() {
        SwizzleManager.start()
    }
}
