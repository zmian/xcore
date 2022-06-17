//
// Xcore
// Copyright © 2017 Xcore
// MIT license, see LICENSE file for details
//

import XCTest
@testable import Xcore

final class MoneyTests: TestCase {
    override class func setUp() {
        CurrencyFormatter.shared.locale = .us
    }

    func testMoneyStyles_default() {
        let amount1 = Money(120.30)
            .style(.default)

        XCTAssertEqual(String(describing: amount1), "$120.30")

        let amount2 = Money(120)
            .style(.default)

        XCTAssertEqual(String(describing: amount2), "$120.00")

        let amount3 = Money(-120)
            .style(.default)

        XCTAssertEqual(String(describing: amount3), "-$120.00")

        let amount4 = Money(-120)
            .style(.default)
            .signed()

        XCTAssertEqual(String(describing: amount4), "-$120.00")

        let amount5 = Money(120)
            .style(.default)
            .sign(.init(positive: "+", negative: "-"))

        XCTAssertEqual(String(describing: amount5), "+$120.00")

        let amount6 = Money(-120)
            .style(.default)
            .sign(.init(positive: "+", negative: "-"))

        XCTAssertEqual(String(describing: amount6), "-$120.00")

        let amount7 = Money(-120)
        XCTAssertEqual(amount7.string(), "-$120.00")
    }

    func testMoneyStyles_removeMinorUnit() {
        let amount = Money(120.30)
            .style(.removeMinorUnit)

        XCTAssertEqual(String(describing: amount), "$120")
    }

    func testMoneyStyles_removeMinorUnitIfZero() {
        let amount1 = Money(120.30)
            .style(.removeMinorUnitIfZero)

        XCTAssertEqual(String(describing: amount1), "$120.30")

        let amount2 = Money(120.00)
            .style(.removeMinorUnitIfZero)

        XCTAssertEqual(String(describing: amount2), "$120")
    }

    func testMoneyStyles_abbreviation_fallback_default() {
        let amount1 = Money(120.30)
            .style(.abbreviation(threshold: 0))

        XCTAssertEqual(String(describing: amount1), "$120.30")

        let amount2 = Money(987)
            .style(.abbreviation(threshold: 0))

        XCTAssertEqual(String(describing: amount2), "$987.00")

        let amount3 = Money(1200)
            .style(.abbreviation(threshold: 0))

        XCTAssertEqual(String(describing: amount3), "$1.2K")

        let amount4 = Money(12000)
            .style(.abbreviation(threshold: 0))

        XCTAssertEqual(String(describing: amount4), "$12K")

        let amount5 = Money(120_000)
            .style(.abbreviation(threshold: 0))

        XCTAssertEqual(String(describing: amount5), "$120K")

        let amount6 = Money(1_200_000)
            .style(.abbreviation(threshold: 0))

        XCTAssertEqual(String(describing: amount6), "$1.2M")

        let amount7 = Money(1340)
            .style(.abbreviation(threshold: 0))

        XCTAssertEqual(String(describing: amount7), "$1.34K")

        let amount8 = Money(132_456)
            .style(.abbreviation(threshold: 0))

        XCTAssertEqual(String(describing: amount8), "$132.46K")
    }

    func testMoneyStyles_abbreviation_fallback_removeMinorUnit() {
        let amount1 = Money(120.30)
            .style(.abbreviation(threshold: 0, fallback: .removeMinorUnit))

        XCTAssertEqual(String(describing: amount1), "$120")

        let amount2 = Money(987)
            .style(.abbreviation(threshold: 0, fallback: .removeMinorUnit))

        XCTAssertEqual(String(describing: amount2), "$987")

        let amount3 = Money(1200)
            .style(.abbreviation(threshold: 0, fallback: .removeMinorUnit))

        XCTAssertEqual(String(describing: amount3), "$1.2K")

        let amount4 = Money(12000)
            .style(.abbreviation(threshold: 0, fallback: .removeMinorUnit))

        XCTAssertEqual(String(describing: amount4), "$12K")

        let amount5 = Money(120_000)
            .style(.abbreviation(threshold: 0, fallback: .removeMinorUnit))

        XCTAssertEqual(String(describing: amount5), "$120K")

        let amount6 = Money(1_200_000)
            .style(.abbreviation(threshold: 0, fallback: .removeMinorUnit))

        XCTAssertEqual(String(describing: amount6), "$1.2M")

        let amount7 = Money(1340)
            .style(.abbreviation(threshold: 0, fallback: .removeMinorUnit))

        XCTAssertEqual(String(describing: amount7), "$1.34K")

        let amount8 = Money(132_456)
            .style(.abbreviation(threshold: 0, fallback: .removeMinorUnit))

        XCTAssertEqual(String(describing: amount8), "$132.46K")
    }

    func testCalculatePrecision() {
        XCTAssertEqual(Money(1).fractionLengthForAmount().string(), "$1.00")
        XCTAssertEqual(Money(1.234).fractionLengthForAmount().string(), "$1.23")
        XCTAssertEqual(Money(1.000031).fractionLengthForAmount().string(), "$1.00")
        XCTAssertEqual(Money(0.000031).fractionLengthForAmount().string(), "$0.000031")
        XCTAssertEqual(Money(0.00001).fractionLengthForAmount().string(), "$0.00001")
        XCTAssertEqual(Money(0.000010000).fractionLengthForAmount().string(), "$0.00001")
        XCTAssertEqual(Money(0.000012).fractionLengthForAmount().string(), "$0.000012")
        XCTAssertEqual(Money(0.00001243).fractionLengthForAmount().string(), "$0.000012")
        XCTAssertEqual(Money(0.00001253).fractionLengthForAmount().string(), "$0.000013")
        XCTAssertEqual(Money(0.00001283).fractionLengthForAmount().string(), "$0.000013")
        XCTAssertEqual(Money(0.000000138).fractionLengthForAmount().string(), "$0.00000014")
    }
}
