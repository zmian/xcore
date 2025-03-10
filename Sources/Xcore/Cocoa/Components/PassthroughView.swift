//
// Xcore
// Copyright © 2019 Xcore
// MIT license, see LICENSE file for details
//

#if canImport(UIKit)
import UIKit

class PassthroughView: UIView {
    var passthroughTouches = true

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hitView = super.hitTest(point, with: event)

        if passthroughTouches {
            return self == hitView ? nil : hitView
        } else {
            return hitView
        }
    }
}
#endif
