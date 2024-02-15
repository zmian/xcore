//
// Xcore
// Copyright © 2017 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

public struct CompositeImageTransform: ImageTransform, ExpressibleByArrayLiteral {
    private var transforms: [ImageTransform] = []

    public init(_ transforms: [ImageTransform]) {
        self.transforms = transforms
    }

    public init(arrayLiteral elements: ImageTransform...) {
        self.transforms = elements
    }

    /// Adds a new transform at the end of the collection.
    public mutating func add(_ transform: ImageTransform) {
        transforms.append(transform)
    }

    /// Removes the given transform.
    public mutating func remove(_ transform: ImageTransform) {
        let ids = transforms.map(\.id)

        guard let index = ids.firstIndex(of: transform.id) else {
            return
        }

        transforms.remove(at: index)
    }
}

extension CompositeImageTransform {
    public var id: String {
        transforms.map(\.id).joined(separator: "_")
    }

    public func transform(_ image: UIImage, source: ImageRepresentable) -> UIImage {
        transforms.reduce(image) {
            $1.transform($0, source: source)
        }
    }
}

// MARK: - Dot Syntax Support

extension ImageTransform where Self == CompositeImageTransform {
    /// Scales an image to fit within a bounds of the given size.
    ///
    /// - Parameters:
    ///   - newSize: The size of the bounds the image must fit within.
    ///   - scalingMode: The desired scaling mode.
    ///   - tintColor: An optional tint color to apply.
    /// - Returns: A new scaled image.
    public static func scaled(
        to newSize: CGSize,
        scalingMode: ResizeImageTransform.ScalingMode = .aspectFill,
        tintColor: UIColor? = nil
    ) -> Self {
        var transformer: Self = [
            ResizeImageTransform(to: newSize, scalingMode: scalingMode)
        ]

        if let tintColor {
            transformer.add(.tintColor(tintColor))
        }

        return transformer
    }
}
