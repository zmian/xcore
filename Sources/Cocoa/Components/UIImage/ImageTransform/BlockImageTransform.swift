//
// Xcore
// Copyright © 2017 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

public struct BlockImageTransform: ImageTransform {
    public let id: String
    private let block: (_ image: UIImage, _ source: ImageRepresentable) -> UIImage

    public init(
        id: String,
        _ transform: @escaping (_ image: UIImage, _ source: ImageRepresentable) -> UIImage
    ) {
        self.id = id
        self.block = transform
    }

    public func transform(_ image: UIImage, source: ImageRepresentable) -> UIImage {
        block(image, source)
    }
}
