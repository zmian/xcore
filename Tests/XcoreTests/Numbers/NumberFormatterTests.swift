//
// Xcore
// Copyright © 2022 Xcore
// MIT license, see LICENSE file for details
//

import XCTest
@testable import Xcore

final class NumberFormatterTests: TestCase {
    func testFractionLength() {
        let formatter = NumberFormatter()
        formatter.fractionLength = 2...2

        XCTAssertEqual(formatter.fractionLength, 2...2)
        XCTAssertEqual(formatter.minimumFractionDigits, 2)
        XCTAssertEqual(formatter.maximumFractionDigits, 2)

        formatter.fractionLength = 0...8
        XCTAssertEqual(formatter.fractionLength, 0...8)
        XCTAssertEqual(formatter.minimumFractionDigits, 0)
        XCTAssertEqual(formatter.maximumFractionDigits, 8)
    }
}
