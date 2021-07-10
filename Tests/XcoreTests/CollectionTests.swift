//
// Xcore
// Copyright © 2019 Xcore
// MIT license, see LICENSE file for details
//

import XCTest
@testable import Xcore

final class CollectionTests: TestCase {
    func testRemovingAll() {
        var numbers = [5, 6, 7, 8, 9, 10, 11]
        let removedNumbers = numbers.removingAll { $0 % 2 == 1 }
        XCTAssertEqual(numbers, [6, 8, 10])
        XCTAssertEqual(removedNumbers, [5, 7, 9, 11])
    }

    func testCount() {
        let cast = ["Vivien", "Marlon", "Kim", "Karl"]
        let shortNamesCount = cast.count { $0.count < 5 }
        XCTAssertEqual(shortNamesCount, 2)
    }
}
