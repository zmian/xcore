//
// Xcore
// Copyright © 2014 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

extension Data {
    /// Appends a string to `self` using the specified encoding.
    ///
    /// This method converts the given string into `Data` using the specified
    /// encoding and appends it to the existing `Data` instance. If the conversion
    /// fails (e.g., unsupported characters), the operation is skipped.
    ///
    /// **Usage**
    ///
    /// ```swift
    /// var data = Data()
    /// data.append("Hello, world!")
    /// ```
    ///
    /// - Parameters:
    ///   - string: The string to append.
    ///   - encoding:  The encoding format to use for representing the specified
    ///     string.
    ///   - allowLossyConversion: A Boolean value indicating whether lossy conversion
    ///     is allowed.
    public mutating func append(
        _ string: String,
        encoding: String.Encoding = .utf8,
        allowLossyConversion: Bool = false
    ) {
        guard let newData = string.data(
            using: encoding,
            allowLossyConversion: allowLossyConversion
        ) else {
            return
        }

        append(newData)
    }
}
