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
    /// Identical to `UIImage:named` but does not cache images in memory.
    /// This is great for animations to quickly discard images after use.
    public convenience init?(fileName: String) {
        let name = fileName.stringByDeletingPathExtension
        let ext = fileName.pathExtension.isEmpty ? "png" : fileName.pathExtension

        guard let path = Bundle.main.path(forResource: name, ofType: ext) else {
            return nil
        }

        self.init(contentsOfFile: path)
    }

    /// Creates an image from specified color and size.
    ///
    /// - Parameters:
    ///   - color: The color used to create the image.
    ///   - size: The size of the image. The default size is `CGSize(50)`.
    public convenience init(color: UIColor, size: CGSize = CGSize(50)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        if let image = UIGraphicsGetImageFromCurrentImageContext()?.cgImage {
            self.init(cgImage: image)
        } else {
            self.init()
        }
        UIGraphicsEndImageContext()
    }
}

extension UIImage {
    /// Creating arbitrarily-colored icons from a black-with-alpha master image.
    public func tintColor(_ color: UIColor) -> UIImage {
        let image = self
        let rect = CGRect(origin: .zero, size: image.size)

        UIGraphicsBeginImageContextWithOptions(rect.size, false, image.scale)
        let context = UIGraphicsGetCurrentContext()!
        image.draw(in: rect)
        context.setFillColor(color.cgColor)
        context.setBlendMode(.sourceAtop)
        context.fill(rect)
        return UIGraphicsGetImageFromCurrentImageContext()!
    }

    public func alpha(_ value: CGFloat) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(at: .zero, blendMode: .normal, alpha: value)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }

    public func cornerRadius(_ value: CGFloat) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        let rect = CGRect(origin: .zero, size: size)
        UIBezierPath(roundedRect: rect, cornerRadius: value).addClip()
        draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }

    // Credit: http://stackoverflow.com/a/34547445

    /// Colorize image with given tint color.
    ///
    /// This is similar to Photoshop's **Color** layer blend mode.
    /// This is perfect for non-greyscale source images, and images that have both highlights and shadows that should be preserved.
    /// White will stay white and black will stay black as the lightness of the image is preserved.
    ///
    /// Sample Result:
    ///
    /// <img src="http://yannickstephan.com/easyhelper/tint1.png" height="70" width="120"/>
    ///
    /// <img src="http://yannickstephan.com/easyhelper/tint2.png" height="70" width="120"/>
    ///
    /// - Parameter tintColor: The color used to colorize `self`.
    /// - Returns: A colorized image.
    public func colorize(_ tintColor: UIColor) -> UIImage {
        guard let cgImage = cgImage else { return self }

        return modifiedImage { context, rect in
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
    public func tintPicto(_ fillColor: UIColor) -> UIImage {
        guard let cgImage = cgImage else { return self }

        return modifiedImage { context, rect in
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
    private func modifiedImage(_ draw: (CGContext, CGRect) -> Void) -> UIImage {
        // Using scale correctly preserves retina images
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        let context = UIGraphicsGetCurrentContext()!
        // Correctly rotate image
        context.translateBy(x: 0, y: size.height)
        context.scaleBy(x: 1, y: -1)
        let rect = CGRect(origin: .zero, size: size)
        draw(context, rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
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
        let rect = CGRect(origin: .zero, size: size)

        let layer = CAGradientLayer().apply {
            $0.frame = rect
            $0.type = type
            $0.colors = colors.map { $0.cgColor }
            $0.locations = locations?.map {
                NSNumber(value: $0)
            }
            ($0.startPoint, $0.endPoint) = direction.points
        }

        let renderer = UIGraphicsImageRenderer(bounds: rect)

        return renderer.image { rendererContext in
            let context = rendererContext.cgContext
            // Move and invert canvas by scaling to account for coordinate system
            context.translateBy(x: 0, y: size.height)
            context.scaleBy(x: 1, y: -1)
            context.setBlendMode(blendMode)
            context.draw(cgImage!, in: rect)
            context.clip(to: rect, mask: cgImage!)
            // The flip the image vertically to account for coordinate system
            let flipVertical = CGAffineTransform(a: 1, b: 0, c: 0, d: -1, tx: 0, ty: rect.height)
            context.concatenate(flipVertical)
            layer.render(in: context)
        }
    }
}

extension UIImage {
    public func background(color: UIColor, preferredSize: CGSize, alignment: UIControl.ContentHorizontalAlignment = .center) -> UIImage? {
        let finalSize = CGSize(
            width: max(size.width, preferredSize.width),
            height: max(size.height, preferredSize.width)
        )

        var drawingPosition = CGPoint(x: 0, y: (finalSize.height - size.height) / 2)

        switch alignment {
            case .center, .fill:
                drawingPosition.x = (finalSize.width - size.width) / 2
            case .left, .leading:
                break
            case .right, .trailing:
                drawingPosition.x = finalSize.width - size.width
        }

        UIGraphicsBeginImageContextWithOptions(finalSize, false, scale)

        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }

        context.setFillColor(color.cgColor)
        context.fill(CGRect(origin: .zero, size: finalSize))
        draw(at: drawingPosition)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}
