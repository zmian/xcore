//
// Xcore
// Copyright © 2017 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

public protocol ImageTransform: ImageRepresentablePlugin {
    /// A unique id for the transform.
    var id: String { get }

    /// Invoked to transform the given image.
    ///
    /// - Parameters:
    ///   - image: The image to apply the transform.
    ///   - source: The original source from which the `image` was constructed.
    /// - Returns: The transformed `UIImage` object.
    func transform(_ image: UIImage, source: ImageRepresentable) -> UIImage
}

extension ImageTransform {
    public var id: String {
        transformName
    }

    var transformName: String {
        name(of: self)
    }
}

extension ImageTransform {
    /// A convenience function to automatically set source to the input image.
    public func transform(_ image: UIImage) -> UIImage {
        transform(image, source: image)
    }
}

extension ImageTransform {
    public static func ==(lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
}
