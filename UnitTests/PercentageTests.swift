//
// PercentageTests.swift
// Copyright © 2019 Xcore
// MIT license, see LICENSE file for details
//

import XCTest
@testable import Xcore

final class PercentageTests: TestCase {
    func testNormalization() {
        let sliderValue1: Percentage = 0.5
        XCTAssertTrue(sliderValue1 == 0.5)

        var sliderValue2: Percentage = 500
        XCTAssertTrue(sliderValue2 == 100)

        sliderValue2 -= 1
        XCTAssertTrue(sliderValue2 == 99)

        sliderValue2 += 1
        XCTAssertTrue(sliderValue2 == 100)

        XCTAssertTrue(Percentage(rawValue: -1) == 0)
        XCTAssertTrue(Percentage(rawValue: 1000) == 100)

        XCTAssertTrue(Percentage.min + 0.7 == 0.7)
        XCTAssertTrue(Percentage.min + 0.7 != 0.6)

        XCTAssertTrue(Percentage.max - 900 == 0)
    }

    func testfirstNormalizedThenEqualityCheck() {
        // NOTE: This is true as the rhs is first normalized and
        // then the equality is checked. See below:
        XCTAssertTrue(Percentage.max - 900 == -800) // x
        XCTAssertTrue(Percentage.max - 900 == 0)    // y

        // x and y both yields same result. Here is why:
        XCTAssertTrue(Percentage.max - 900 == Percentage(rawValue: -800)) // x
        XCTAssertTrue(Percentage.max - 900 == Percentage(rawValue: 0))    // y

        // More details
        let a = Percentage(rawValue: -800)
        let b = Percentage.max - 900
        XCTAssertTrue(a == 0)
        XCTAssertTrue(b == 0)
        XCTAssertTrue(a == b)
    }
}
