//
// Xcore
// Copyright © 2017 Xcore
// MIT license, see LICENSE file for details
//

#if canImport(UIKit)
import UIKit

public struct AlphaImageTransform: ImageTransform {
    private let alpha: CGFloat

    public var id: String {
        "\(transformName)-alpha:(\(alpha))"
    }

    public init(alpha: CGFloat) {
        self.alpha = alpha
    }

    public func transform(_ image: UIImage, source: ImageRepresentable) -> UIImage {
        let rect = CGRect(image.size)
        return UIGraphicsImageRenderer(bounds: rect).image { _ in
            image.draw(at: .zero, blendMode: .normal, alpha: alpha)
        }
    }
}

// MARK: - Dot Syntax Support

extension ImageTransform where Self == AlphaImageTransform {
    /// Adjusts the alpha level of the image.
    ///
    /// - Parameter value: The alpha value to apply.
    /// - Returns: An `AlphaImageTransform` instance.
    public static func alpha(_ value: CGFloat) -> Self {
        .init(alpha: value)
    }
}
#endif
