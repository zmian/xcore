//
// Xcore
// Copyright © 2017 Xcore
// MIT license, see LICENSE file for details
//

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
