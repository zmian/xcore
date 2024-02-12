//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import Foundation
import CryptoKit

public enum Crypt {
    private enum Error: Swift.Error {
        case deobfuscationFailure
        case urlNotFound
    }
}

// MARK: - Decrypt

extension Crypt {
    /// Decrypts the content at the given path and verifies its authenticity.
    ///
    /// - Parameters:
    ///   - path: The path of the encrypted content.
    ///   - secret: The cryptographic key that was used to encrypt the data.
    /// - Returns: The original plaintext data that was sealed in the box, as long
    ///   as the correct key is used and authentication succeeds. The call throws an
    ///   error if decryption or authentication fail.
    public static func decrypt(contentsAt path: String?, secret: String) throws -> Data {
        try decrypt(contentsOf: path.map(URL.init(fileURLWithPath:)), secret: secret)
    }

    /// Decrypts the content at the given path and verifies its authenticity.
    ///
    /// - Parameters:
    ///   - path: The path of the encrypted content.
    ///   - secret: The cryptographic key that was used to encrypt the data.
    /// - Returns: The original plaintext data that was sealed in the box, as long
    ///   as the correct key is used and authentication succeeds. The call throws an
    ///   error if decryption or authentication fail.
    public static func decrypt(contentsAt path: String?, secret: some ContiguousBytes) throws -> Data {
        try decrypt(contentsOf: path.map(URL.init(fileURLWithPath:)), secret: secret)
    }

    /// Decrypts the content at the given url and verifies its authenticity.
    ///
    /// - Parameters:
    ///   - url: The url of the encrypted content.
    ///   - secret: The cryptographic key that was used to encrypt the data.
    /// - Returns: The original plaintext data that was sealed in the box, as long
    ///   as the correct key is used and authentication succeeds. The call throws an
    ///   error if decryption or authentication fail.
    public static func decrypt(contentsOf url: URL?, secret: String) throws -> Data {
        guard let url else {
            throw Error.urlNotFound
        }

        return try decrypt(try Data(contentsOf: url), secret: secret)
    }

    /// Decrypts the content at the given url and verifies its authenticity.
    ///
    /// - Parameters:
    ///   - url: The url of the encrypted content.
    ///   - secret: The cryptographic key that was used to encrypt the data.
    /// - Returns: The original plaintext data that was sealed in the box, as long
    ///   as the correct key is used and authentication succeeds. The call throws an
    ///   error if decryption or authentication fail.
    public static func decrypt(contentsOf url: URL?, secret: some ContiguousBytes) throws -> Data {
        guard let url else {
            throw Error.urlNotFound
        }

        return try decrypt(try Data(contentsOf: url), secret: secret)
    }

    /// Decrypts the data and verifies its authenticity.
    ///
    /// - Parameters:
    ///   - data: The encrypted data.
    ///   - secret: The cryptographic key that was used to encrypt the data.
    /// - Returns: The original plaintext data that was sealed in the box, as long
    ///   as the correct key is used and authentication succeeds. The call throws an
    ///   error if decryption or authentication fail.
    public static func decrypt(_ data: Data, secret: String) throws -> Data {
        try decrypt(data, secret: secret.sha256Data())
    }

    /// Decrypts the data and verifies its authenticity.
    ///
    /// - Parameters:
    ///   - data: The encrypted data.
    ///   - secret: The cryptographic key that was used to encrypt the data.
    /// - Returns: The original plaintext data that was sealed in the box, as long
    ///   as the correct key is used and authentication succeeds. The call throws an
    ///   error if decryption or authentication fail.
    public static func decrypt(_ data: Data, secret: some ContiguousBytes) throws -> Data {
        let key = SymmetricKey(data: secret)
        return try ChaChaPoly.open(.init(combined: data), using: key)
    }
}

// MARK: - Encrypt

extension Crypt {
    /// Secures the given plaintext content at the given path with encryption and an
    /// authentication tag.
    ///
    /// - Parameters:
    ///   - path: The path to the content to encrypt.
    ///   - secret: A cryptographic key used to encrypt the data.
    /// - Returns: The encrypted data.
    public static func encrypt(contentsAt path: String?, secret: String) throws -> Data {
        try encrypt(contentsOf: path.map(URL.init(fileURLWithPath:)), secret: secret)
    }

    /// Secures the given plaintext content at the given path with encryption and an
    /// authentication tag.
    ///
    /// - Parameters:
    ///   - path: The path to the content to encrypt.
    ///   - secret: A cryptographic key used to encrypt the data.
    /// - Returns: The encrypted data.
    public static func encrypt(contentsAt path: String?, secret: some ContiguousBytes) throws -> Data {
        try encrypt(contentsOf: path.map(URL.init(fileURLWithPath:)), secret: secret)
    }

    /// Secures the given plaintext content at the given url with encryption and an
    /// authentication tag.
    ///
    /// - Parameters:
    ///   - path: The url of the content to encrypt.
    ///   - secret: A cryptographic key used to encrypt the data.
    /// - Returns: The encrypted data.
    public static func encrypt(contentsOf url: URL?, secret: String) throws -> Data {
        guard let url else {
            throw Error.urlNotFound
        }

        return try encrypt(try Data(contentsOf: url), secret: secret)
    }

