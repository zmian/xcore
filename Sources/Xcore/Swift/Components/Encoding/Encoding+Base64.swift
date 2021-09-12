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
    public func base64Encoded(options: Data.Base64EncodingOptions = []) -> String {
        Data(utf8).base64EncodedString(options: options)
    }

    /// Returns Base64 URL representation of `self`.
    ///
    /// - Parameter options: The options to use for the encoding.
    /// - Returns: The Base-64 URL encoded string.
    public func base64UrlEncoded(options: Data.Base64EncodingOptions = []) -> String {
        base64Encoded(options: options)
            .base64ToBase64UrlEncoded()
    }

    /// Returns Base64 URL representation from Base64 `self`.
    public func base64ToBase64UrlEncoded() -> String {
        self
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "=", with: "")
    }

    /// Returns Base64 representation from Base64 URL `self`.
    public func base64UrlToBase64Encoded() -> String {
        var result = self
            .replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: "_", with: "/")

        if result.count % 4 != 0 {
            result.append(String(repeating: "=", count: 4 - result.count % 4))
        }

        return result
    }

    public func base64UrlToUInt8Array() -> [UInt8] {
        let base64 = base64UrlToBase64Encoded()
        guard let data = Data(base64Encoded: base64) else { return [] }
        return [UInt8](data)
    }
}

// MARK: - [UInt8]

extension Array where Element == UInt8 {
    /// Returns a Base-64 encoded string.
    ///
    /// - Parameter options: The options to use for the encoding.
    /// - Returns: The Base-64 encoded string.
    public func base64EncodedString(options: Data.Base64EncodingOptions = []) -> String {
        Data(self)
            .base64EncodedString(options: options)
    }

    /// Returns Base64 URL encoded string.
    ///
    /// - Parameter options: The options to use for the encoding.
    /// - Returns: The Base-64 URL encoded string.
    public func base64UrlEncodedString(options: Data.Base64EncodingOptions = []) -> String {
        base64EncodedString(options: options)
            .base64ToBase64UrlEncoded()
    }
}
