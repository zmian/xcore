//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import XCTest
@testable import Xcore

final class CharacterSetTests: TestCase {
    func testCharacters() {
        let characters = CharacterSet.uppercaseLetters.characters()
        XCTAssertEqual(characters.count, 1822)
        XCTAssertEqual(characters.prefix(3), ["A", "B", "C"])
    }

    func testNumbers() {
        let characters = CharacterSet.numbers.characters()
        XCTAssertEqual(characters.count, 10)
        XCTAssertEqual(String(characters), "0123456789")
    }

    func testNumbersWithDecimal() {
        let characters = CharacterSet.numbersWithDecimal.characters()
        XCTAssertEqual(characters.count, 11)
        XCTAssertEqual(String(characters), ".0123456789")
    }

    func testLettersAndSpaces() {
        let characters = CharacterSet.lettersAndSpaces.characters()
        XCTAssertEqual(characters.count, 53)
        XCTAssertEqual(String(characters), " ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz")
    }

    func testRandomString() {
        let result = CharacterSet.lettersAndSpaces.randomString(length: 50)
        XCTAssertEqual(result.count, 50)
    }
}
