//
// Xcore
// Copyright © 2016 Xcore
// MIT license, see LICENSE file for details
//

extension Theme {
    public static func start() {
        set(.default)

        UIButton.defaultAppearance.apply {
            $0.highlightedAnimation = .scale
        }
    }
}
