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
}
