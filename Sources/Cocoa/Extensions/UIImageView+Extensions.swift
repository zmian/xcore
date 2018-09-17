//
// UIImageView+Extensions.swift
//
// Copyright © 2014 Zeeshan Mian
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
    /// Load the specified named image on **background thread**.
    ///
    /// - Parameters:
    ///   - named:  The name of the image.
    ///   - bundle: The bundle the image file or asset catalog is located in, pass `nil` to use the `main` bundle.
    public func image(named: String, bundle: Bundle? = nil) {
        DispatchQueue.global(qos: .userInteractive).async {
            let image = UIImage(named: named, in: bundle, compatibleWith: nil)
            DispatchQueue.main.async { [weak self] in
                self?.image = image
            }
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
        let prefix = name.stringByDeletingPathExtension
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

    /// Determines how the image is rendered.
    /// The default rendering mode is `UIImageRenderingModeAutomatic`.
    ///
    /// `Int` is workaround since `@IBInspectable` doesn't support enums.
    /// ```swift
    /// Possible Values:
    ///
    /// UIImageRenderingMode.automatic      // 0
    /// UIImageRenderingMode.alwaysOriginal // 1
    /// UIImageRenderingMode.alwaysTemplate // 2
    /// ```
    @IBInspectable public var renderingMode: Int {
        get { return image?.renderingMode.rawValue ?? UIImage.RenderingMode.automatic.rawValue }
        set {
            guard let renderingMode = UIImage.RenderingMode(rawValue: newValue) else { return }
            image?.withRenderingMode(renderingMode)
        }
    }

    /// Ensures smooth scaling quality.
    public func enableSmoothScaling() {
        layer.minificationFilter = .trilinear
    }
}
