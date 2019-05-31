//
// PercentageTests.swift
//
// Copyright © 2019 Xcore
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
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
