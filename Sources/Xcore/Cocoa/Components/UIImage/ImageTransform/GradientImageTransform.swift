//
// Xcore
// Copyright © 2017 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

public struct GradientImageTransform: ImageTransform {
    private let type: CAGradientLayerType
    private let colors: [UIColor]
    private let direction: GradientDirection
    private let locations: [Double]?
    private let blendMode: CGBlendMode

    public var id: String {
        let hex = colors.map(\.hex).joined(separator: ",")
        let loc = locations?.map { "\($0)" }.joined(separator: ",") ?? "nil"
        return "\(transformName)-type:(\(type.rawValue))-colors:(\(hex))-direction:(\(direction))-locations:(\(loc))-blendMode:(\(blendMode.rawValue))"
    }

    /// Applies gradient color overlay to `self`.
    ///
    /// - Parameters:
    ///   - type: The style of gradient drawn. The default value is `.axial`.
    ///   - colors: An array of `UIColor` objects defining the color of each
    ///     gradient stop.
    ///   - direction: The direction of the gradient when drawn in the layer’s
    ///     coordinate space. The default value is `.topToBottom`.
    ///   - locations: An optional array of `Double` defining the location of each
    ///     gradient stop. The default value is `nil`.
    ///   - blendMode: The blend mode to use for gradient overlay. The default value
    ///     is `.normal`.
    /// - Returns: A new image with gradient color overlay.
    public init(
        type: CAGradientLayerType = .axial,
        colors: [UIColor],
        direction: GradientDirection = .topToBottom,
        locations: [Double]? = nil,
        blendMode: CGBlendMode = .normal
    ) {
        self.type = type
        self.colors = colors
        self.direction = direction
        self.locations = locations
        self.blendMode = blendMode
    }

    public func transform(_ image: UIImage, source: ImageRepresentable) -> UIImage {
        let rect = CGRect(image.size)

        let layer = CAGradientLayer().apply {
            $0.frame = rect
            $0.type = type
            $0.colors = colors.map(\.cgColor)
            $0.locations = locations?.map {
                NSNumber(value: $0)
            }
            ($0.startPoint, $0.endPoint) = direction.points
        }

        return UIGraphicsImageRenderer(bounds: rect).image { rendererContext in
            let context = rendererContext.cgContext
            // Move and invert canvas by scaling to account for coordinate system
            context.translateBy(x: 0, y: rect.size.height)
            context.scaleBy(x: 1, y: -1)
            context.setBlendMode(blendMode)
            context.draw(image, in: rect)
            context.clip(to: rect, mask: image.cgImage!)
            // The flip the image vertically to account for coordinate system
            let flipVertical = CGAffineTransform(a: 1, b: 0, c: 0, d: -1, tx: 0, ty: rect.height)
            context.concatenate(flipVertical)
            layer.render(in: context)
        }
    }
}
