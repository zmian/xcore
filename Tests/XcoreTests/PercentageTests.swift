//
// Xcore
// Copyright © 2019 Xcore
// MIT license, see LICENSE file for details
//

import XCTest
@testable import Xcore

final class PercentageTests: TestCase {
    func testNormalization() {
        let sliderValue1: Percentage = 0.5
        XCTAssertEqual(sliderValue1, 0.5)

        var sliderValue2: Percentage = 500
        XCTAssertEqual(sliderValue2, 100)

        sliderValue2 -= 1
        XCTAssertEqual(sliderValue2, 99)

        sliderValue2 += 1
        XCTAssertEqual(sliderValue2, 100)

        XCTAssertEqual(Percentage(rawValue: -1), 0)
        XCTAssertEqual(Percentage(rawValue: 1000), 100)

        XCTAssertEqual(Percentage.min + 0.7, 0.7)
        XCTAssertNotEqual(Percentage.min + 0.7, 0.6)

        XCTAssertEqual(Percentage.max - 900, 0)
    }

    func testfirstNormalizedThenEqualityCheck() {
        // NOTE: This is true as the rhs is first normalized and
        // then the equality is checked. See below:
        XCTAssertEqual(Percentage.max - 900, -800) // x
        XCTAssertEqual(Percentage.max - 900, 0) // y

        // x and y both yields same result. Here is why:
        XCTAssertEqual(Percentage.max - 900, Percentage(rawValue: -800)) // x
        XCTAssertEqual(Percentage.max - 900, Percentage(rawValue: 0)) // y

        // More details
        let a = Percentage(rawValue: -800)
        let b = Percentage.max - 900
        XCTAssertEqual(a, 0)
        XCTAssertEqual(b, 0)
        XCTAssertEqual(a, b)
    }
}
