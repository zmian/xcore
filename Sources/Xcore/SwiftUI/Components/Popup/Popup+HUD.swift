//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

extension Popup {
    public final class HUD: Xcore.HUD {
        public override init() {
            super.init()
            backgroundColor = .clear
            windowLabel = "Popup Window"

            adjustWindowAttributes {
                $0.makeKey()
            }
        }
    }
}
