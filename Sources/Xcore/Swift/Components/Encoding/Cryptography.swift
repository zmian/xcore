//
// Xcore
// Copyright © 2017 Xcore
// MIT license, see LICENSE file for details
//

import Foundation
import CryptoKit

// MARK: - Data

extension Data {
    public func sha256() -> Self {
        Data(SHA256.hash(data: self))
    }

    public var bytes: [UInt8] {
        Array(self)
    }
}

// MARK: - String

extension String {
    public func sha256() -> String? {
        data(using: .utf8)?.sha256().hexEncodedString()
    }

    public var bytes: [UInt8] {
        data(using: .utf8)?.bytes ?? Array(utf8)
    }
}

// MARK: - [UInt8]

extension Array where Element == UInt8 {
    public func sha256() -> Self {
        Array(SHA256.hash(data: self))
    }
}

// MARK: - Digest

extension Digest {
    public var data: Data {
        Data(makeIterator())
    }

    public var bytes: [UInt8] {
        Array(self)
    }

    /// Returns hexadecimal representation of `self`.
    ///
    /// - Parameter options: The options to use for the encoding.
    /// - Returns: The hexadecimal encoded string.
    public func hexEncodedString(options: Data.HexEncodingOptions = []) -> String {
        data.hexEncodedString(options: options)
    }
}
