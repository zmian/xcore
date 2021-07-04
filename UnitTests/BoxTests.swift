//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import XCTest
@testable import Xcore

final class BoxTests: TestCase {
    func testBox() {
        let box = Box("Hello, world!")
        XCTAssertEqual(box.value, "Hello, world!")
    }

    func testBoxEquality() {
        let box1 = Box(1)
        let box2 = Box(1)
        XCTAssertEqual(box1, box2)

        let box3 = Box(3)
        XCTAssertNotEqual(box1, box3)
    }
}
