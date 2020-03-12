//
// Crypto.swift
// Copyright © 2017 Xcore
// MIT license, see LICENSE file for details
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
    public func md5() -> String {
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

    public func sha256() -> String {
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
    public func md5() -> String? {
        data(using: .utf8)?.md5()
    }

    public func sha256() -> String? {
        data(using: .utf8)?.sha256()
    }
}

extension Array where Element == UInt8 {
    func hexEncodedString() -> String {
        map { String(format: "%02hhx", $0) }.joined()
    }
}
