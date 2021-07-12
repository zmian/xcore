//
// Xcore
// Copyright © 2017 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

public struct Shadow {
    /// The color of the layer’s shadow. Animatable.
    ///
    /// The default value of this property is an opaque black color.
    public let color: UIColor

    /// The opacity of the layer’s shadow. Animatable.
    ///
    /// The value in this property must be in the range `0.0` (transparent) to `1.0`
    /// (opaque). The default value of this property is `0.0`.
    public let opacity: CGFloat

    /// The offset (in points) of the layer’s shadow. Animatable.
    ///
    /// The default value of this property is (`0.0, -3.0`).
    public let offset: CGPoint

    /// The blur radius (in points) used to render the layer’s shadow. Animatable.
    ///
    /// You specify the radius The default value of this property is `3.0`.
    public let radius: CGFloat

    /// The shape of the layer’s shadow. Animatable.
    ///
    /// The default value of this property is `nil`, which causes the layer to use a
    /// standard shadow shape. If you specify a value for this property, the layer
    /// creates its shadow using the specified path instead of the layer’s
    /// composited alpha channel. The path you provide defines the outline of the
    /// shadow. It is filled using the non-zero winding rule and the current shadow
    /// color, opacity, and blur radius.
    ///
    /// Unlike most animatable properties, this property does not support implicit
    /// animation. However, the path object may be animated using any of the
    /// concrete subclasses of `CAPropertyAnimation`. Paths will interpolate as a
    /// linear blend of the "on-line" points; "off-line" points may be interpolated
    /// non-linearly (to preserve continuity of the curve's derivative). If the two
    /// paths have a different number of control points or segments, the results are
    /// undefined. If the path extends outside the layer bounds it will not
    /// automatically be clipped to the layer, only if the normal layer masking
    /// rules cause that.
    ///
    /// Specifying an explicit path usually improves rendering performance.
    public let path: CGPath?

    public init(
        color: UIColor = .black,
        opacity: CGFloat = 0,
        offset: CGPoint = CGPoint(x: 0, y: -3),
        radius: CGFloat = 3,
        path: CGPath? = nil
    ) {
        self.color = color
        self.opacity = opacity
        self.offset = offset
        self.radius = radius
        self.path = path
    }
}

extension UIView {
    /// Adds shadow to the receiver’s layer. The properties are animatable.
    ///
    /// - Parameter shadow: The shadow to be added.
    public func addShadow(_ shadow: Shadow) {
        layer.addShadow(shadow)
    }
}

extension CALayer {
    /// Adds shadow to the receiver. The properties are animatable.
    ///
    /// - Parameter shadow: The shadow to be added.
    public func addShadow(_ shadow: Shadow) {
        shadowColor = shadow.color.cgColor
        shadowOpacity = Float(shadow.opacity)
        shadowOffset = .init(width: shadow.offset.x, height: shadow.offset.y)
        shadowRadius = shadow.radius
        if let path = shadow.path {
            shadowPath = path
        }
    }
}
