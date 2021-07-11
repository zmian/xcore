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

extension UIImageView {
    /// Sets the given image to `self`.
    ///
    /// - Parameters:
    ///   - image: The image to display.
    ///   - animationDuration: The total duration of the animation. If the specified
    ///     value is negative or `0`, the image is set without animation.
    func setImage(_ image: UIImage, animationDuration: TimeInterval) {
        guard animationDuration > 0 else {
            self.image = image
            return
        }

        alpha = 0
        self.image = image
        UIView.animate(withDuration: animationDuration) {
            self.alpha = 1
        }
    }
}
