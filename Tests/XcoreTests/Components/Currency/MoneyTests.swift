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

    func testDefault() {
        XCTAssertEqual(String(describing: Money(120.30)), "$120.30")
        XCTAssertEqual(String(describing: Money(120)), "$120.00")
        XCTAssertEqual(String(describing: Money(-120)), "−$120.00")

        let amount4 = Money(-120)
            .style(.default)
            .sign(.default)

        XCTAssertEqual(String(describing: amount4), "−$120.00")
        XCTAssertEqual(Money(-120).formatted(), "−$120.00")
        XCTAssertEqual(String(describing: Money(0)), "$0.00")
    }

    func testSigned_both() {
        // Sign for positive value
        let amount1 = Money(120)
            .sign(.both)

        XCTAssertEqual(String(describing: amount1), "+$120.00")

        // Sign for negative value
        let amount2 = Money(-120)
            .sign(.both)

        XCTAssertEqual(String(describing: amount2), "−$120.00")

        // Sign for zero value
        let amount3 = Money(0)
            .sign(.both)

        XCTAssertEqual(String(describing: amount3), "$0.00")
    }

    func testSigned_whenPositive() {
        let amount1 = Money(0)
            .sign(.whenPositive)

        XCTAssertEqual(String(describing: amount1), "$0.00")

        let amount2 = Money(120.30)
            .sign(.whenPositive)

        XCTAssertEqual(String(describing: amount2), "+$120.30")

        let amount3 = Money(-120.30)
            .sign(.whenPositive)

        XCTAssertEqual(String(describing: amount3), "$120.30")
    }

    func testSigned_custom() {
        let emojiSigned = Money.Sign(positive: "✅", negative: "❌", zero: "0️⃣")

        let amount1 = Money(0)
            .sign(emojiSigned)

        XCTAssertEqual(String(describing: amount1), "0️⃣$0.00")

        let amount2 = Money(120.30)
            .sign(emojiSigned)

        XCTAssertEqual(String(describing: amount2), "✅$120.30")

        let amount3 = Money(-120.30)
            .sign(emojiSigned)

        XCTAssertEqual(String(describing: amount3), "❌$120.30")

        let amount4 = Money(0)
            .zeroString("--")
            .sign(emojiSigned)

        XCTAssertEqual(String(describing: amount4), "--")
    }

    func testStyle_removeMinorUnit() {
        let amount = Money(120.30)
            .style(.removeMinorUnit)

        XCTAssertEqual(String(describing: amount), "$120")
    }

    func testStyle_removeMinorUnitIfZero() {
        let amount1 = Money(120.30)
            .style(.removeMinorUnitIfZero)

        XCTAssertEqual(String(describing: amount1), "$120.30")

        let amount2 = Money(120.00)
            .style(.removeMinorUnitIfZero)

        XCTAssertEqual(String(describing: amount2), "$120")
    }

    func testStyle_abbreviate_fallback_default() {
        let amount1 = Money(120.30)
            .style(.abbreviate(threshold: 0))

        XCTAssertEqual(String(describing: amount1), "$120.30")

        let amount2 = Money(987)
            .style(.abbreviate(threshold: 0))

        XCTAssertEqual(String(describing: amount2), "$987.00")

        let amount3 = Money(1200)
            .style(.abbreviate(threshold: 0))

        XCTAssertEqual(String(describing: amount3), "$1.2K")

        let amount4 = Money(12000)
            .style(.abbreviate(threshold: 0))

        XCTAssertEqual(String(describing: amount4), "$12K")

        let amount5 = Money(120_000)
            .style(.abbreviate(threshold: 0))

        XCTAssertEqual(String(describing: amount5), "$120K")

        let amount6 = Money(1_200_000)
            .style(.abbreviate(threshold: 0))

        XCTAssertEqual(String(describing: amount6), "$1.2M")

        let amount7 = Money(1340)
            .style(.abbreviate(threshold: 0))

        XCTAssertEqual(String(describing: amount7), "$1.34K")

        let amount8 = Money(132_456)
            .style(.abbreviate(threshold: 0))

        XCTAssertEqual(String(describing: amount8), "$132.46K")
    }

    func testStyle_abbreviate_fallback_removeMinorUnit() {
        let amount1 = Money(120.30)
            .style(.abbreviate(threshold: 0, fallback: .removeMinorUnit))

        XCTAssertEqual(String(describing: amount1), "$120")

        let amount2 = Money(987)
            .style(.abbreviate(threshold: 0, fallback: .removeMinorUnit))

        XCTAssertEqual(String(describing: amount2), "$987")

        let amount3 = Money(1200)
            .style(.abbreviate(threshold: 0, fallback: .removeMinorUnit))

        XCTAssertEqual(String(describing: amount3), "$1.2K")

        let amount4 = Money(12000)
            .style(.abbreviate(threshold: 0, fallback: .removeMinorUnit))

        XCTAssertEqual(String(describing: amount4), "$12K")

        let amount5 = Money(120_000)
            .style(.abbreviate(threshold: 0, fallback: .removeMinorUnit))

        XCTAssertEqual(String(describing: amount5), "$120K")

        let amount6 = Money(1_200_000)
            .style(.abbreviate(threshold: 0, fallback: .removeMinorUnit))

        XCTAssertEqual(String(describing: amount6), "$1.2M")

        let amount7 = Money(1340)
            .style(.abbreviate(threshold: 0, fallback: .removeMinorUnit))

        XCTAssertEqual(String(describing: amount7), "$1.34K")

        let amount8 = Money(132_456)
            .style(.abbreviate(threshold: 0, fallback: .removeMinorUnit))

        XCTAssertEqual(String(describing: amount8), "$132.46K")
    }

    func testFractionLength_default() {
        XCTAssertEqual(Money(1).formatted(), "$1.00")
        XCTAssertEqual(Money(1.234).formatted(), "$1.23")
        XCTAssertEqual(Money(1.000031).formatted(), "$1.00")
        XCTAssertEqual(Money(0.000031).formatted(), "$0.000031")
        XCTAssertEqual(Money(0.00001).formatted(), "$0.00001")
        XCTAssertEqual(Money(0.000010000).formatted(), "$0.00001")
        XCTAssertEqual(Money(0.000012).formatted(), "$0.000012")
        XCTAssertEqual(Money(0.00001243).formatted(), "$0.000012")
        XCTAssertEqual(Money(0.00001253).formatted(), "$0.000013")
        XCTAssertEqual(Money(0.00001283).formatted(), "$0.000013")
        XCTAssertEqual(Money(0.000000138).formatted(), "$0.00000014")
        XCTAssertEqual(Money(-0.000000138).formatted(), "−$0.00000014")
    }

    func testCustomCurrencySymbol_after() {
        let formatter = CurrencyFormatter().apply {
            $0.currencySymbol = "BTC"
            $0.currencySymbolPosition = .suffix
        }

        let amount1 = Money(120.30)
            .formatter(formatter)

        XCTAssertEqual(String(describing: amount1), "120.30 BTC")

        let amount2 = Money(120)
            .formatter(formatter)

        XCTAssertEqual(String(describing: amount2), "120.00 BTC")

        let amount3 = Money(-120)
            .formatter(formatter)

        XCTAssertEqual(String(describing: amount3), "−120.00 BTC")

        let amount4 = Money(-120)
            .formatter(formatter)
            .style(.default)
            .sign(.default)

        XCTAssertEqual(String(describing: amount4), "−120.00 BTC")

        let amount5 = Money(-120)
            .formatter(formatter)
        XCTAssertEqual(amount5.formatted(), "−120.00 BTC")
    }

    func testCustomCurrencySymbol_before() {
        let formatter = CurrencyFormatter().apply {
            $0.currencySymbol = "BTC"
        }

        let amount = Money(-120.30)
            .formatter(formatter)

        XCTAssertEqual(String(describing: amount), "−BTC120.30")
    }

    func testCustomCurrencySymbol_before_custom() {
        let formatter = CurrencyFormatter()

        let customStyle = Money.Components.Style(
            id: "custom",
            format: {
                let amount = [$0.majorUnit, $0.minorUnit]
                    .joined(separator: $0.formatter.decimalSeparator)

                let sign = $0.amount > 0 ? $0.sign.positive : $0.sign.negative

                switch $0.formatter.currencySymbolPosition {
                    case .prefix:
                        return "\($0.formatter.currencySymbol) \(sign)\(amount)"
                    case .suffix:
                        return "\(sign)\(amount) \($0.formatter.currencySymbol)"
                }
            },
            range: \.ranges
        )

        let amount1 = Money(120.30)
            .formatter(formatter.apply { $0.currencySymbol = "₿" })
            .style(customStyle)

        XCTAssertEqual(String(describing: amount1), "₿ 120.30")

        let amount2 = Money(-120.30)
            .formatter(formatter.apply { $0.currencySymbol = "BTC" })
            .style(customStyle)

        XCTAssertEqual(String(describing: amount2), "BTC −120.30")
    }

    func testZeroString() {
        let amount1 = Money(0)
            .zeroString("--")
            .formatted(format: "%@ per month")

        XCTAssertEqual(amount1, "--")

        let amount2 = Money(0)
            .zeroString("oops")
            .formatted(format: "%@ per month")

        XCTAssertEqual(amount2, "oops")

        let amount3 = Money(9.99)
            .zeroString("--")
            .formatted(format: "%@ per month")

        XCTAssertEqual(amount3, "$9.99 per month")

        let amount4 = Money(-9.99)
            .style(.default)
            .zeroString("oops")
            .formatted(format: "%@ per month")

        XCTAssertEqual(amount4, "−$9.99 per month")

        let amount5 = Money(0)
            .zeroString(nil)
            .formatted(format: "%@ per month")

        XCTAssertEqual(amount5, "$0.00 per month")
    }
}
