//
// Xcore
// Copyright © 2019 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

// MARK: - UIView

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

// MARK: - UIWindow

class PassthroughWindow: UIWindow {
    var passthroughTouches = true

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hitView = super.hitTest(point, with: event)

        if passthroughTouches {
            return rootViewController?.viewIfLoaded == hitView ? nil : hitView
        } else {
            return hitView
        }
    }
}
