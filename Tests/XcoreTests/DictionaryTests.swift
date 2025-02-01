//
// Xcore
// Copyright © 2019 Xcore
// MIT license, see LICENSE file for details
//

import Testing
@testable import Xcore

struct DictionaryTests {
    @Test
    func rawRepresentableSubscriptString() {
        enum Key: String {
            case name
            case framework
            case language
        }

        let dictionary = [
            "name": "zmian",
            "framework": "Xcore",
            "language": "Swift"
        ]

        #expect(dictionary[Key.framework] == "Xcore")
        #expect(dictionary[Key.name] == "zmian")
        #expect(dictionary[Key.language] == "Swift")
    }

    @Test
    func rawRepresentableSubscriptInt() {
        enum Key: Int {
            case zero
            case one
        }

        let dictionary = [
            0: "zmian",
            1: "Xcore"
        ]

        #expect(dictionary[Key.one] == "Xcore")
    }

    @Test
    func mapPairs() {
        enum Keys: String {
            case name = "full_name"
            case language
        }

        let parameter: [Keys: String] = [
            .name: "Vivien",
            .language: "English"
        ]

        let result = parameter.mapPairs()

        let expectedResult: [String: String] = [
            "full_name": "Vivien",
            "language": "English"
        ]

        #expect(result == expectedResult)
    }

    @Test
    func compactMapPairs() {
        enum Keys: String {
            case name = "full_name"
            case age
            case language
        }

        let parameter: [Keys: String?] = [
            .name: "Vivien",
            .age: nil,
            .language: "English"
        ]

        let result: [String: String?] = parameter.compactMapPairs {
            if $0.value == nil {
                return nil
            }

            return ($0.key.rawValue, $0.value)
        }

        let expectedResult: [String: String?] = [
            "full_name": "Vivien",
            "language": "English"
        ]

        #expect(result == expectedResult)
    }

    @Test
    func filterPairs() {
        let parameter = [
            "name": "Vivien",
            "language": "English"
        ]

        let result = parameter.filterPairs {
            $0.key != "language"
        }

        let expectedResult = [
            "name": "Vivien"
        ]

        #expect(result == expectedResult)
    }

    @Test
    func compacted() {
        let dict: [String: String?] = ["a": "Hello", "b": nil, "c": "World"]
        let compacted = dict.compacted()
        #expect(compacted == ["a": "Hello", "c": "World"])
    }
}
