//
// GradientImageTransform.swift
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

public struct GradientImageTransform: ImageTransform {
    private let type: CAGradientLayerType
    private let colors: [UIColor]
    private let direction: GradientDirection
    private let locations: [Double]?
    private let blendMode: CGBlendMode

    public var id: String {
        let hex = colors.map { $0.hex }.joined(separator: ",")
        let loc = locations?.map { "\($0)" }.joined(separator: ",") ?? "nil"
        return "\(transformName)-type:(\(type.rawValue))-colors:(\(hex))-direction:(\(direction))-locations:(\(loc))-blendMode:(\(blendMode.rawValue))"
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
            $0.colors = colors.map { $0.cgColor }
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
