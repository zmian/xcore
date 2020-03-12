//
// Xcore
// Copyright © 2019 Xcore
// MIT license, see LICENSE file for details
//

import XCTest
@testable import Xcore

final class DictionaryTests: TestCase {
    func testRawRepresentableSubscriptString() {
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

        XCTAssertEqual(dictionary[Key.framework]!, "Xcore")
    }

    func testRawRepresentableSubscriptInt() {
        enum Key: Int {
            case zero
            case one
        }

        let dictionary = [
            0: "zmian",
            1: "Xcore"
        ]

        XCTAssertEqual(dictionary[Key.one]!, "Xcore")
    }
}
