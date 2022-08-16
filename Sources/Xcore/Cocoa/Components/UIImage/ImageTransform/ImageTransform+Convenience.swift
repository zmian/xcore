//
// Xcore
// Copyright © 2017 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

// MARK: - Convenience

extension ImageTransform where Self == TintColorImageTransform {
    /// Creating arbitrarily-colored icons from a black-with-alpha master image.
    public static func tintColor(_ color: UIColor) -> Self {
        Self(tintColor: color)
    }
}

extension ImageTransform where Self == AlphaImageTransform {
    public static func alpha(_ value: CGFloat) -> Self {
        Self(alpha: value)
    }
}

extension ImageTransform where Self == CornerRadiusImageTransform {
    public static func cornerRadius(_ value: CGFloat) -> Self {
        Self(cornerRadius: value)
    }
}

extension ImageTransform where Self == ColorizeImageTransform {
    /// Colorize image with given color.
    ///
    /// - Parameters:
    ///   - color: The color to use when coloring.
    ///   - kind: The kind of colorize type method to use.
    /// - Returns: The processed `UIImage` object.
    public static func colorize(_ color: UIColor, kind: Self.Kind) -> Self {
        Self(color: color, kind: kind)
    }
}

extension ImageTransform where Self == BackgroundImageTransform {
    public static func background(
        _ color: UIColor,
        preferredSize: CGSize,
        alignment: UIControl.ContentHorizontalAlignment = .center
    ) -> Self {
        Self(
            color: color,
            preferredSize: preferredSize,
            alignment: alignment
        )
    }
}

extension ImageTransform where Self == CompositeImageTransform {
    /// Scales an image to fit within a bounds of the given size.
    ///
    /// - Parameters:
    ///   - newSize: The size of the bounds the image must fit within.
    ///   - scalingMode: The desired scaling mode. The default value is
    ///     `.aspectFill`.
    ///   - tintColor: An optional tint color to apply. The default value is `nil`.
    /// - Returns: A new scaled image.
    public static func scaled(
        to newSize: CGSize,
        scalingMode: ResizeImageTransform.ScalingMode = .aspectFill,
        tintColor: UIColor? = nil
    ) -> Self {
        var transformer: Self = [
            ResizeImageTransform(to: newSize, scalingMode: scalingMode)
        ]

        if let tintColor = tintColor {
            transformer.add(TintColorImageTransform(tintColor: tintColor))
        }

        return transformer
    }
}
