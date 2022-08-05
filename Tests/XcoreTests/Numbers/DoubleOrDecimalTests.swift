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
        XCTAssertEqual(Decimal(-2).formatted(.rounded, showPlusSign: true), "−2.00")
        XCTAssertEqual(Decimal(2.1345).formatted(.rounded, showPlusSign: true), "+2.13")
        XCTAssertEqual(Decimal(-2.1355).formatted(.rounded, showPlusSign: true), "−2.14")
    }

    func testDecimal_asPercentage_fractionLength() {
        // .asPercentage(scale: .zeroToOne, fractionLength: 2)
        XCTAssertEqual(Decimal(1).formatted(.asPercentage(fractionLength: 2)), "100.00%")
        XCTAssertEqual(Decimal(1.09).formatted(.asPercentage(fractionLength: 2)), "109.00%")
        XCTAssertEqual(Decimal(1.9).formatted(.asPercentage(fractionLength: 2)), "190.00%")
        XCTAssertEqual(Decimal(2).formatted(.asPercentage(fractionLength: 2)), "200.00%")
        XCTAssertEqual(Decimal(2.1345).formatted(.asPercentage(fractionLength: 2)), "213.45%")
        XCTAssertEqual(Decimal(2.1355).formatted(.asPercentage(fractionLength: 2)), "213.55%")

        XCTAssertEqual(Decimal(0.019).formatted(.asPercentage(fractionLength: 2)), "1.90%")
        XCTAssertEqual(Decimal(-0.0109).formatted(.asPercentage(fractionLength: 2)), "−1.09%")
        XCTAssertEqual(Decimal(0.02).formatted(.asPercentage(fractionLength: 2)), "2.00%")
        XCTAssertEqual(Decimal(1).formatted(.asPercentage(fractionLength: 2)), "100.00%")

        // .asPercentage(scale: .zeroToHundred, fractionLength: 2)
        XCTAssertEqual(Decimal(1).formatted(.asPercentage(scale: .zeroToHundred, fractionLength: 2)), "1.00%")
        XCTAssertEqual(Decimal(1.09).formatted(.asPercentage(scale: .zeroToHundred, fractionLength: 2)), "1.09%")
        XCTAssertEqual(Decimal(1.9).formatted(.asPercentage(scale: .zeroToHundred, fractionLength: 2)), "1.90%")
        XCTAssertEqual(Decimal(2).formatted(.asPercentage(scale: .zeroToHundred, fractionLength: 2)), "2.00%")
        XCTAssertEqual(Decimal(2.1345).formatted(.asPercentage(scale: .zeroToHundred, fractionLength: 2)), "2.13%")
        XCTAssertEqual(Decimal(2.1355).formatted(.asPercentage(scale: .zeroToHundred, fractionLength: 2)), "2.14%")
        XCTAssertEqual(Decimal(0.021355).formatted(.asPercentage(fractionLength: 2)), "2.14%")
    }

    func testDecimal_asPercentage() {
        // .asPercentage(scale: .zeroToOne)
        XCTAssertEqual(Decimal(0.019).formatted(.asPercentage), "1.9%")
        XCTAssertEqual(Decimal(-0.0109).formatted(.asPercentage), "−1.09%")
        XCTAssertEqual(Decimal(0.02).formatted(.asPercentage), "2%")
        XCTAssertEqual(Decimal(1).formatted(.asPercentage), "100%")

        // .asPercentage(scale: .zeroToOne)
        XCTAssertEqual(Decimal(1).formatted(.asPercentage), "100%")
        XCTAssertEqual(Decimal(1.09).formatted(.asPercentage), "109%")
        XCTAssertEqual(Decimal(1.9).formatted(.asPercentage), "190%")
        XCTAssertEqual(Decimal(2).formatted(.asPercentage), "200%")
        XCTAssertEqual(Decimal(2.1345).formatted(.asPercentage), "213.45%")
        XCTAssertEqual(Decimal(2.1355).formatted(.asPercentage), "213.55%")

        // .asPercentage(scale: .zeroToHundred)
        XCTAssertEqual(Decimal(1).formatted(.asPercentage(scale: .zeroToHundred)), "1%")
        XCTAssertEqual(Decimal(1.09).formatted(.asPercentage(scale: .zeroToHundred)), "1.09%")
        XCTAssertEqual(Decimal(1.9).formatted(.asPercentage(scale: .zeroToHundred)), "1.9%")
        XCTAssertEqual(Decimal(2).formatted(.asPercentage(scale: .zeroToHundred)), "2%")
        XCTAssertEqual(Decimal(2.1345).formatted(.asPercentage(scale: .zeroToHundred)), "2.13%")
        XCTAssertEqual(Decimal(2.1355).formatted(.asPercentage(scale: .zeroToHundred)), "2.14%")

        // .asPercentage(scale: .zeroToOne), fractionLength: 0...0
        XCTAssertEqual(Decimal(0.019).formatted(.asPercentage(fractionLength: 0...0)), "2%")
        XCTAssertEqual(Decimal(-0.0109).formatted(.asPercentage(fractionLength: 0...0)), "−1%")
        XCTAssertEqual(Decimal(0.02).formatted(.asPercentage(fractionLength: 0...0)), "2%")
        XCTAssertEqual(Decimal(1).formatted(.asPercentage(fractionLength: 0...0)), "100%")

        // .asPercentage(scale: .zeroToOne), fractionLength: 0...2
        XCTAssertEqual(Decimal(0.019).formatted(.asPercentage(fractionLength: 0...2)), "1.9%")
        XCTAssertEqual(Decimal(-0.0109).formatted(.asPercentage(fractionLength: 0...2)), "−1.09%")
        XCTAssertEqual(Decimal(0.02).formatted(.asPercentage(fractionLength: 0...2)), "2%")
        XCTAssertEqual(Decimal(1).formatted(.asPercentage(fractionLength: 0...2)), "100%")

        // .asPercentage(scale: .zeroToOne), fractionLength: 2...2, showPlusSign: true
        XCTAssertEqual(Decimal(0).formatted(.asPercentage(fractionLength: 0...2), showPlusSign: true), "0%")
        XCTAssertEqual(Decimal(0.019).formatted(.asPercentage(fractionLength: 0...2), showPlusSign: true), "+1.9%")
        XCTAssertEqual(Decimal(-0.0109).formatted(.asPercentage(fractionLength: 0...2), showPlusSign: true), "−1.09%")
        XCTAssertEqual(Decimal(0.02).formatted(.asPercentage(fractionLength: 0...2), showPlusSign: true), "+2%")
        XCTAssertEqual(Decimal(1).formatted(.asPercentage(fractionLength: 0...2), showPlusSign: true), "+100%")

        // .asPercentage(scale: .zeroToOne), showPlusSign: true, minimumBound: 0.01
        XCTAssertEqual(Decimal(0.019).formatted(.asPercentage, showPlusSign: true, minimumBound: 0.01), "+1.9%")
        XCTAssertEqual(Decimal(-0.0109).formatted(.asPercentage, showPlusSign: true, minimumBound: 0.01), "−1.09%")
        XCTAssertEqual(Decimal(0.02).formatted(.asPercentage, showPlusSign: true, minimumBound: 0.01), "+2%")
        XCTAssertEqual(Decimal(1).formatted(.asPercentage, showPlusSign: true, minimumBound: 0.01), "+100%")
        XCTAssertEqual(Decimal(-0.0000109).formatted(.asPercentage, showPlusSign: true, minimumBound: 0.0001), "<−0.01%")
        XCTAssertEqual(Decimal(0.0000109).formatted(.asPercentage, showPlusSign: true, minimumBound: 0.0001), "<0.01%")
        XCTAssertEqual(Decimal(-0.0000109).formatted(.asPercentage(fractionLength: .maxFractionDigits)), "−0.00109%")
        XCTAssertEqual(Decimal(0.0000109).formatted(.asPercentage(fractionLength: .maxFractionDigits)), "0.00109%")
    }
}
