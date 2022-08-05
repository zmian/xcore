//
// Xcore
// Copyright © 2022 Xcore
// MIT license, see LICENSE file for details
//

import XCTest
@testable import Xcore

final class DoubleOrDecimalTests: TestCase {
    func testDecimal_rounded() {
        // .rounded(trimZero: false)
        XCTAssertEqual(Decimal(1).formatted(.rounded), "1.00")
        XCTAssertEqual(Decimal(1.09).formatted(.rounded), "1.09")
        XCTAssertEqual(Decimal(1.9).formatted(.rounded), "1.90")
        XCTAssertEqual(Decimal(2).formatted(.rounded), "2.00")
        XCTAssertEqual(Decimal(2.1345).formatted(.rounded), "2.13")
        XCTAssertEqual(Decimal(2.1355).formatted(.rounded), "2.14")

        // .rounded(trimZero: true)
        XCTAssertEqual(Decimal(1).formatted(.rounded(trimZero: true)), "1")
        XCTAssertEqual(Decimal(1.09).formatted(.rounded(trimZero: true)), "1.09")
        XCTAssertEqual(Decimal(1.9).formatted(.rounded(trimZero: true)), "1.90")
        XCTAssertEqual(Decimal(2).formatted(.rounded(trimZero: true)), "2")
        XCTAssertEqual(Decimal(2.1345).formatted(.rounded(trimZero: true)), "2.13")
        XCTAssertEqual(Decimal(2.1355).formatted(.rounded(trimZero: true)), "2.14")

        // .rounded(trimZero: false), showPlusSign: true
        XCTAssertEqual(Decimal(0).formatted(.rounded, showPlusSign: true), "0.00")
        XCTAssertEqual(Decimal(1).formatted(.rounded, showPlusSign: true), "+1.00")
        XCTAssertEqual(Decimal(1.09).formatted(.rounded, showPlusSign: true), "+1.09")
        XCTAssertEqual(Decimal(1.9).formatted(.rounded, showPlusSign: true), "+1.90")
        XCTAssertEqual(Decimal(-2).formatted(.rounded, showPlusSign: true), "-2.00")
        XCTAssertEqual(Decimal(2.1345).formatted(.rounded, showPlusSign: true), "+2.13")
        XCTAssertEqual(Decimal(-2.1355).formatted(.rounded, showPlusSign: true), "-2.14")
    }

    func testDecimal_percentage_fractionLength() {
        // .percentage(scale: .zeroToOne, fractionLength: 2)
        XCTAssertEqual(Decimal(1).formatted(.percentage(fractionLength: 2)), "100.00%")
        XCTAssertEqual(Decimal(1.09).formatted(.percentage(fractionLength: 2)), "109.00%")
        XCTAssertEqual(Decimal(1.9).formatted(.percentage(fractionLength: 2)), "190.00%")
        XCTAssertEqual(Decimal(2).formatted(.percentage(fractionLength: 2)), "200.00%")
        XCTAssertEqual(Decimal(2.1345).formatted(.percentage(fractionLength: 2)), "213.45%")
        XCTAssertEqual(Decimal(2.1355).formatted(.percentage(fractionLength: 2)), "213.55%")

        XCTAssertEqual(Decimal(0.019).formatted(.percentage(fractionLength: 2)), "1.90%")
        XCTAssertEqual(Decimal(-0.0109).formatted(.percentage(fractionLength: 2)), "-1.09%")
        XCTAssertEqual(Decimal(0.02).formatted(.percentage(fractionLength: 2)), "2.00%")
        XCTAssertEqual(Decimal(1).formatted(.percentage(fractionLength: 2)), "100.00%")

        // .percentage(scale: .zeroToHundred, fractionLength: 2)
        XCTAssertEqual(Decimal(1).formatted(.percentage(scale: .zeroToHundred, fractionLength: 2)), "1.00%")
        XCTAssertEqual(Decimal(1.09).formatted(.percentage(scale: .zeroToHundred, fractionLength: 2)), "1.09%")
        XCTAssertEqual(Decimal(1.9).formatted(.percentage(scale: .zeroToHundred, fractionLength: 2)), "1.90%")
        XCTAssertEqual(Decimal(2).formatted(.percentage(scale: .zeroToHundred, fractionLength: 2)), "2.00%")
        XCTAssertEqual(Decimal(2.1345).formatted(.percentage(scale: .zeroToHundred, fractionLength: 2)), "2.13%")
        XCTAssertEqual(Decimal(2.1355).formatted(.percentage(scale: .zeroToHundred, fractionLength: 2)), "2.14%")
    }

