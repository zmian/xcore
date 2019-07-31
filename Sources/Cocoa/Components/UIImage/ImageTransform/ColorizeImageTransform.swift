//
// ColorizeImageTransform.swift
//
// Copyright © 2017 Xcore
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

extension ColorizeImageTransform {
    public enum Kind {
        /// Colorize image with given tint color.
        ///
        /// This is similar to Photoshop's **Color** layer blend mode.
        ///
        /// This is perfect for non-greyscale source images, and images that have
        /// both highlights and shadows that should be preserved.
        ///
        /// White will stay white and black will stay black as the lightness of the
        /// image is preserved.
        case colorize
        case tintPicto
    }
}

public struct ColorizeImageTransform: ImageTransform {
    private let color: UIColor
    private let kind: Kind

    public var id: String {
        return "\(transformName)-color:(\(color.hex))-kind:(\(kind))"
    }

    public init(color: UIColor, kind: Kind) {
        self.color = color
        self.kind = kind
    }

    public func transform(_ image: UIImage, source: ImageRepresentable) -> UIImage {
        switch kind {
            case .colorize:
                return colorize(image, tintColor: color)
            case .tintPicto:
                return tintPicto(image, fillColor: color)
        }
    }
}

extension ColorizeImageTransform {
    // Credit: http://stackoverflow.com/a/34547445

    /// Colorize image with given tint color.
    ///
    /// This is similar to Photoshop's **Color** layer blend mode.
    ///
    /// This is perfect for non-greyscale source images, and images that have
    /// both highlights and shadows that should be preserved.
    ///
    /// White will stay white and black will stay black as the lightness of the
    /// image is preserved.
    ///
    /// Sample Result:
    ///
    /// <img src="http://yannickstephan.com/easyhelper/tint1.png" height="70" width="120"/>
    ///
    /// <img src="http://yannickstephan.com/easyhelper/tint2.png" height="70" width="120"/>
    ///
    /// - Parameter tintColor: The color used to colorize `self`.
    /// - Returns: A colorized image.
    private func colorize(_ image: UIImage, tintColor: UIColor) -> UIImage {
        let rect = CGRect(image.size)
        let cgImage = image.cgImage!

        return draw(rect) { context in
            // Draw black background - workaround to preserve color of partially transparent pixels
            context.setBlendMode(.normal)
            UIColor.black.setFill()
            context.fill(rect)

            // Draw original image
            context.setBlendMode(.normal)
            context.draw(cgImage, in: rect)

            // Tint image (loosing alpha) - the luminosity of the original image is preserved
            context.setBlendMode(.color)
            tintColor.setFill()
            context.fill(rect)

            // Mask by alpha values of original image
            context.setBlendMode(.destinationIn)
            context.draw(cgImage, in: rect)
        }
    }

    /// Tint Picto to color.
    ///
    /// - Parameter fillColor: The color to use to tint the image.
    /// - Returns: A new `UIImage` with tint applied.
    private func tintPicto(_ image: UIImage, fillColor: UIColor) -> UIImage {
        let rect = CGRect(image.size)
        let cgImage = image.cgImage!

        return draw(rect) { context in
            // Draw tint color
            context.setBlendMode(.normal)
            fillColor.setFill()
            context.fill(rect)

            // Mask by alpha values of original image
            context.setBlendMode(.destinationIn)
            context.draw(cgImage, in: rect)
        }
    }

    /// Modified Image Context, apply modification on image.
    private func draw(_ rect: CGRect, _ block: (CGContext) -> Void) -> UIImage {
        return UIGraphicsImageRenderer(bounds: rect).image { rendererContext in
            let context = rendererContext.cgContext
            // Move and invert canvas by scaling to account for coordinate system
            context.translateBy(x: 0, y: rect.size.height)
            context.scaleBy(x: 1, y: -1)
            block(context)
        }
    }
}
