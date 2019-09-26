//
// ImageTransform+Member.swift
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

/// A concrete wrapper for enabling implicit member expressions.
public struct MetaStaticMember<Base> {
    public let base: Base

    public init(_ base: Base) {
        self.base = base
    }
}

extension ImageTransform {
    public typealias Member = MetaStaticMember<Self>

    /// Wraps the transform into member type.
    public func wrap() -> Member {
        return Member(self)
    }
}

extension MetaStaticMember where Base: ImageTransform {
    /// Creating arbitrarily-colored icons from a black-with-alpha master image.
    public static func tintColor(_ color: UIColor) -> TintColorImageTransform.Member {
        return TintColorImageTransform(tintColor: color).wrap()
    }

    public static func alpha(_ value: CGFloat) -> AlphaImageTransform.Member {
        return AlphaImageTransform(alpha: value).wrap()
    }

    public static func cornerRadius(_ value: CGFloat) -> CornerRadiusImageTransform.Member {
        return CornerRadiusImageTransform(cornerRadius: value).wrap()
    }

    /// Colorize image with given color.
    ///
    /// - Parameters:
    ///   - color: The color to use when coloring.
    ///   - kind: The kind of colorize type method to use.
    /// - Returns: The processed `UIImage` object.
    public static func colorize(_ color: UIColor, kind: ColorizeImageTransform.Kind) -> ColorizeImageTransform.Member {
        return ColorizeImageTransform(color: color, kind: kind).wrap()
    }

    public static func background(_ color: UIColor, preferredSize: CGSize, alignment: UIControl.ContentHorizontalAlignment = .center) -> BackgroundImageTransform.Member {
        return BackgroundImageTransform(color: color, preferredSize: preferredSize, alignment: alignment).wrap()
    }

    /// Scales an image to fit within a bounds of the given size.
    ///
    /// - Parameters:
    ///   - newSize: The size of the bounds the image must fit within.
    ///   - scalingMode: The desired scaling mode. The default value is `.aspectFill`.
    ///   - tintColor: An optional tint color to apply. The default value is `nil`.
    ///
    /// - Returns: A new scaled image.
    public static func scaled(to newSize: CGSize, scalingMode: ResizeImageTransform.ScalingMode = .aspectFill, tintColor: UIColor? = nil) -> CompositeImageTransform.Member {
        var transformer: CompositeImageTransform = [ResizeImageTransform(to: newSize, scalingMode: scalingMode)]

        if let tintColor = tintColor {
            transformer.add(TintColorImageTransform(tintColor: tintColor))
        }

        return transformer.wrap()
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
    public static func gradient(
        type: CAGradientLayerType = .axial,
        colors: [UIColor],
        direction: GradientDirection = .topToBottom,
        locations: [Double]? = nil,
        blendMode: CGBlendMode = .normal
    ) -> GradientImageTransform.Member {
        return GradientImageTransform(
            type: type,
            colors: colors,
            direction: direction,
            locations: locations,
            blendMode: blendMode
        ).wrap()
    }
}
