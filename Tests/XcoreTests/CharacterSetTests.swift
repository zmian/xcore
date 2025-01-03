//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import Testing
import Foundation
@testable import Xcore

struct CharacterSetTests {
    @Test
    func characters() {
        let characters = CharacterSet.uppercaseLetters.characters()
        #expect(characters.count == 1862)
        #expect(characters.prefix(3) == ["A", "B", "C"])
    }

    @Test
    func numbers() {
        let characters = CharacterSet.numbers.characters()
        #expect(characters.count == 10)
        #expect(String(characters) == "0123456789")
    }

    @Test
    func numbersWithDecimal() {
        let characters = CharacterSet.numbersWithDecimal.characters()
        #expect(characters.count == 11)
        #expect(String(characters) == ".0123456789")
    }

    @Test
    func lettersAndSpaces() {
        let characters = CharacterSet.lettersAndSpaces.characters()
        #expect(characters.count == 53)
        #expect(String(characters) == " ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz")
    }

    @Test
    func randomString() {
        let result = CharacterSet.lettersAndSpaces.randomString(length: 50)
        #expect(result.count == 50)
    }
}
