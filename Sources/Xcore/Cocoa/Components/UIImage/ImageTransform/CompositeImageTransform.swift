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
