//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import Testing
import Foundation
@testable import Xcore

struct CryptTests {
    @Test
    func obfuscateString() throws {
        let secret = Crypt.generateRandomPassword()
        let message = "Hello World"

        let obfuscated = Crypt.obfuscate(message, secret: secret)
        let deobfuscate = try Crypt.deobfuscate(obfuscated, secret: secret)

        #expect(Data(message.utf8).sha256().bytes != obfuscated)
        #expect(message == deobfuscate)

        // Incorrect Secret
        let incorrectSecret = Crypt.generateRandomPassword()
        #expect(throws: Error.self) {
            try Crypt.deobfuscate(obfuscated, secret: incorrectSecret)
        }
    }

    @Test
    func obfuscateData() throws {
        let secret = Crypt.generateSecureRandom().bytes
        let message = Crypt.generateSecureRandom().bytes

        let obfuscated = Crypt.obfuscate(message, secret: secret)
        let deobfuscate = try Crypt.deobfuscate(obfuscated, secret: secret)

        #expect(deobfuscate == message)
    }

    @Test
    func encryptDecrypt_SecretData() throws {
        let secret = Crypt.generateSecureRandom()
        let message = Data("Hello World".utf8)

        let encryptedMessage = try Crypt.encrypt(message, secret: secret)
        let decryptedMessage = try Crypt.decrypt(encryptedMessage, secret: secret)
        let decryptedMessageString = try #require(String(data: decryptedMessage, encoding: .utf8))

        #expect("Hello World" == decryptedMessageString)
        #expect(message == decryptedMessage)
        #expect(message != encryptedMessage)

        // Incorrect Secret
        let incorrectSecret = Crypt.generateSecureRandom()
        #expect(throws: Error.self) {
            try Crypt.decrypt(encryptedMessage, secret: incorrectSecret)
        }
    }

    @Test
    func encryptDecrypt_SecretString() throws {
        let secret = Crypt.generateRandomPassword()
        let message = Data("Hello World".utf8)

        let encryptedMessage = try Crypt.encrypt(message, secret: secret)
        let decryptedMessage = try Crypt.decrypt(encryptedMessage, secret: secret)
        let decryptedMessageString = try #require(String(data: decryptedMessage, encoding: .utf8))

        #expect("Hello World" == decryptedMessageString)
        #expect(message == decryptedMessage)
        #expect(message != encryptedMessage)

        // Incorrect Secret
        let incorrectSecret = Crypt.generateRandomPassword()
        #expect(throws: Error.self) {
            try Crypt.decrypt(encryptedMessage, secret: incorrectSecret)
        }
    }
}
