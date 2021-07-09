//
// Xcore
// Copyright © 2018 Xcore
// MIT license, see LICENSE file for details
//

import XCTest
@testable import Xcore

final class CaseIterableTests: TestCase {
    func testAllCases() {
        XCTAssertEqual(SomeClass.Counting.allCases.count, 3)
        XCTAssertEqual(SomeClass.NewCounting.allCases.count, 2)
        XCTAssertEqual(SomeStruct.Counting.allCases.count, 3)
    }

    func testCount() {
        XCTAssertEqual(SomeClass.Counting.count, 3)
        XCTAssertEqual(SomeClass.NewCounting.count, 2)
    }

    func testRawValues() {
        let expectedRawValues1 = [
            "one",
            "two",
            "three"
        ]

        let expectedRawValues2 = [
            "one",
            "two"
        ]

        XCTAssertEqual(SomeClass.Counting.rawValues, expectedRawValues1)
        XCTAssertEqual(SomeClass.NewCounting.rawValues, expectedRawValues2)
    }
}

private final class SomeClass {}

extension SomeClass {
    fileprivate enum Counting: String, CaseIterable {
        case one
        case two
        case three
    }

    fileprivate enum NewCounting: String, CaseIterable {
        case one
        case two
        case three

        static var allCases: [NewCounting] {
            [.one, .two]
        }
    }
}

private struct SomeStruct {}

extension SomeStruct {
    fileprivate enum Counting: String, CaseIterable {
        case one
        case two
        case three
    }
}
