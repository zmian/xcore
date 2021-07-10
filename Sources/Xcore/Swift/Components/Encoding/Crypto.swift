//
// Xcore
// Copyright © 2017 Xcore
// MIT license, see LICENSE file for details
//

import Foundation
import CryptoKit

extension Data {
    public func sha256() -> String {
        SHA256.hash(data: self).hexEncodedString()
    }
}

extension String {
    public func sha256() -> String? {
        data(using: .utf8)?.sha256()
    }
}

extension Digest {
    public var data: Data {
        Data(makeIterator())
    }

    public func hexEncodedString() -> String {
        makeIterator().map { String(format: "%02hhx", $0) }.joined()
    }
}

extension Array where Element == UInt8 {
    func hexEncodedString() -> String {
        map { String(format: "%02hhx", $0) }.joined()
    }
}
