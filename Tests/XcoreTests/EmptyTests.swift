//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import XCTest
@testable import Xcore
import SwiftUI

final class EmptyTests: TestCase {
    func testEquality() {
        XCTAssertEqual(Empty(), Empty())
    }

    func testIdentifiable() {
        XCTAssertEqual(Empty().id, Empty().id)
    }

    func testComparable() {
        XCTAssertFalse(Empty() < Empty())
        XCTAssertFalse(Empty() > Empty())

        XCTAssertTrue(Empty() <= Empty())
        XCTAssertTrue(Empty() >= Empty())
    }
}
