//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import XCTest
@testable import Xcore

final class FailableTests: TestCase {
    func testWithoutFailableDecoder() throws {
        XCTAssertThrowsError(try JSONDecoder().decode([Pet].self, from: json))
    }

    func testWithFailableDecoder() throws {
        let pets = try JSONDecoder().decode([Failable<Pet>].self, from: json)

        XCTAssertEqual(pets.count, 2)
        XCTAssertEqual(pets.first?.name, "Zeus")
        XCTAssertEqual(pets.first?.age, 3)
        XCTAssertNil(pets.last?.value)
    }

    func testWithFailableEncoder() throws {
        let pets1 = try JSONDecoder().decode([Failable<Pet>].self, from: json)
        let data = try JSONEncoder().encode(pets1)
        let pets2 = try JSONDecoder().decode([Failable<Pet>].self, from: data)
        XCTAssertEqual(pets1, pets2)
    }

    func testWithFailableDecodingStrategyLenient() throws {
        let pets = try JSONDecoder().decode([Pet].self, from: json, strategy: .lenient)

        XCTAssertEqual(pets.count, 1)
        XCTAssertEqual(pets.first?.name, "Zeus")
        XCTAssertEqual(pets.first?.age, 3)
        XCTAssertNotNil(pets.last) // Count is == 1 so last == first
    }

    func testWithFailableDecodingStrategyThrows() throws {
        XCTAssertThrowsError(try JSONDecoder().decode([Pet].self, from: json, strategy: .throw))
    }

    // MARK: - Helpers

    private let json = """
    [
        {"name": "Zeus", "age": 3},
        {"age": 5}
    ]
    """.data(using: .utf8)!

    private struct Pet: Codable, Hashable {
        let name: String
        let age: Int
    }
}
