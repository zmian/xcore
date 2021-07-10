//
// Xcore
// Copyright © 2016 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

// MARK: - Base64

extension String {
    /// Creates a new string instance by decoding the given Base64 string.
    ///
    /// - Parameters:
    ///   - base64Encoded: The string instance to decode.
    ///   - options: The options to use for the decoding. The default value is `[]`.
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
    /// - Parameter options: The options to use for the encoding. The default value
    ///                      is `[]`.
    /// - Returns: The Base-64 encoded string.
    public func base64Encoded(options: Data.Base64EncodingOptions = []) -> String? {
        data(using: .utf8)?.base64EncodedString(options: options)
    }
}

// MARK: - Hexadecimal

extension Data {
    public init?(hexEncoded hexString: String) {
        let capacity = hexString.count / 2
        var data = Data(capacity: capacity)
        for i in 0..<capacity {
            let j = hexString.index(hexString.startIndex, offsetBy: i * 2)
            let k = hexString.index(j, offsetBy: 2)
            let bytes = hexString[j..<k]
            if var number = UInt8(bytes, radix: 16) {
                data.append(&number, count: 1)
            } else {
                return nil
            }
        }
        self = data
    }
}

extension Data {
    public struct HexEncodingOptions: OptionSet {
        public let rawValue: Int

        public init(rawValue: Int) {
            self.rawValue = rawValue
        }

        /// Includes `spaces` and `<>` symbols.
        public static let raw = Self(rawValue: 1 << 0)
        public static let uppercase = Self(rawValue: 1 << 1)
    }

    /// Returns hexadecimal representation of `self`.
    ///
    /// - Parameter options: The options to use for the encoding. The default value
    ///                      is `[]`.
    /// - Returns: The hexadecimal encoded string.
    public func hexEncodedString(options: HexEncodingOptions = []) -> String {
        if options.contains(.raw) {
            return String(format: "%@", self as CVarArg)
        }

        let format = options.contains(.uppercase) ? "%02hhX" : "%02hhx"
        return map { String(format: format, $0) }.joined()
    }
}
