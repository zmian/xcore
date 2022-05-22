//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import XCTest
@testable import Xcore

final class JSONDecoderKeyPathTests: TestCase {
    func testValidKeyPath() throws {
        let json = """
        {
            "person": {
                "name": "Sam",
                "age": 8
            }
        }
        """.data(using: .utf8)!

        let person = try JSONDecoder().decode(Person.self, from: json, keyPath: "person")
        XCTAssertEqual(Person(name: "Sam", age: 8), person)
    }

    func testInValidKeyPath() throws {
        let json = """
        {
            "person": {
                "name": "Sam",
                "age": 8
            }
        }
        """.data(using: .utf8)!

        XCTAssertThrowsError(try JSONDecoder().decode(Person.self, from: json, keyPath: "person.custom"))
    }

    func testValidKeyPathNested() throws {
        let json = """
        {
            "level_1": {
                "person": {
                    "name": "Sam",
                    "age": 8
                }
            }
        }
        """.data(using: .utf8)!

        let person = try JSONDecoder().decode(Person.self, from: json, keyPath: "level_1.person")
        XCTAssertEqual(Person(name: "Sam", age: 8), person)
    }

    func testValidKeyPathNestedSeparator() throws {
        let json = """
        {
            "level_1": {
                "level_2.person": {
                    "name": "Sam",
                    "age": 8
                }
            }
        }
        """.data(using: .utf8)!

        let person = try JSONDecoder().decode(
            Person.self,
            from: json,
            keyPath: .init(
                "level_1/level_2.person",
                separator: "/"
            )
        )

        XCTAssertEqual(Person(name: "Sam", age: 8), person)
    }
}

extension JSONDecoderKeyPathTests {
    private struct Person: Codable, Hashable {
        let name: String
        let age: Int
    }
}
