//
// Xcore
// Copyright © 2014 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

extension UIImageView {
    /// Ensures smooth scaling quality.
    public func enableSmoothScaling() {
        layer.minificationFilter = .trilinear
    }
}
