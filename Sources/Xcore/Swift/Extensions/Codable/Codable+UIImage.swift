//
// Xcore
// Copyright © 2020 Xcore
// MIT license, see LICENSE file for details
//

#if canImport(UIKit)
import UIKit

extension KeyedEncodingContainer {
    public mutating func encode(
        _ value: UIImage,
        forKey key: Key,
        format: UIImage.EncodingFormat = .png
    ) throws {
        guard let data = value.data(using: format) else {
            throw EncodingError.invalidValue(value, .init(
                codingPath: [key],
                debugDescription: "Failed to convert UIImage instance to Data."
            ))
        }

        try encode(data, forKey: key)
    }
}

extension KeyedDecodingContainer {
    public func decode(_ key: Key) throws -> UIImage {
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
        format: UIImage.EncodingFormat = .png
    ) throws {
        guard let data = value.data(using: format) else {
            throw EncodingError.invalidValue(value, .init(
                codingPath: [],
                debugDescription: "Failed to convert UIImage instance to Data."
            ))
        }

        try encode(data)
    }
}
#endif
