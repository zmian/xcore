//
// Xcore
// Copyright © 2017 Xcore
// MIT license, see LICENSE file for details
//

#if canImport(UIKit)
import UIKit

public struct CornerRadiusImageTransform: ImageTransform {
    private let cornerRadius: CGFloat

    public var id: String {
        "\(transformName)-cornerRadius:(\(cornerRadius))"
    }

    public init(cornerRadius: CGFloat) {
        self.cornerRadius = cornerRadius
    }

    public func transform(_ image: UIImage, source: ImageRepresentable) -> UIImage {
        let rect = CGRect(image.size)
        return UIGraphicsImageRenderer(bounds: rect).image { _ in
            UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius).addClip()
            image.draw(in: rect)
        }
    }
}

// MARK: - Dot Syntax Support

extension ImageTransform where Self == CornerRadiusImageTransform {
    /// Rounds the corners of the image.
    ///
    /// - Parameter value: The corner radius value.
    /// - Returns: A `CornerRadiusImageTransform` instance.
    public static func cornerRadius(_ value: CGFloat) -> Self {
        .init(cornerRadius: value)
    }
}
#endif
