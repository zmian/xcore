//
// Xcore
// Copyright © 2017 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

extension ColorizeImageTransform {
    public enum Kind {
        /// Colorize image with given tint color.
        ///
        /// This is similar to Photoshop's **Color** layer blend mode.
        ///
        /// This is perfect for non-greyscale source images, and images that have both
        /// highlights and shadows that should be preserved.
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
        "\(transformName)-color:(\(color.hex))-kind:(\(kind))"
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
    /// Colorize image with given tint color.
    ///
    /// This is similar to Photoshop's **Color** layer blend mode.
    ///
    /// This is perfect for non-greyscale source images, and images that have both
    /// highlights and shadows that should be preserved.
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
    /// - SeeAlso: http://stackoverflow.com/a/34547445
    private func colorize(_ image: UIImage, tintColor: UIColor) -> UIImage {
        let rect = CGRect(image.size)
        let cgImage = image.cgImage!

        return draw(rect) { context in
            // Draw black background - workaround to preserve color of partially transparent
            // pixels
            context.setBlendMode(.normal)
            UIColor.black.setFill()
            context.fill(rect)

            // Draw original image
            context.setBlendMode(.normal)
            context.draw(cgImage, in: rect)

            // Tint image (loosing alpha) - the luminosity of the original image is
            // preserved
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
        UIGraphicsImageRenderer(bounds: rect).image { rendererContext in
            let context = rendererContext.cgContext
            // Move and invert canvas by scaling to account for coordinate system
            context.translateBy(x: 0, y: rect.size.height)
            context.scaleBy(x: 1, y: -1)
            block(context)
        }
    }
}
