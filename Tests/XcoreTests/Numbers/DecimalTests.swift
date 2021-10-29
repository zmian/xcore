//
// Xcore
// Copyright © 2019 Xcore
// MIT license, see LICENSE file for details
//

import XCTest
@testable import Xcore

final class DecimalTests: TestCase {
    func testDecimalRounded() {
        let x = Decimal(6.5)

        XCTAssertEqual(Decimal(6).rounded(precision: 2), 6)

        XCTAssertEqual(x.rounded(.toNearestOrAwayFromZero, precision: 2), 6.5)

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

    func testDecimalRound() {
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
        w2.round(precision: 2)
        XCTAssertEqual(w2, 6.5)
    }
}
