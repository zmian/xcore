//
// Xcore
// Copyright © 2019 Xcore
// MIT license, see LICENSE file for details
//

import XCTest
@testable import Xcore

final class DecimalTests: TestCase {
    func testRounded() {
        let x = Decimal(6.5)

        XCTAssertEqual(Decimal(6).rounded(fractionDigits: 2), 6)

        XCTAssertEqual(x.rounded(.toNearestOrAwayFromZero, fractionDigits: 2), 6.5)

        // Equivalent to the C 'round' function:
        XCTAssertEqual(x.rounded(.toNearestOrAwayFromZero), 7.0)

        // Equivalent to the C 'trunc' function:
        XCTAssertEqual(x.rounded(.towardZero), 6.0)

        // Equivalent to the C 'ceil' function:
        XCTAssertEqual(x.rounded(.up), 7.0)

        // Equivalent to the C 'floor' function:
        XCTAssertEqual(x.rounded(.down), 6.0)

        // Equivalent to the C 'schoolbook rounding':
        XCTAssertEqual(x.rounded(), 7.0)
    }

    func testRound() {
        // Equivalent to the C 'round' function:
        var w = Decimal(6.5)
        w.round(.toNearestOrAwayFromZero)
        XCTAssertEqual(w, 7.0)

        // Equivalent to the C 'trunc' function:
        var x = Decimal(6.5)
        x.round(.towardZero)
        XCTAssertEqual(x, 6.0)

        // Equivalent to the C 'ceil' function:
        var y = Decimal(6.5)
        y.round(.up)
        XCTAssertEqual(y, 7.0)

        // Equivalent to the C 'floor' function:
        var z = Decimal(6.5)
        z.round(.down)
        XCTAssertEqual(z, 6.0)

        // Equivalent to the C 'schoolbook rounding':
        var w1 = 6.5
        w1.round()
        XCTAssertEqual(w1, 7.0)

        var w2 = Decimal(6.5)
        w2.round(fractionDigits: 2)
        XCTAssertEqual(w2, 6.5)

        var w3 = Decimal(6.56873)
        w3.round(fractionDigits: 2)
        XCTAssertEqual(w3, 6.57)
    }

    func testCalculatePrecision() {
        XCTAssertEqual(Decimal(1).calculatePrecision(), 2...2)
        XCTAssertEqual(Decimal(1.234).calculatePrecision(), 2...2)
        XCTAssertEqual(Decimal(1.000031).calculatePrecision(), 2...2)
        XCTAssertEqual(Decimal(0.00001).calculatePrecision(), 2...6)
        XCTAssertEqual(Decimal(0.000010000).calculatePrecision(), 2...6)
        XCTAssertEqual(Decimal(0.000012).calculatePrecision(), 2...6)
        XCTAssertEqual(Decimal(0.00001243).calculatePrecision(), 2...6)
        XCTAssertEqual(Decimal(0.00001253).calculatePrecision(), 2...6)
        XCTAssertEqual(Decimal(0.00001283).calculatePrecision(), 2...6)
        XCTAssertEqual(Decimal(0.000000138).calculatePrecision(), 2...8)
    }

    func testConversionToString() throws {
        let decimal_us = try XCTUnwrap(Decimal(string: "0.377", locale: .usPosix))
        XCTAssertEqual(decimal_us.stringValue, "0.377")

        let decimal_ptPT = try XCTUnwrap(Decimal(string: "0,377", locale: .ptPT))
        XCTAssertEqual(decimal_ptPT.stringValue, "0.377")
    }
}