    func testDecimal_percentage() {
        // .percentage(scale: .zeroToOne)
        XCTAssertEqual(Decimal(0.019).formatted(.percentage), "1.9%")
        XCTAssertEqual(Decimal(-0.0109).formatted(.percentage), "-1.09%")
        XCTAssertEqual(Decimal(0.02).formatted(.percentage), "2%")
        XCTAssertEqual(Decimal(1).formatted(.percentage), "100%")

        // .percentage(scale: .zeroToOne)
        XCTAssertEqual(Decimal(1).formatted(.percentage), "100%")
        XCTAssertEqual(Decimal(1.09).formatted(.percentage), "109%")
        XCTAssertEqual(Decimal(1.9).formatted(.percentage), "190%")
        XCTAssertEqual(Decimal(2).formatted(.percentage), "200%")
        XCTAssertEqual(Decimal(2.1345).formatted(.percentage), "213.45%")
        XCTAssertEqual(Decimal(2.1355).formatted(.percentage), "213.55%")

        // .percentage(scale: .zeroToHundred)
        XCTAssertEqual(Decimal(1).formatted(.percentage(scale: .zeroToHundred)), "1%")
        XCTAssertEqual(Decimal(1.09).formatted(.percentage(scale: .zeroToHundred)), "1.09%")
        XCTAssertEqual(Decimal(1.9).formatted(.percentage(scale: .zeroToHundred)), "1.9%")
        XCTAssertEqual(Decimal(2).formatted(.percentage(scale: .zeroToHundred)), "2%")
        XCTAssertEqual(Decimal(2.1345).formatted(.percentage(scale: .zeroToHundred)), "2.13%")
        XCTAssertEqual(Decimal(2.1355).formatted(.percentage(scale: .zeroToHundred)), "2.14%")

        // .percentage(scale: .zeroToOne), fractionLength: 0...0
        XCTAssertEqual(Decimal(0.019).formatted(.percentage(fractionLength: 0...0)), "2%")
        XCTAssertEqual(Decimal(-0.0109).formatted(.percentage(fractionLength: 0...0)), "-1%")
        XCTAssertEqual(Decimal(0.02).formatted(.percentage(fractionLength: 0...0)), "2%")
        XCTAssertEqual(Decimal(1).formatted(.percentage(fractionLength: 0...0)), "100%")

        // .percentage(scale: .zeroToOne), fractionLength: 0...2
        XCTAssertEqual(Decimal(0.019).formatted(.percentage(fractionLength: 0...2)), "1.9%")
        XCTAssertEqual(Decimal(-0.0109).formatted(.percentage(fractionLength: 0...2)), "-1.09%")
        XCTAssertEqual(Decimal(0.02).formatted(.percentage(fractionLength: 0...2)), "2%")
        XCTAssertEqual(Decimal(1).formatted(.percentage(fractionLength: 0...2)), "100%")

        // .percentage(scale: .zeroToOne), fractionLength: 2...2, showPlusSign: true
        XCTAssertEqual(Decimal(0).formatted(.percentage(fractionLength: 0...2), showPlusSign: true), "0%")
        XCTAssertEqual(Decimal(0.019).formatted(.percentage(fractionLength: 0...2), showPlusSign: true), "+1.9%")
        XCTAssertEqual(Decimal(-0.0109).formatted(.percentage(fractionLength: 0...2), showPlusSign: true), "-1.09%")
        XCTAssertEqual(Decimal(0.02).formatted(.percentage(fractionLength: 0...2), showPlusSign: true), "+2%")
        XCTAssertEqual(Decimal(1).formatted(.percentage(fractionLength: 0...2), showPlusSign: true), "+100%")

        // .percentage(scale: .zeroToOne), showPlusSign: true, minimumBound: 0.01
        XCTAssertEqual(Decimal(0.019).formatted(.percentage, showPlusSign: true, minimumBound: 0.01), "+1.9%")
        XCTAssertEqual(Decimal(-0.0109).formatted(.percentage, showPlusSign: true, minimumBound: 0.01), "-1.09%")
        XCTAssertEqual(Decimal(0.02).formatted(.percentage, showPlusSign: true, minimumBound: 0.01), "+2%")
        XCTAssertEqual(Decimal(1).formatted(.percentage, showPlusSign: true, minimumBound: 0.01), "+100%")
        XCTAssertEqual(Decimal(-0.0000109).formatted(.percentage, showPlusSign: true, minimumBound: 0.0001), "<-0.01%")
        XCTAssertEqual(Decimal(0.0000109).formatted(.percentage, showPlusSign: true, minimumBound: 0.0001), "<0.01%")
        XCTAssertEqual(Decimal(-0.0000109).formatted(.percentage(fractionLength: .maxFractionDigits)), "-0.00109%")
        XCTAssertEqual(Decimal(0.0000109).formatted(.percentage(fractionLength: .maxFractionDigits)), "0.00109%")
    }
}
