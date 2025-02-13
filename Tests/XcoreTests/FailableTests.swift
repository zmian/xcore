//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import Testing
import Foundation
@testable import Xcore

struct FailableTests {
    @Test
    func withoutFailableDecoder() throws {
        #expect(throws: Error.self) {
            try JSONDecoder().decode([Pet].self, from: json)
        }
    }

    @Test
    func withFailableDecoder() throws {
        let pets = try JSONDecoder().decode([Failable<Pet>].self, from: json)

        #expect(pets.count == 2)
        #expect(pets.first?.name == "Zeus")
        #expect(pets.first?.age == 3)
        #expect(pets.last?.value == nil)
    }

    @Test
    func withFailableEncoder() throws {
        let pets1 = try JSONDecoder().decode([Failable<Pet>].self, from: json)
        let data = try JSONEncoder().encode(pets1)
        let pets2 = try JSONDecoder().decode([Failable<Pet>].self, from: data)
        #expect(pets1 == pets2)
    }

    @Test
    func withFailableDecodingStrategyLenient() throws {
        let pets = try JSONDecoder().decode([Pet].self, from: json, strategy: .lenient)

        #expect(pets.count == 1)
        #expect(pets.first?.name == "Zeus")
        #expect(pets.first?.age == 3)
        #expect(pets.last != nil) // Count is == 1 so last == first
    }

    @Test
    func withFailableDecodingStrategyThrows() throws {
        #expect(throws: Error.self) {
            try JSONDecoder().decode([Pet].self, from: json, strategy: .throw)
        }
    }

    // MARK: - Helpers

    private let json = Data("""
    [
        {"name": "Zeus", "age": 3},
        {"age": 5}
    ]
    """.utf8)

    private struct Pet: Codable, Hashable {
        let name: String
        let age: Int
    }
}
