//
// Xcore
// Copyright © 2020 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

extension KeyedEncodingContainer {
    public mutating func encode(
        _ value: UIImage,
        forKey key: KeyedEncodingContainer.Key,
        as format: UIImage.EncodingFormat = .png
    ) throws {
        guard let data = value.data(using: format) else {
            throw EncodingError.invalidValue(value, .init(
                codingPath: [],
                debugDescription: "Failed to convert UIImage instance to Data.")
            )
        }

        try encode(data, forKey: key)
    }
}

extension KeyedDecodingContainer {
    public func decode(
        _ type: UIImage.Type,
        forKey key: KeyedDecodingContainer.Key
    ) throws -> UIImage {
        let imageData = try decode(Data.self, forKey: key)

        guard let image = UIImage(data: imageData) else {
            throw DecodingError.dataCorruptedError(
                forKey: key,
                in: self,
                debugDescription: "Failed to create UIImage instance."
            )
        }

        return image
    }
}

extension SingleValueEncodingContainer {
    /// Encodes a single value of the given type.
    ///
    /// - Parameter value: The value to encode.
    /// - Throws: `EncodingError.invalidValue` if the given value is invalid in
    ///   the current context for this format.
    /// - Precondition: May not be called after a previous `self.encode(_:)`
    ///   call.
    public mutating func encode(
        _ value: UIImage,
        as format: UIImage.EncodingFormat = .png
    ) throws {
        guard let data = value.data(using: format) else {
            throw EncodingError.invalidValue(value, .init(
                codingPath: [],
                debugDescription: "Failed to convert UIImage instance to Data.")
            )
        }

        try encode(data)
    }
}
