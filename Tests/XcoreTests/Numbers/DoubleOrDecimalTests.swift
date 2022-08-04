//
// Xcore
// Copyright © 2022 Xcore
// MIT license, see LICENSE file for details
//

import XCTest
@testable import Xcore

final class DoubleOrDecimalTests: TestCase {
    func testDecimal_rounded() {
        // .rounded
        XCTAssertEqual(Decimal(1).formatted(.rounded), "1.00")
        XCTAssertEqual(Decimal(1.09).formatted(.rounded), "1.09")
        XCTAssertEqual(Decimal(1.9).formatted(.rounded), "1.90")
        XCTAssertEqual(Decimal(2).formatted(.rounded), "2.00")
        XCTAssertEqual(Decimal(2.1345).formatted(.rounded), "2.13")
        XCTAssertEqual(Decimal(2.1355).formatted(.rounded), "2.14")

        // .rounded, showPlusSign: true
        XCTAssertEqual(Decimal(0).formatted(.rounded, showPlusSign: true), "0.00")
        XCTAssertEqual(Decimal(1).formatted(.rounded, showPlusSign: true), "+1.00")
        XCTAssertEqual(Decimal(1.09).formatted(.rounded, showPlusSign: true), "+1.09")
        XCTAssertEqual(Decimal(1.9).formatted(.rounded, showPlusSign: true), "+1.90")
        XCTAssertEqual(Decimal(-2).formatted(.rounded, showPlusSign: true), "-2.00")
        XCTAssertEqual(Decimal(2.1345).formatted(.rounded, showPlusSign: true), "+2.13")
        XCTAssertEqual(Decimal(-2.1355).formatted(.rounded, showPlusSign: true), "-2.14")
    }

    func testDecimal_roundedPercent() {
        // .roundedPercent(scale: .zeroToOne)
        XCTAssertEqual(Decimal(1).formatted(.roundedPercent), "100.00%")
        XCTAssertEqual(Decimal(1.09).formatted(.roundedPercent), "109.00%")
        XCTAssertEqual(Decimal(1.9).formatted(.roundedPercent), "190.00%")
        XCTAssertEqual(Decimal(2).formatted(.roundedPercent), "200.00%")
        XCTAssertEqual(Decimal(2.1345).formatted(.roundedPercent), "213.45%")
        XCTAssertEqual(Decimal(2.1355).formatted(.roundedPercent), "213.55%")

        XCTAssertEqual(Decimal(0.019).formatted(.roundedPercent), "1.90%")
        XCTAssertEqual(Decimal(-0.0109).formatted(.roundedPercent), "-1.09%")
        XCTAssertEqual(Decimal(0.02).formatted(.roundedPercent), "2.00%")
        XCTAssertEqual(Decimal(1).formatted(.roundedPercent), "100.00%")

        // .roundedPercent(scale: .zeroToHundred)
        XCTAssertEqual(Decimal(1).formatted(.roundedPercent(scale: .zeroToHundred)), "1.00%")
        XCTAssertEqual(Decimal(1.09).formatted(.roundedPercent(scale: .zeroToHundred)), "1.09%")
        XCTAssertEqual(Decimal(1.9).formatted(.roundedPercent(scale: .zeroToHundred)), "1.90%")
        XCTAssertEqual(Decimal(2).formatted(.roundedPercent(scale: .zeroToHundred)), "2.00%")
        XCTAssertEqual(Decimal(2.1345).formatted(.roundedPercent(scale: .zeroToHundred)), "2.13%")
        XCTAssertEqual(Decimal(2.1355).formatted(.roundedPercent(scale: .zeroToHundred)), "2.14%")
    }

