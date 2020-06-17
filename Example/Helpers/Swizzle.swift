//
// Xcore
// Copyright © 2017 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

extension UIApplication {
    static func swizzle() {
        SwizzleManager.start()
    }
}
