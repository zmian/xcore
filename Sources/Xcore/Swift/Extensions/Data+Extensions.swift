//
// Xcore
// Copyright © 2014 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

extension Data {
    /// A convenience method to append string to `Data` using specified encoding.
    ///
    /// - Parameters:
    ///   - string: The string to be added to the `Data`.
    ///   - encoding: The encoding to use for representing the specified string.
    ///   - allowLossyConversion: A boolean value to determine lossy conversion.
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
