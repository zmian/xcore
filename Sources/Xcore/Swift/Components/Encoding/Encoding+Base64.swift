//
// Xcore
// Copyright © 2016 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

// MARK: - String: Base64

extension String {
    /// Creates a new string instance by decoding the given Base64 string.
    ///
    /// - Parameters:
    ///   - base64Encoded: The string instance to decode.
    ///   - options: The options to use for the decoding.
    public init?(base64Encoded: String, options: Data.Base64DecodingOptions = []) {
        guard
            let decodedData = Data(base64Encoded: base64Encoded, options: options),
            let decodedString = String(data: decodedData, encoding: .utf8)
        else {
            return nil
        }

        self = decodedString
    }

    /// Returns Base64 representation of `self`.
    ///
    /// - Parameter options: The options to use for the encoding.
    /// - Returns: The Base-64 encoded string.
    public func base64Encoded(options: Data.Base64EncodingOptions = []) -> String? {
        data(using: .utf8)?.base64EncodedString(options: options)
    }
}
