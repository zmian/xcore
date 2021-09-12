//
// Xcore
// Copyright © 2016 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

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
}

extension DataProtocol where Self == Data {
    /// Returns hexadecimal representation of `self`.
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
    /// Returns hexadecimal representation of `self`.
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
