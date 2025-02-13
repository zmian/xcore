//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import Testing
import Foundation
@testable import Xcore

struct JSONDecoderKeyPathTests {
    @Test
    func validKeyPath() throws {
        let json = Data("""
        {
            "person": {
                "name": "Sam",
                "age": 8
            }
        }
        """.utf8)

        let person = try JSONDecoder().decode(Person.self, from: json, keyPath: "person")
        #expect(Person(name: "Sam", age: 8) == person)
    }

    @Test
    func inValidKeyPath() throws {
        let json = Data("""
        {
            "person": {
                "name": "Sam",
                "age": 8
            }
        }
        """.utf8)

        #expect(throws: Error.self) {
            try JSONDecoder().decode(Person.self, from: json, keyPath: "person.custom")
        }
    }

    @Test
    func validKeyPathNested() throws {
        let json = Data("""
        {
            "level_1": {
                "person": {
                    "name": "Sam",
                    "age": 8
                }
            }
        }
        """.utf8)

        let person = try JSONDecoder().decode(Person.self, from: json, keyPath: "level_1.person")
        #expect(Person(name: "Sam", age: 8) == person)
    }

    @Test
    func validKeyPathNestedSeparator() throws {
        let json = Data("""
        {
            "level_1": {
                "level_2.person": {
                    "name": "Sam",
                    "age": 8
                }
            }
        }
        """.utf8)

        let person = try JSONDecoder().decode(
            Person.self,
            from: json,
            keyPath: .init(
                "level_1/level_2.person",
                separator: "/"
            )
        )

        #expect(Person(name: "Sam", age: 8) == person)
    }
}

extension JSONDecoderKeyPathTests {
    private struct Person: Codable, Hashable {
        let name: String
        let age: Int
    }
}