    func testDecimal_withPercentSign() {
        // .withPercentSign(scale: .zeroToOne)
        XCTAssertEqual(Decimal(0.019).formatted(.withPercentSign), "1.9%")
        XCTAssertEqual(Decimal(-0.0109).formatted(.withPercentSign), "-1.09%")
        XCTAssertEqual(Decimal(0.02).formatted(.withPercentSign), "2%")
        XCTAssertEqual(Decimal(1).formatted(.withPercentSign), "100%")

        // .withPercentSign(scale: .zeroToOne)
        XCTAssertEqual(Decimal(1).formatted(.withPercentSign), "100%")
        XCTAssertEqual(Decimal(1.09).formatted(.withPercentSign), "109%")
        XCTAssertEqual(Decimal(1.9).formatted(.withPercentSign), "190%")
        XCTAssertEqual(Decimal(2).formatted(.withPercentSign), "200%")
        XCTAssertEqual(Decimal(2.1345).formatted(.withPercentSign), "213.45%")
        XCTAssertEqual(Decimal(2.1355).formatted(.withPercentSign), "213.55%")

        // .withPercentSign(scale: .zeroToHundred)
        XCTAssertEqual(Decimal(1).formatted(.withPercentSign(scale: .zeroToHundred)), "1%")
        XCTAssertEqual(Decimal(1.09).formatted(.withPercentSign(scale: .zeroToHundred)), "1.09%")
        XCTAssertEqual(Decimal(1.9).formatted(.withPercentSign(scale: .zeroToHundred)), "1.9%")
        XCTAssertEqual(Decimal(2).formatted(.withPercentSign(scale: .zeroToHundred)), "2%")
        XCTAssertEqual(Decimal(2.1345).formatted(.withPercentSign(scale: .zeroToHundred)), "2.13%")
        XCTAssertEqual(Decimal(2.1355).formatted(.withPercentSign(scale: .zeroToHundred)), "2.14%")

        // .withPercentSign(scale: .zeroToOne), fractionLength: 0...0
        XCTAssertEqual(Decimal(0.019).formatted(.withPercentSign(fractionLength: 0...0)), "2%")
        XCTAssertEqual(Decimal(-0.0109).formatted(.withPercentSign(fractionLength: 0...0)), "-1%")
        XCTAssertEqual(Decimal(0.02).formatted(.withPercentSign(fractionLength: 0...0)), "2%")
        XCTAssertEqual(Decimal(1).formatted(.withPercentSign(fractionLength: 0...0)), "100%")

        // .withPercentSign(scale: .zeroToOne), fractionLength: 0...2
        XCTAssertEqual(Decimal(0.019).formatted(.withPercentSign(fractionLength: 0...2)), "1.9%")
        XCTAssertEqual(Decimal(-0.0109).formatted(.withPercentSign(fractionLength: 0...2)), "-1.09%")
        XCTAssertEqual(Decimal(0.02).formatted(.withPercentSign(fractionLength: 0...2)), "2%")
        XCTAssertEqual(Decimal(1).formatted(.withPercentSign(fractionLength: 0...2)), "100%")

        // .withPercentSign(scale: .zeroToOne), fractionLength: 2...2, showPlusSign: true
        XCTAssertEqual(Decimal(0.019).formatted(.withPercentSign(fractionLength: 0...2), showPlusSign: true), "+1.9%")
        XCTAssertEqual(Decimal(-0.0109).formatted(.withPercentSign(fractionLength: 0...2), showPlusSign: true), "-1.09%")
        XCTAssertEqual(Decimal(0.02).formatted(.withPercentSign(fractionLength: 0...2), showPlusSign: true), "+2%")
        XCTAssertEqual(Decimal(1).formatted(.withPercentSign(fractionLength: 0...2), showPlusSign: true), "+100%")

        // .withPercentSign(scale: .zeroToOne), showPlusSign: true, minimumBound: 0.01
        XCTAssertEqual(Decimal(0.019).formatted(.withPercentSign, showPlusSign: true, minimumBound: 0.01), "+1.9%")
        XCTAssertEqual(Decimal(-0.0109).formatted(.withPercentSign, showPlusSign: true, minimumBound: 0.01), "-1.09%")
        XCTAssertEqual(Decimal(0.02).formatted(.withPercentSign, showPlusSign: true, minimumBound: 0.01), "+2%")
        XCTAssertEqual(Decimal(1).formatted(.withPercentSign, showPlusSign: true, minimumBound: 0.01), "+100%")
        XCTAssertEqual(Decimal(-0.0000109).formatted(.withPercentSign, showPlusSign: true, minimumBound: 0.0001), "<-0.01%")
        XCTAssertEqual(Decimal(0.0000109).formatted(.withPercentSign, showPlusSign: true, minimumBound: 0.0001), "<0.01%")
        XCTAssertEqual(Decimal(-0.0000109).formatted(.withPercentSign(fractionLength: .maxFractionDigits)), "-0.00109%")
        XCTAssertEqual(Decimal(0.0000109).formatted(.withPercentSign(fractionLength: .maxFractionDigits)), "0.00109%")
    }
}
