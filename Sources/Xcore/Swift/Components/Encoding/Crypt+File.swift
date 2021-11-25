//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

extension Crypt {
    public struct File: CustomStringConvertible {
        public let name: String
        public let bundle: Bundle

        fileprivate let code: String
        fileprivate var url: URL {
            let components = name.split(separator: ".")
            let name = String(components[0])
            let ext = String(components[1])
            // Force unwrapping is intentional. If it crashes, it's a programmer error where
            // either the file is missing or incorrect bundle is specified.
            let path = bundle.path(forResource: name, ofType: ext)!
            return URL(fileURLWithPath: path)
        }

        public init(name: String, bundle: Bundle = .main, code: String) {
            self.name = name
            self.bundle = bundle
            self.code = code
        }

        public var description: String {
            "\(name) (\(bundle.bundleIdentifier ?? "nil"))"
        }
    }
}

extension Crypt {
    /// Decrypts the content of the given file and verifies its authenticity.
    ///
    /// - Parameter file: The encrypted file.
    /// - Returns: The original plaintext data that was sealed in the box, as long
    ///   as the correct key is used and authentication succeeds. The call throws an
    ///   error if decryption or authentication fail.
    public static func decrypt(file: File) throws -> Data {
        try decrypt(contentsOf: file.url, secret: file.code)
    }
}