    /// Secures the given plaintext content at the given url with encryption and an
    /// authentication tag.
    ///
    /// - Parameters:
    ///   - path: The url of the content to encrypt.
    ///   - secret: A cryptographic key used to encrypt the data.
    /// - Returns: The encrypted data.
    public static func encrypt(contentsOf url: URL?, secret: some ContiguousBytes) throws -> Data {
        guard let url else {
            throw Error.urlNotFound
        }

        return try encrypt(try Data(contentsOf: url), secret: secret)
    }

    /// Secures the given plaintext data with encryption and an authentication tag.
    ///
    /// - Parameters:
    ///   - data: The data to encrypt.
    ///   - secret: A cryptographic key used to encrypt the data.
    /// - Returns: The encrypted data.
    public static func encrypt(_ data: Data, secret: String) throws -> Data {
        try encrypt(data, secret: secret.sha256Data())
    }

    /// Secures the given plaintext data with encryption and an authentication tag.
    ///
    /// - Parameters:
    ///   - data: The data to encrypt.
    ///   - secret: A cryptographic key used to encrypt the data.
    /// - Returns: The encrypted data.
    public static func encrypt(_ data: Data, secret: some ContiguousBytes) throws -> Data {
        let key = SymmetricKey(data: secret)
        return try ChaChaPoly.seal(data, using: key).combined
    }
}

// MARK: - Obfuscate

extension Crypt {
    /// Obfuscates a given string with secret.
    ///
    /// - Parameters:
    ///   - string: String to obfuscate.
    ///   - secret: Secret for obfuscation.
    /// - Returns: Obfuscated value in an array of `UInt8`.
    public static func obfuscate(_ string: String, secret: String) -> [UInt8] {
        obfuscate(string, secret: secret.sha256Data().bytes)
    }

    /// Obfuscates a given string with secret.
    ///
    /// - Parameters:
    ///   - string: String to obfuscate.
    ///   - secret: Secret for obfuscation.
    /// - Returns: Obfuscated value in an array of `UInt8`.
    public static func obfuscate(_ string: String, secret: [UInt8]) -> [UInt8] {
        zip(string.utf8, secret).map(^)
    }

    /// Obfuscates a given data with secret.
    ///
    /// - Parameters:
    ///   - data: Data to obfuscate.
    ///   - secret: Secret for obfuscation.
    /// - Returns: Obfuscated value in an array of `UInt8`.
    public static func obfuscate(_ data: [UInt8], secret: [UInt8]) -> [UInt8] {
        zip(data, secret).map(^)
    }
}

// MARK: - Deobfuscate

extension Crypt {
    /// Deobfucates a previously obfuscated value.
    ///
    /// - Parameters:
    ///   - value: Obfuscated value to deobfuscate.
    ///   - secret: The secret that was used during obfucation.
    /// - Returns: Deobfuscated value of given obfuscated value.
    public static func deobfuscate(_ value: [UInt8], secret: String) throws -> String {
        try deobfuscateString(value, secret: secret.sha256Data().bytes)
    }

    /// Deobfucates a previously obfuscated value.
    ///
    /// - Parameters:
    ///   - value: Obfuscated value to deobfuscate.
    ///   - secret: The secret that was used during obfucation.
    /// - Returns: Deobfuscated value of given obfuscated value.
    public static func deobfuscateString(_ value: [UInt8], secret: [UInt8]) throws -> String {
        let rawBytes = zip(value, secret).map(^)

        guard let value = String(bytes: rawBytes, encoding: .utf8) else {
            throw Error.deobfuscationFailure
        }

        return value
    }

    /// Deobfucates a previously obfuscated value.
    ///
    /// - Parameters:
    ///   - value: Obfuscated value to deobfuscate.
    ///   - secret: The secret that was used during obfucation.
    /// - Returns: Deobfuscated value of given obfuscated value.
    public static func deobfuscate(_ value: [UInt8], secret: [UInt8]) throws -> [UInt8] {
        zip(value, secret).map(^)
    }
}

// MARK: - Secure Random Data

extension Crypt {
    /// Generates a random symmetric cryptographic key of the given size.
    ///
    /// - Parameter size: The size of the key to generate. You can use one of the
    ///   standard sizes, like `bits256`, or you can create a key of custom length
    ///   by initializing a ``SymmetricKeySize`` instance with a non-standard value.
    /// - Returns: Returns a new random key of the given size.
    public static func generateSecureRandom(size: SymmetricKeySize = .bits256) -> Data {
        SymmetricKey(size: size).withUnsafeBytes {
            Data($0)
        }
    }

    /// Returns a randomly generated password.
    ///
    /// A password in the form `xxx-xxx-xxx-xxx`, where `x` is taken from the sets
    /// `abcdefghkmnopqrstuvwxy`, `ABCDEFGHJKLMNPQRSTUVWXYZ`, and `3456789`, with at
    /// least one character from each set being present.
    public static func generateRandomPassword() -> String {
        SecCreateSharedWebCredentialPassword()! as String
    }
}

extension String {
    fileprivate func sha256Data() -> Data {
        Data(utf8).base64EncodedData().sha256()
    }
}
