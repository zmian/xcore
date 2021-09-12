//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import XCTest
@testable import Xcore

final class UUIDTests: TestCase {
    func testZeroString() {
        XCTAssertEqual(UUID.zero.uuidString, "00000000-0000-0000-0000-000000000000")
    }

    func testBytes() {
        let uuid = UUID.zero
        let zeroBytes: [UInt8] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
        XCTAssertEqual(uuid.bytes, zeroBytes)
    }
}
