//
// UIImageView+Extensions.swift
//
// Copyright © 2014 Xcore
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

import UIKit

extension UIImageView {
    /// Sets the given image to `self`.
    ///
    /// - Parameters:
    ///   - image:             The image to display.
    ///   - animationDuration: The total duration of the animation. If the specified value is negative or 0,
    ///                        the image is set without animation.
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

    /// Create animated images. This does not cache the images in memory.
    /// Thus, less memory consumption for one of images.
    ///
    /// - Parameters:
    ///   - name:     The name of the pattern (e.g., `"AnimationImage.png"`).
    ///   - range:    Images range (e.g., `0..<30` This will create: `"AnimationImage0.png"..."AnimationImage29.png"`).
    ///   - duration: The animation duration.
    public func createAnimatedImages(_ name: String, _ range: Range<Int>, _ duration: TimeInterval) {
        let prefix = name.deletingPathExtension
        let ext = name.pathExtension.isEmpty ? "png" : name.pathExtension

        var images: [UIImage] = []
        for i in range.lowerBound..<range.upperBound {
            if let image = UIImage(fileName: "\(prefix)\(i).\(ext)") {
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

    /// Ensures smooth scaling quality.
    public func enableSmoothScaling() {
        layer.minificationFilter = .trilinear
    }
}
