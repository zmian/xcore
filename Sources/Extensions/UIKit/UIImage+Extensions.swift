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
    /// Creates an image from specified color and size.
    ///
    /// The default size is `50,50`.
    public convenience init(color: UIColor, size: CGSize = CGSize(width: 50, height: 50)) {
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

    /// Identical to `UIImage:named` but does not cache images in memory.
    /// This is great for animations to quickly discard images after use.
    public convenience init?(fileName: String) {
        let name = fileName.stringByDeletingPathExtension
        let ext  = fileName.pathExtension == "" ? "png" : fileName.pathExtension
        if let path = Bundle.main.path(forResource: name, ofType: ext) {
            self.init(contentsOfFile: path)
        } else {
            return nil
        }
    }
}

extension UIImage {
    /// Creating arbitrarily-colored icons from a black-with-alpha master image.
    public func tintColor(_ color: UIColor) -> UIImage {
        let image = self
        let rect = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, image.scale)
        let ctx = UIGraphicsGetCurrentContext()!
        image.draw(in: rect)
        ctx.setFillColor(color.cgColor)
        ctx.setBlendMode(.sourceAtop)
        ctx.fill(rect)
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

    public func resize(to newSize: CGSize, tintColor: UIColor? = nil, completionHandler: @escaping (_ resizedImage: UIImage) -> Void) {
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            guard let strongSelf = self else { return }
            UIGraphicsBeginImageContextWithOptions(newSize, false, 0)
            strongSelf.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))

            guard let newImage = UIGraphicsGetImageFromCurrentImageContext() else {
                return
            }

            UIGraphicsEndImageContext()
            let tintedImage: UIImage

            if let tintColor = tintColor {
                tintedImage = newImage.tintColor(tintColor)
            } else {
                tintedImage = newImage
            }

            DispatchQueue.main.async {
                completionHandler(tintedImage)
            }
        }
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
    /// - parameter tintColor: The color used to colorize `self`.
    ///
    /// - returns: Colorize image.
    public func colorize(_ tintColor: UIColor) -> UIImage {
        guard let cgImage = cgImage else { return self }

        return modifiedImage { context, rect in
            // draw black background - workaround to preserve color of partially transparent pixels
            context.setBlendMode(.normal)
            UIColor.black.setFill()
            context.fill(rect)

            // draw original image
            context.setBlendMode(.normal)
            context.draw(cgImage, in: rect)

            // tint image (loosing alpha) - the luminosity of the original image is preserved
            context.setBlendMode(.color)
            tintColor.setFill()
            context.fill(rect)

            // mask by alpha values of original image
            context.setBlendMode(.destinationIn)
            context.draw(cgImage, in: rect)
        }
    }

    /// Tint Picto to color
    ///
    /// - parameter fillColor: UIColor
    ///
    /// - returns: UIImage
    public func tintPicto(_ fillColor: UIColor) -> UIImage {
        guard let cgImage = cgImage else { return self }

        return modifiedImage { context, rect in
            // draw tint color
            context.setBlendMode(.normal)
            fillColor.setFill()
            context.fill(rect)

            // mask by alpha values of original image
            context.setBlendMode(.destinationIn)
            context.draw(cgImage, in: rect)
        }
    }

    /// Modified Image Context, apply modification on image
    private func modifiedImage(_ draw: (CGContext, CGRect) -> ()) -> UIImage {
        // using scale correctly preserves retina images
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        let context = UIGraphicsGetCurrentContext()!
        // correctly rotate image
        context.translateBy(x: 0, y: size.height)
        context.scaleBy(x: 1, y: -1)
        let rect = CGRect(origin: .zero, size: size)
        draw(context, rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}
