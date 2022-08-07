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

    func testConversionToString() throws {
        let decimal_us = try XCTUnwrap(Decimal(string: "0.377", locale: .usPosix))
        XCTAssertEqual(decimal_us.stringValue, "0.377")

        let decimal_ptPT = try XCTUnwrap(Decimal(string: "0,377", locale: .ptPT))
        XCTAssertEqual(decimal_ptPT.stringValue, "0.377")
    }

    func testIntegerAndFractionalParts() throws {
        let amount1 = Decimal(1200.30)
        XCTAssertEqual(amount1.integerPart, 1200)
        XCTAssertEqual(amount1.fractionalPart, 0.3)

        let amount2 = Decimal(1200.00)
        XCTAssertEqual(amount2.integerPart, 1200)
        XCTAssertEqual(amount2.fractionalPart, 0)

        let amount3 = try XCTUnwrap(Decimal(string: "1200.3000000012"))
        XCTAssertEqual(String(describing: amount3), "1200.3000000012")
        XCTAssertEqual(amount3.integerPart, 1200)
        XCTAssertEqual(amount3.fractionalPart, Decimal(string: "0.3000000012"))
        XCTAssertEqual(amount3.fractionalPart.stringValue, "0.3000000012")

        let amount4 = Decimal(1200.000000000000000000)
        XCTAssertEqual(amount4.integerPart, 1200)
        XCTAssertEqual(amount4.fractionalPart, 0)
    }

    func testIsFractionalPartZero() throws {
        // True
        XCTAssertEqual(Decimal(1200).isFractionalPartZero, true)
        XCTAssertEqual(Decimal(1200.00).isFractionalPartZero, true)
        XCTAssertEqual(Decimal(1200.000000000000000000).isFractionalPartZero, true)

        // False
        XCTAssertEqual(Decimal(1200.30).isFractionalPartZero, false)
        XCTAssertEqual(try XCTUnwrap(Decimal(string: "1200.3000000012")).isFractionalPartZero, false)
        XCTAssertEqual(try XCTUnwrap(Decimal(string: "1200.0000000012")).isFractionalPartZero, false)
    }
}
