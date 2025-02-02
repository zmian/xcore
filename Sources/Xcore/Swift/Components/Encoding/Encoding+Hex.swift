//
// Xcore
// Copyright © 2016 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

// MARK: - Hexadecimal Encoding & Decoding

extension Data {
    /// Creates a `Data` instance from a hexadecimal-encoded string.
    ///
    /// This initializer parses a string containing hexadecimal characters and converts
    /// it into binary data.
    ///
    /// **Usage**
    ///
    /// ```swift
    /// let hexString = "48656C6C6F"
    /// let data = Data(hexEncoded: hexString)
    /// print(data) // Optional(5 bytes)
    /// print(data?.hexEncodedString(options: .uppercase)) // Optional("48656C6C6F")
    /// ```
    ///
    /// - Parameter hexString: A string representing hexadecimal-encoded bytes.
    public init?(hexEncoded hexString: String) {
        let capacity = hexString.count / 2
        var data = Data(capacity: capacity)

        for i in 0..<capacity {
            let start = hexString.index(hexString.startIndex, offsetBy: i * 2)
            let end = hexString.index(start, offsetBy: 2)
            let byteString = hexString[start..<end]
            if var byte = UInt8(byteString, radix: 16) {
                data.append(&byte, count: 1)
            } else {
                return nil
            }
        }

        self = data
    }
}

// MARK: - Hex Encoding Options

extension Data {
    /// Defines options for hexadecimal encoding.
    ///
    /// These options allow customization of the output format, such as including raw
    /// formatting symbols (`<>`, spaces) and using uppercase letters.
    public struct HexEncodingOptions: OptionSet, Sendable {
        public let rawValue: Int

        /// Creates an instance with a given raw value.
        ///
        /// - Parameter rawValue: The integer value representing encoding options.
        public init(rawValue: Int) {
            self.rawValue = rawValue
        }

        /// Outputs the raw representation, including spaces and `<>` symbols.
        public static let raw = Self(rawValue: 1 << 0)

        /// Outputs hexadecimal characters in uppercase format.
        public static let uppercase = Self(rawValue: 1 << 1)
    }
}

// MARK: - Hexadecimal String Representation

extension DataProtocol where Self == Data {
    /// Returns the hexadecimal string representation of `self`.
    ///
    /// **Usage**
    ///
    /// ```swift
    /// let data = Data([0x48, 0x65, 0x6C, 0x6C, 0x6F])
    /// print(data.hexEncodedString()) // "48656c6c6f"
    ///
    /// print(data.hexEncodedString(options: .uppercase)) // "48656C6C6F"
    /// ```
    ///
    /// - Parameter options: The options to use for the encoding.
    /// - Returns: The hexadecimal encoded string.
    public func hexEncodedString(options: Data.HexEncodingOptions = []) -> String {
        if options.contains(.raw) {
            return String(format: "%@", self as CVarArg)
        }

        let format = options.contains(.uppercase) ? "%02hhX" : "%02hhx"
        return map { String(format: format, $0) }.joined()
    }
}

extension DataProtocol where Iterator: Sequence, Self: CVarArg {
    /// Returns the hexadecimal string representation of `self`.
    ///
    /// - Parameter options: The options to use for the encoding.
    /// - Returns: The hexadecimal encoded string.
    public func hexEncodedString(options: Data.HexEncodingOptions = []) -> String {
        if options.contains(.raw) {
            return String(format: "%@", self as CVarArg)
        }

        let format = options.contains(.uppercase) ? "%02hhX" : "%02hhx"
        return map { String(format: format, $0) }.joined()
    }
}
