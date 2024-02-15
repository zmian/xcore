//
// Xcore
// Copyright © 2017 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

/// Creating arbitrarily-colored icons from a black-with-alpha master image.
public struct TintColorImageTransform: ImageTransform {
    private let tintColor: UIColor

    public var id: String {
        "\(transformName)-tintColor:(\(tintColor.hex))"
    }

    public init(tintColor: UIColor) {
        self.tintColor = tintColor
    }

    public func transform(_ image: UIImage, source: ImageRepresentable) -> UIImage {
        let rect = CGRect(image.size)
        return UIGraphicsImageRenderer(bounds: rect).image { rendererContext in
            let context = rendererContext.cgContext
            image.draw(in: rect)
            context.setFillColor(tintColor.cgColor)
            context.setBlendMode(.sourceAtop)
            context.fill(rect)
        }
    }
}

// MARK: - Dot Syntax Support

extension ImageTransform where Self == TintColorImageTransform {
    /// Applies tint color to the image.
    ///
    /// Ideal for creating arbitrarily-colored icons from a black-with-alpha
    /// template image.
    ///
    /// - Parameter color: The tint color to apply.
    /// - Returns: A `TintColorImageTransform` instance.
    public static func tintColor(_ color: UIColor) -> Self {
        .init(tintColor: color)
    }
}
