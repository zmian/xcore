//
// UIImage+Extensions.swift
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

extension UIImage {
    /// A convenience init identical to `UIImage:named` but does not cache images
    /// in memory. This is great for animations to quickly discard images after use.
    ///
    /// - Parameters:
    ///   - fileName: The name of the file to construct.
    ///   - bundle: The bundle in which this file is located in. The default value is `.main`.
    public convenience init?(fileName: String, in bundle: Bundle = .main) {
        let name = fileName.stringByDeletingPathExtension
        let ext = fileName.pathExtension.isEmpty ? "png" : fileName.pathExtension

        guard let path = bundle.path(forResource: name, ofType: ext) else {
            return nil
        }

        self.init(contentsOfFile: path)
    }

    /// Creates an image from specified color and size.
    ///
    /// - Parameters:
    ///   - color: The color used to create the image.
    ///   - size: The size of the image. The default size is `50`.
    public convenience init(color: UIColor, size: CGSize = 50) {
        let rect = CGRect(size)

        let image = UIGraphicsImageRenderer(bounds: rect).image { rendererContext in
            let context = rendererContext.cgContext
            context.setFillColor(color.cgColor)
            context.fill(rect)
        }

        self.init(cgImage: image.cgImage!)
    }
}

extension UIImage {
    /// Creating arbitrarily-colored icons from a black-with-alpha master image.
    public func tintColor(_ color: UIColor) -> UIImage {
        return TintColorImageTransform(tintColor: color).transform(self)
    }

    public func alpha(_ value: CGFloat) -> UIImage {
        return AlphaImageTransform(alpha: value).transform(self)
    }

    public func cornerRadius(_ value: CGFloat) -> UIImage {
        return CornerRadiusImageTransform(cornerRadius: value).transform(self)
    }

    /// Colorize image with given color.
    ///
    /// - Parameters:
    ///   - color: The color to use when coloring.
    ///   - type: The type of colorize type method to use.
    /// - Returns: The processed `UIImage` object.
    public func colorize(_ color: UIColor, type: ColorizeType) -> UIImage {
        return ColorizeImageTransform(color: color, type: type).transform(self)
    }

    public func background(_ color: UIColor, preferredSize: CGSize, alignment: UIControl.ContentHorizontalAlignment = .center) -> UIImage? {
        return BackgroundImageTransform(color: color, preferredSize: preferredSize, alignment: alignment).transform(self)
    }
}

extension UIImage {
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
        return GradientImageTransform(
            type: type,
            colors: colors,
            direction: direction,
            locations: locations,
            blendMode: blendMode
        ).transform(self)
    }
}
