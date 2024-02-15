//
// Xcore
// Copyright © 2014 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

extension UIImage {
    /// Applies the given transform to the image.
    ///
    /// - Parameter transform: The transform to be applied.
    /// - Returns: The transformed image.
    public func applying(_ transform: ImageTransform) -> UIImage {
        transform.transform(self)
    }

    /// Processes the image using the given transform.
    ///
    /// - Parameters:
    ///   - transform: The transform to use.
    ///   - source: The original source from which the image was constructed.
    /// - Returns: The transformed image.
    func applying(_ transform: ImageTransform?, source: ImageRepresentable) -> UIImage {
        guard let transform else {
            return self
        }

        return transform.transform(self, source: source)
    }
}

extension UIImage {
    /// Creates arbitrarily-colored icons from a black-with-alpha master image.
    ///
    /// - Parameter color: The color to be applied.
    /// - Returns: The processed `UIImage` object.
    public func tintColor(_ color: UIColor) -> UIImage {
        applying(.tintColor(color))
    }

    /// Adjusts the alpha level of the image.
    ///
    /// - Parameter value: The alpha value to be applied.
    /// - Returns: The processed `UIImage` object.
    public func alpha(_ value: CGFloat) -> UIImage {
        applying(.alpha(value))
    }

    /// Rounds the corners of the image.
    ///
    /// - Parameter value: The corner radius value.
    /// - Returns: The processed `UIImage` object.
    public func cornerRadius(_ value: CGFloat) -> UIImage {
        applying(.cornerRadius(value))
    }

    /// Colorizes the image with the given color.
    ///
    /// - Parameters:
    ///   - color: The color to use when coloring.
    ///   - kind: The kind of colorize type method to use.
    /// - Returns: The processed `UIImage` object.
    public func colorize(
        _ color: UIColor,
        kind: ColorizeImageTransform.Kind
    ) -> UIImage {
        applying(.colorize(color, kind: kind))
    }

    /// Applies a background color to the image.
    ///
    /// - Parameters:
    ///   - color: The background color to apply.
    ///   - preferredSize: The preferred size of the resulting image.
    ///   - alignment: The alignment within the preferred size. The default value is `.center`.
    /// - Returns: The processed `UIImage` object.
    public func background(
        _ color: UIColor,
        preferredSize: CGSize,
        alignment: UIControl.ContentHorizontalAlignment = .center
    ) -> UIImage {
        applying(.background(color, preferredSize: preferredSize, alignment: alignment))
    }

    /// Scales an image to fit within a bounds of the given size.
    ///
    /// - Parameters:
    ///   - newSize: The size of the bounds the image must fit within.
    ///   - scalingMode: The desired scaling mode.
    ///   - tintColor: An optional tint color to apply.
    /// - Returns: A new scaled image.
    public func scaled(
        to newSize: CGSize,
        scalingMode: ResizeImageTransform.ScalingMode = .aspectFill,
        tintColor: UIColor? = nil
    ) -> UIImage {
        applying(.scaled(to: newSize, scalingMode: scalingMode, tintColor: tintColor))
    }
}
