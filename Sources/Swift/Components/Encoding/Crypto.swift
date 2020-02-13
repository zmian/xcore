//
// Crypto.swift
//
// Copyright © 2017 Xcore
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

import Foundation
import CommonCrypto
#if canImport(CryptoKit)
import CryptoKit
#endif

@available(iOS 13.0, *)
extension Digest {
    public var data: Data {
        Data(makeIterator())
    }

    public func hexEncodedString() -> String {
        makeIterator().map { String(format: "%02hhx", $0) }.joined()
    }
}

extension Data {
    public var md5: String {
        if #available(iOS 13.0, *) {
            return Insecure.MD5.hash(data: self).hexEncodedString()
        } else {
            let hash = withUnsafeBytes { (bytes: UnsafeRawBufferPointer) -> [UInt8] in
                var hash = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
                CC_MD5(bytes.baseAddress, CC_LONG(count), &hash)
                return hash
            }

            return hash.hexEncodedString()
        }
    }

    public var sha256: String {
        if #available(iOS 13.0, *) {
            return SHA256.hash(data: self).hexEncodedString()
        } else {
            let hash = withUnsafeBytes { (bytes: UnsafeRawBufferPointer) -> [UInt8] in
                var hash = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
                CC_SHA256(bytes.baseAddress, CC_LONG(count), &hash)
                return hash
            }

            return hash.hexEncodedString()
        }
    }
}

extension String {
    public var md5: String? {
        data(using: .utf8)?.md5
    }

    public var sha256: String? {
        data(using: .utf8)?.sha256
    }
}

extension Array where Element == UInt8 {
    func hexEncodedString() -> String {
        map { String(format: "%02hhx", $0) }.joined()
    }
}
