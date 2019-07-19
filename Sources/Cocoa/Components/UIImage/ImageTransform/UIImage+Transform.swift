//
// UIImage+Transform.swift
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

extension UIImage {
    public func applying(_ transform: ImageTransform) -> UIImage {
        return transform.transform(self)
    }

    public func applying<T: ImageTransform>(_ transform: T.Member) -> UIImage {
        return applying(transform.base)
    }

    /// Process the image using the given transform.
    ///
    /// - Parameters:
    ///   - source:    The original source from which the image was constructed.
    ///   - transform: The transform to use.
    /// - Returns: The transformed image.
    func applying(_ transform: ImageTransform?, source: ImageRepresentable) -> UIImage {
        guard let transform = transform else {
            return self
        }

        return transform.transform(self, source: source)
    }
}

extension UIImage {
    /// Creating arbitrarily-colored icons from a black-with-alpha master image.
    public func tintColor(_ color: UIColor) -> UIImage {
        return applying(.tintColor(color))
    }

    public func alpha(_ value: CGFloat) -> UIImage {
        return applying(.alpha(value))
    }

    public func cornerRadius(_ value: CGFloat) -> UIImage {
        return applying(.cornerRadius(value))
    }

    /// Colorize image with given color.
    ///
    /// - Parameters:
    ///   - color: The color to use when coloring.
    ///   - kind: The kind of colorize type method to use.
    /// - Returns: The processed `UIImage` object.
    public func colorize(_ color: UIColor, kind: ColorizeImageTransform.Kind) -> UIImage {
        return applying(.colorize(color, kind: kind))
    }

    public func background(_ color: UIColor, preferredSize: CGSize, alignment: UIControl.ContentHorizontalAlignment = .center) -> UIImage {
        return applying(.background(color, preferredSize: preferredSize, alignment: alignment))
    }

    /// Scales an image to fit within a bounds of the given size.
    ///
    /// - Parameters:
    ///   - newSize: The size of the bounds the image must fit within.
    ///   - scalingMode: The desired scaling mode. The default value is `.aspectFill`.
    ///   - tintColor: An optional tint color to apply. The default value is `nil`.
    ///
    /// - Returns: A new scaled image.
    public func scaled(to newSize: CGSize, scalingMode: ResizeImageTransform.ScalingMode = .aspectFill, tintColor: UIColor? = nil) -> UIImage {
        return applying(.scaled(to: newSize, scalingMode: scalingMode, tintColor: tintColor))
    }

    /// Applies gradient color overlay to `self`.
    ///
    /// - Parameters:
    ///   - type: The style of gradient drawn. The default value is `.axial`.
    ///   - colors: An array of `UIColor` objects defining the color of each gradient stop.
    ///   - direction: The direction of the gradient when drawn in the layer’s coordinate space.
    ///                The default value is `.topToBottom`.
    ///   - locations: An optional array of `Double` defining the location of each gradient stop.
    ///                The default value is `nil`.
    ///   - blendMode: The blend mode to use for gradient overlay. The default value is `.normal`.
    /// - Returns: A new image with gradient color overlay.
    public func gradient(
        type: CAGradientLayerType = .axial,
        colors: [UIColor],
        direction: GradientDirection = .topToBottom,
        locations: [Double]? = nil,
        blendMode: CGBlendMode = .normal
    ) -> UIImage {
        return applying(.gradient(
            type: type,
            colors: colors,
            direction: direction,
            locations: locations,
            blendMode: blendMode
        ))
    }
}
