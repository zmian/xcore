//
// Xcore
// Copyright © 2019 Xcore
// MIT license, see LICENSE file for details
//

import XCTest
@testable import Xcore

final class SortOrderableTests: TestCase {
    func testSorted() {
        let s1 = SomeType(name: "hello", sortOrder: 0)
        let s2 = SomeType(name: "hello", sortOrder: 1)
        let s3 = SomeType(name: "hello", sortOrder: Int.max)
        let s4 = SomeType(name: "hello", sortOrder: 2)
        let s5 = SomeType(name: "hello", sortOrder: 1)

        let array = [s1, s2, s3, s4, s5]
        let expectedOrder = [s1, s2, s5, s4, s3]
        let result = array.sorted()
        XCTAssertEqual(result, expectedOrder)
    }
}

private struct SomeType: SortOrderable, Equatable {
    let name: String
    let sortOrder: Int
}
