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

        XCTAssert(String(describing: amount1) == "$120.30")

        let amount2 = Money(120)
             .style(.default)

        XCTAssert(String(describing: amount2) == "$120.00")

        let amount3 = Money(-120)
             .style(.default)

        XCTAssert(String(describing: amount3) == "$120.00")
    }

    func testMoneyStyles_removeMinorUnit() {
        let amount = Money(120.30)
             .style(.removeMinorUnit)

        XCTAssert(String(describing: amount) == "$120")
    }

    func testMoneyStyles_removeMinorUnitIfZero() {
        let amount1 = Money(120.30)
             .style(.removeMinorUnitIfZero)

        XCTAssert(String(describing: amount1) == "$120.30")

        let amount2 = Money(120.00)
             .style(.removeMinorUnitIfZero)

        XCTAssert(String(describing: amount2) == "$120")
    }

    func testMoneyStyles_abbreviation_fallback_default() {
        let amount1 = Money(120.30)
             .style(.abbreviation(threshold: 0))

        XCTAssert(String(describing: amount1) == "$120.30")

        let amount2 = Money(987)
             .style(.abbreviation(threshold: 0))

        XCTAssert(String(describing: amount2) == "$987.00")

        let amount3 = Money(1200)
             .style(.abbreviation(threshold: 0))

        XCTAssert(String(describing: amount3) == "$1.2K")

        let amount4 = Money(12000)
             .style(.abbreviation(threshold: 0))

        XCTAssert(String(describing: amount4) == "$12K")

        let amount5 = Money(120000)
             .style(.abbreviation(threshold: 0))

        XCTAssert(String(describing: amount5) == "$120K")

        let amount6 = Money(1200000)
             .style(.abbreviation(threshold: 0))

        XCTAssert(String(describing: amount6) == "$1.2M")

        let amount7 = Money(1340)
             .style(.abbreviation(threshold: 0))

        XCTAssert(String(describing: amount7) == "$1.3K")

        let amount8 = Money(132456)
             .style(.abbreviation(threshold: 0))

        XCTAssert(String(describing: amount8) == "$132.5K")
    }

    func testMoneyStyles_abbreviation_fallback_removeMinorUnit() {
        let amount1 = Money(120.30)
            .style(.abbreviation(threshold: 0, fallback: .removeMinorUnit))

        XCTAssert(String(describing: amount1) == "$120")

        let amount2 = Money(987)
             .style(.abbreviation(threshold: 0, fallback: .removeMinorUnit))

        XCTAssert(String(describing: amount2) == "$987")

        let amount3 = Money(1200)
             .style(.abbreviation(threshold: 0, fallback: .removeMinorUnit))

        XCTAssert(String(describing: amount3) == "$1.2K")

        let amount4 = Money(12000)
             .style(.abbreviation(threshold: 0, fallback: .removeMinorUnit))

        XCTAssert(String(describing: amount4) == "$12K")

        let amount5 = Money(120000)
             .style(.abbreviation(threshold: 0, fallback: .removeMinorUnit))

        XCTAssert(String(describing: amount5) == "$120K")

        let amount6 = Money(1200000)
             .style(.abbreviation(threshold: 0, fallback: .removeMinorUnit))

        XCTAssert(String(describing: amount6) == "$1.2M")

        let amount7 = Money(1340)
             .style(.abbreviation(threshold: 0, fallback: .removeMinorUnit))

        XCTAssert(String(describing: amount7) == "$1.3K")

        let amount8 = Money(132456)
             .style(.abbreviation(threshold: 0, fallback: .removeMinorUnit))

        XCTAssert(String(describing: amount8) == "$132.5K")
    }
}
