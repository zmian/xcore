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
    ///                        value is negative or `0`, the image is set without
    ///                        animation.
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

    /// Create animated images. This does not cache the images in memory. Thus, less
    /// memory consumption for one of images.
    ///
    /// - Parameters:
    ///   - name: The name of the pattern (e.g., `"AnimationImage.png"`).
    ///   - range: Images range (e.g., `0..<30` This will create: `"AnimationImage0.png"..."AnimationImage29.png"`).
    ///   - duration: The animation duration.
    public func createAnimatedImages(_ name: String, _ range: Range<Int>, _ duration: TimeInterval) {
        let prefix = name.deletingPathExtension
        let ext = name.pathExtension.isEmpty ? "png" : name.pathExtension

        var images: [UIImage] = []
        for i in range.lowerBound..<range.upperBound {
            if let image = UIImage(filename: "\(prefix)\(i).\(ext)") {
                images.append(image)
            }
        }

        animationImages = images
        animationDuration = duration
        animationRepeatCount = 1
        image = images.first
    }

    /// A convenience method to start animation with completion handler.
    ///
    /// - Parameters:
    ///   - endImage:   Image to set when the animation finishes.
    ///   - completion: The block to execute after the animation finishes.
    public func startAnimating(endImage: UIImage? = nil, completion: (() -> Void)?) {
        if endImage != nil {
            image = endImage
        }
        startAnimating()
        delay(by: animationDuration) { [weak self] in
            self?.stopAnimating()
            self?.animationImages = nil
            delay(by: 0.5) {
                completion?()
            }
        }
    }
}
