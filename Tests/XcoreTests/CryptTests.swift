//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import XCTest
@testable import Xcore

final class CryptTests: TestCase {
    func testObfuscate() throws {
        let secret = Crypt.generateRandomPassword()
        let message = "Hello World"

        let obfuscated = Crypt.obfuscate(message, secret: secret)
        let deobfuscate = try Crypt.deobfuscate(obfuscated, secret: secret)

        XCTAssertNotEqual(Data(message.utf8).sha256().bytes, obfuscated)
        XCTAssertEqual(message, deobfuscate)

        // Incorrect Secret
        let incorrectSecret = Crypt.generateRandomPassword()
        XCTAssertThrowsError(try Crypt.deobfuscate(obfuscated, secret: incorrectSecret))
    }

    func testEncryptDecrypt_SecretData() throws {
        let secret = Crypt.generateSecureRandom()
        let message = try XCTUnwrap("Hello World".data(using: .utf8))

        let encryptedMessage = try Crypt.encrypt(message, secret: secret)
        let decryptedMessage = try Crypt.decrypt(encryptedMessage, secret: secret)
        let decryptedMessageString = try XCTUnwrap(String(data: decryptedMessage, encoding: .utf8))

        XCTAssertEqual("Hello World", decryptedMessageString)
        XCTAssertEqual(message, decryptedMessage)
        XCTAssertNotEqual(message, encryptedMessage)

        // Incorrect Secret
        let incorrectSecret = Crypt.generateSecureRandom()
        XCTAssertThrowsError(try Crypt.decrypt(encryptedMessage, secret: incorrectSecret))
    }

    func testEncryptDecrypt_SecretString() throws {
        let secret = Crypt.generateRandomPassword()
        let message = try XCTUnwrap("Hello World".data(using: .utf8))

        let encryptedMessage = try Crypt.encrypt(message, secret: secret)
        let decryptedMessage = try Crypt.decrypt(encryptedMessage, secret: secret)
        let decryptedMessageString = try XCTUnwrap(String(data: decryptedMessage, encoding: .utf8))

        XCTAssertEqual("Hello World", decryptedMessageString)
        XCTAssertEqual(message, decryptedMessage)
        XCTAssertNotEqual(message, encryptedMessage)

        // Incorrect Secret
        let incorrectSecret = Crypt.generateRandomPassword()
        XCTAssertThrowsError(try Crypt.decrypt(encryptedMessage, secret: incorrectSecret))
    }
}
