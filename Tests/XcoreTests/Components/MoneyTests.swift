//
// Xcore
// Copyright © 2017 Xcore
// MIT license, see LICENSE file for details
//

import XCTest
@testable import Xcore

final class MoneyTests: TestCase {
    override class func setUp() {
        Money.appearance().locale = .us
    }

    func testRoundingMode() {
        XCTAssertEqual(Money(0.165).formatted(), "$0.17")
        XCTAssertEqual(Money(-0.165).formatted(), "−$0.17")
    }

    func testCurrentSign() {
        // Sign: .default
        XCTAssertEqual(Money(-1200).currentSign, "−")
        XCTAssertEqual(Money(1200).currentSign, "")
        XCTAssertEqual(Money(0).currentSign, "")

        // Sign: .whenPositive
        XCTAssertEqual(Money(-1200).sign(.whenPositive).currentSign, "")
        XCTAssertEqual(Money(1200).sign(.whenPositive).currentSign, "+")
        XCTAssertEqual(Money(0).sign(.whenPositive).currentSign, "")

        // Sign: .both
        XCTAssertEqual(Money(-1200).sign(.both).currentSign, "−")
        XCTAssertEqual(Money(1200).sign(.both).currentSign, "+")
        XCTAssertEqual(Money(0).sign(.both).currentSign, "")

        // Sign: .none
        XCTAssertEqual(Money(-1200).sign(.none).currentSign, "")
        XCTAssertEqual(Money(1200).sign(.none).currentSign, "")
        XCTAssertEqual(Money(0).sign(.none).currentSign, "")

        // Sign: .emoji
        let emojiSigned = Money.Sign(positive: "✅", negative: "❌", zero: "0️⃣")
        XCTAssertEqual(Money(-1200).sign(emojiSigned).currentSign, "❌")
        XCTAssertEqual(Money(1200).sign(emojiSigned).currentSign, "✅")
        XCTAssertEqual(Money(0).sign(emojiSigned).currentSign, "0️⃣")
    }

    func testDefault() {
        XCTAssertEqual(String(describing: Money(1200.30)), "$1,200.30")
        XCTAssertEqual(String(describing: Money(1200)), "$1,200.00")
        XCTAssertEqual(String(describing: Money(-1200)), "−$1,200.00")

        let amount4 = Money(-1200)
            .style(.default)
            .sign(.default)

        XCTAssertEqual(String(describing: amount4), "−$1,200.00")
        XCTAssertEqual(Money(-1200).formatted(), "−$1,200.00")
        XCTAssertEqual(String(describing: Money(0)), "$0.00")
    }

    func testSigned_both() {
        // Sign for positive value
        let amount1 = Money(1200)
            .sign(.both)

        XCTAssertEqual(String(describing: amount1), "+$1,200.00")

        // Sign for negative value
        let amount2 = Money(-1200)
            .sign(.both)

        XCTAssertEqual(String(describing: amount2), "−$1,200.00")

        // Sign for zero value
        let amount3 = Money(0)
            .sign(.both)

        XCTAssertEqual(String(describing: amount3), "$0.00")
    }

    func testSigned_whenPositive() {
        let amount1 = Money(0)
            .sign(.whenPositive)

        XCTAssertEqual(String(describing: amount1), "$0.00")

        let amount2 = Money(1200.30)
            .sign(.whenPositive)

        XCTAssertEqual(String(describing: amount2), "+$1,200.30")

        let amount3 = Money(-1200.30)
            .sign(.whenPositive)

        XCTAssertEqual(String(describing: amount3), "$1,200.30")
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
        let amount = Money(1200.30)
            .style(.removeMinorUnit)

        XCTAssertEqual(String(describing: amount), "$1,200")
    }

    func testStyle_removeMinorUnitIfZero() {
        let amount1 = Money(1200.30)
            .style(.removeMinorUnitIfZero)

        XCTAssertEqual(String(describing: amount1), "$1,200.30")

        let amount2 = Money(120.00)
            .style(.removeMinorUnitIfZero)

        XCTAssertEqual(String(describing: amount2), "$120")

        let amount3 = Money(1200)
            .style(.removeMinorUnitIfZero)

        XCTAssertEqual(String(describing: amount3), "$1,200")

        let amount4 = Money(1234.567)
            .style(.removeMinorUnitIfZero)

        XCTAssertEqual(String(describing: amount4), "$1,234.57")
    }

    func testStyle_abbreviated_fallback_default() {
        let amount1 = Money(120.30)
            .style(.abbreviated)

        XCTAssertEqual(String(describing: amount1), "$120.30")

        let amount2 = Money(987)
            .style(.abbreviated)

        XCTAssertEqual(String(describing: amount2), "$987.00")

        let amount3 = Money(1200)
            .style(.abbreviated)

        XCTAssertEqual(String(describing: amount3), "$1.2K")

        let amount4 = Money(12000)
            .style(.abbreviated)

        XCTAssertEqual(String(describing: amount4), "$12K")

        let amount5 = Money(120_000)
            .style(.abbreviated)

        XCTAssertEqual(String(describing: amount5), "$120K")

        let amount6 = Money(1_200_000)
            .style(.abbreviated)

        XCTAssertEqual(String(describing: amount6), "$1.2M")

        let amount7 = Money(1340)
            .style(.abbreviated)

        XCTAssertEqual(String(describing: amount7), "$1.34K")

        let amount8 = Money(132_456)
            .style(.abbreviated)

        XCTAssertEqual(String(describing: amount8), "$132.46K")

        let amount9 = Money(1200)
            .style(.abbreviated(threshold: 1_201))

        XCTAssertEqual(String(describing: amount9), "$1,200.00")

        let amount10 = Money(1200)
            .style(.abbreviated(threshold: 1_200))

        XCTAssertEqual(String(describing: amount10), "$1.2K")

        let amount11 = Money(-1200)
            .style(.abbreviated(threshold: 1_200))

        XCTAssertEqual(String(describing: amount11), "−$1.2K")

        let amount12 = Money(1200)
            .style(.abbreviated(threshold: 1_200))
            .sign(.both)

        XCTAssertEqual(String(describing: amount12), "+$1.2K")

        let amount13 = Money(-1200)
            .style(.abbreviated(threshold: 1_200))
            .sign(.whenPositive)

        XCTAssertEqual(String(describing: amount13), "$1.2K")
    }

    func testStyle_abbreviated_fallback_removeMinorUnit() {
        let amount1 = Money(120.30)
            .style(.abbreviated(threshold: 0, fallback: .removeMinorUnit))

        XCTAssertEqual(String(describing: amount1), "$120")

        let amount2 = Money(987)
            .style(.abbreviated(threshold: 0, fallback: .removeMinorUnit))

        XCTAssertEqual(String(describing: amount2), "$987")

        let amount3 = Money(1200)
            .style(.abbreviated(threshold: 0, fallback: .removeMinorUnit))

        XCTAssertEqual(String(describing: amount3), "$1.2K")

        let amount4 = Money(12000)
            .style(.abbreviated(threshold: 0, fallback: .removeMinorUnit))

        XCTAssertEqual(String(describing: amount4), "$12K")

        let amount5 = Money(120_000)
            .style(.abbreviated(threshold: 0, fallback: .removeMinorUnit))

        XCTAssertEqual(String(describing: amount5), "$120K")

        let amount6 = Money(1_200_000)
            .style(.abbreviated(threshold: 0, fallback: .removeMinorUnit))

        XCTAssertEqual(String(describing: amount6), "$1.2M")

        let amount7 = Money(1340)
            .style(.abbreviated(threshold: 0, fallback: .removeMinorUnit))

        XCTAssertEqual(String(describing: amount7), "$1.34K")

        let amount8 = Money(132_456)
            .style(.abbreviated(threshold: 0, fallback: .removeMinorUnit))

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
        let amount1 = Money(1200.30)
            .currencySymbol("BTC", position: .suffix)

        XCTAssertEqual(String(describing: amount1), "1,200.30 BTC")

        let amount2 = Money(120)
            .currencySymbol("BTC", position: .suffix)

        XCTAssertEqual(String(describing: amount2), "120.00 BTC")

        let amount3 = Money(-120)
            .currencySymbol("BTC", position: .suffix)

        XCTAssertEqual(String(describing: amount3), "−120.00 BTC")

        let amount4 = Money(-120)
            .currencySymbol("ETH", position: .suffix)
            .style(.default)
            .sign(.default)

        XCTAssertEqual(String(describing: amount4), "−120.00 ETH")

        let amount5 = Money(-120)
            .currencySymbol("BTC", position: .suffix)
        XCTAssertEqual(amount5.formatted(), "−120.00 BTC")
    }

    func testCustomCurrencySymbol_before() {
        let amount = Money(-1200.30)
            .currencySymbol("BTC", position: .prefix)

        XCTAssertEqual(String(describing: amount), "−BTC1,200.30")
    }

    func testCustomCurrencySymbol_before_custom() {
        let customStyle = Money.Style(
            id: "custom",
            format: {
                let components = $0.components()

                let amount = [components.majorUnit, components.minorUnit]
                    .joined(separator: $0.decimalSeparator)

                let sign = $0.currentSign

                switch $0.currencySymbolPosition {
                    case .prefix:
                        return "\($0.currencySymbol) \(sign)\(amount)"
                    case .suffix:
                        return "\(sign)\(amount) \($0.currencySymbol)"
                }
            },
            range: \.ranges
        )

        let amount1 = Money(1200.30)
            .currencySymbol("₿", position: .prefix)
            .style(customStyle)

        XCTAssertEqual(String(describing: amount1), "₿ 1,200.30")

        let amount2 = Money(-1200.30)
            .currencySymbol("BTC", position: .prefix)
            .style(customStyle)

        XCTAssertEqual(String(describing: amount2), "BTC −1,200.30")
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

    func testEdgeCaseNumbers() {
        XCTAssertEqual(Money(Decimal(string: "20.05588"))?.formatted(), "$20.06")
        XCTAssertEqual(Money(Decimal(string: "5.04198"))?.formatted(), "$5.04")
        XCTAssertEqual(Money(5.04198).formatted(), "$5.04")

        XCTAssertEqual(Money(Decimal(string: "20.05588"))?.fractionLength(.maxFractionDigits).formatted(), "$20.05588")
        XCTAssertEqual(Money(Decimal(string: "5.04198"))?.fractionLength(.maxFractionDigits).formatted(), "$5.04198")
        XCTAssertEqual(Money(5.04198).fractionLength(.maxFractionDigits).formatted(), "$5.041979999999998976")
    }
}

// MARK: - Locale

extension MoneyTests {
    /// Tests different language / region formatting.
    func testLocale() {
        // US - Default
        XCTAssertEqual(Money(-1000.0).locale(.us).formatted(), "−$1,000.00")
        XCTAssertEqual(Money(-1.0).locale(.us).formatted(), "−$1.00")
        XCTAssertEqual(Money(0.0).locale(.us).formatted(), "$0.00")
        XCTAssertEqual(Money(1.0).locale(.us).formatted(), "$1.00")
        XCTAssertEqual(Money(1000.0).locale(.us).formatted(), "$1,000.00")

        // India - Hindi
        XCTAssertEqual(Money(-1000.0).locale(.indiaHindi).formatted(), "−$1,000.00")
        XCTAssertEqual(Money(-1.0).locale(.indiaHindi).formatted(), "−$1.00")
        XCTAssertEqual(Money(0.0).locale(.indiaHindi).formatted(), "$0.00")
        XCTAssertEqual(Money(1.0).locale(.indiaHindi).formatted(), "$1.00")
        XCTAssertEqual(Money(1000.0).locale(.indiaHindi).formatted(), "$1,000.00")

        // India - Sanskrit
        XCTAssertEqual(Money(-1000.0).locale(.indiaSanskrit).formatted(), "−$१,०००.००")
        XCTAssertEqual(Money(-1.0).locale(.indiaSanskrit).formatted(), "−$१.००")
        XCTAssertEqual(Money(0.0).locale(.indiaSanskrit).formatted(), "$०.००")
        XCTAssertEqual(Money(1.0).locale(.indiaSanskrit).formatted(), "$१.००")
        XCTAssertEqual(Money(1000.0).locale(.indiaSanskrit).formatted(), "$१,०००.००")

        // Puerto Rico
        XCTAssertEqual(Money(-1000.0).locale(.puertoRico).formatted(), "−$1,000.00")
        XCTAssertEqual(Money(-10000.0).locale(.puertoRico).formatted(), "−$10,000.00")
        XCTAssertEqual(Money(-1.0).locale(.puertoRico).formatted(), "−$1.00")
        XCTAssertEqual(Money(0.0).locale(.puertoRico).formatted(), "$0.00")
        XCTAssertEqual(Money(1.0).locale(.puertoRico).formatted(), "$1.00")
        XCTAssertEqual(Money(1000.0).locale(.puertoRico).formatted(), "$1,000.00")

        // China
        XCTAssertEqual(Money(-1000.0).locale(.china).formatted(), "−$1,000.00")
        XCTAssertEqual(Money(-1.0).locale(.china).formatted(), "−$1.00")
        XCTAssertEqual(Money(0.0).locale(.china).formatted(), "$0.00")
        XCTAssertEqual(Money(1.0).locale(.china).formatted(), "$1.00")
        XCTAssertEqual(Money(1000.0).locale(.china).formatted(), "$1,000.00")

        // Canada - Fr
        XCTAssertEqual(Money(-1000.0).locale(.canadaFr).formatted(), "−$1 000,00")
        XCTAssertEqual(Money(-1.0).locale(.canadaFr).formatted(), "−$1,00")
        XCTAssertEqual(Money(0.0).locale(.canadaFr).formatted(), "$0,00")
        XCTAssertEqual(Money(1.0).locale(.canadaFr).formatted(), "$1,00")
        XCTAssertEqual(Money(1000.0).locale(.canadaFr).formatted(), "$1 000,00")

        // Canada - En
        XCTAssertEqual(Money(-1000.0).locale(.canadaEn).formatted(), "−$1,000.00")
        XCTAssertEqual(Money(-1.0).locale(.canadaEn).formatted(), "−$1.00")
        XCTAssertEqual(Money(0.0).locale(.canadaEn).formatted(), "$0.00")
        XCTAssertEqual(Money(1.0).locale(.canadaEn).formatted(), "$1.00")
        XCTAssertEqual(Money(1000.0).locale(.canadaEn).formatted(), "$1,000.00")

        // UK
        XCTAssertEqual(Money(-1000.0).locale(.uk).formatted(), "−$1,000.00")
        XCTAssertEqual(Money(-1.0).locale(.uk).formatted(), "−$1.00")
        XCTAssertEqual(Money(0.0).locale(.uk).formatted(), "$0.00")
        XCTAssertEqual(Money(1.0).locale(.uk).formatted(), "$1.00")
        XCTAssertEqual(Money(1000.0).locale(.uk).formatted(), "$1,000.00")

        // Mexico
        XCTAssertEqual(Money(-1000.0).locale(.mexico).formatted(), "−$1,000.00")
        XCTAssertEqual(Money(-10000.0).locale(.mexico).formatted(), "−$10,000.00")
        XCTAssertEqual(Money(-1.0).locale(.mexico).formatted(), "−$1.00")
        XCTAssertEqual(Money(0.0).locale(.mexico).formatted(), "$0.00")
        XCTAssertEqual(Money(1.0).locale(.mexico).formatted(), "$1.00")
        XCTAssertEqual(Money(1000.0).locale(.mexico).formatted(), "$1,000.00")

        // Brazil
        XCTAssertEqual(Money(-1000.0).locale(.brazil).formatted(), "−$1.000,00")
        XCTAssertEqual(Money(-1.0).locale(.brazil).formatted(), "−$1,00")
        XCTAssertEqual(Money(0.0).locale(.brazil).formatted(), "$0,00")
        XCTAssertEqual(Money(1.0).locale(.brazil).formatted(), "$1,00")
        XCTAssertEqual(Money(1000.0).locale(.brazil).formatted(), "$1.000,00")

        // Portugal
        XCTAssertEqual(Money(-1000.0).locale(.portugal).formatted(), "−$1000,00")
        XCTAssertEqual(Money(-1.0).locale(.portugal).formatted(), "−$1,00")
        XCTAssertEqual(Money(0.0).locale(.portugal).formatted(), "$0,00")
        XCTAssertEqual(Money(1.0).locale(.portugal).formatted(), "$1,00")
        XCTAssertEqual(Money(1000.0).locale(.portugal).formatted(), "$1000,00")

        // Germany
        XCTAssertEqual(Money(-1000.0).locale(.germany).formatted(), "−$1.000,00")
        XCTAssertEqual(Money(-1.0).locale(.germany).formatted(), "−$1,00")
        XCTAssertEqual(Money(0.0).locale(.germany).formatted(), "$0,00")
        XCTAssertEqual(Money(1.0).locale(.germany).formatted(), "$1,00")
        XCTAssertEqual(Money(1000.0).locale(.germany).formatted(), "$1.000,00")

        // Japan
        XCTAssertEqual(Money(-1000.0).locale(.japan).formatted(), "−$1,000.00")
        XCTAssertEqual(Money(-1.0).locale(.japan).formatted(), "−$1.00")
        XCTAssertEqual(Money(0.0).locale(.japan).formatted(), "$0.00")
        XCTAssertEqual(Money(1.0).locale(.japan).formatted(), "$1.00")
        XCTAssertEqual(Money(1000.0).locale(.japan).formatted(), "$1,000.00")

        // Pakistan - Urdu
        XCTAssertEqual(Money(-1000.0).locale(.pakistanUrdu).formatted(), "−$1,000.00")
        XCTAssertEqual(Money(-1.0).locale(.pakistanUrdu).formatted(), "−$1.00")
        XCTAssertEqual(Money(0.0).locale(.pakistanUrdu).formatted(), "$0.00")
        XCTAssertEqual(Money(1.0).locale(.pakistanUrdu).formatted(), "$1.00")
        XCTAssertEqual(Money(1000.0).locale(.pakistanUrdu).formatted(), "$1,000.00")

        // Pakistan - Punjabi
        XCTAssertEqual(Money(-1000.0).locale(.pakistanPunjabi).formatted(), "−$۱٬۰۰۰٫۰۰")
        XCTAssertEqual(Money(-1.0).locale(.pakistanPunjabi).formatted(), "−$۱٫۰۰")
        XCTAssertEqual(Money(0.0).locale(.pakistanPunjabi).formatted(), "$۰٫۰۰")
        XCTAssertEqual(Money(1.0).locale(.pakistanPunjabi).formatted(), "$۱٫۰۰")
        XCTAssertEqual(Money(1000.0).locale(.pakistanPunjabi).formatted(), "$۱٬۰۰۰٫۰۰")

        // Switzerland
        XCTAssertEqual(Money(-1000.0).locale(.switzerland).formatted(), "−$1’000.00")
        XCTAssertEqual(Money(-1.0).locale(.switzerland).formatted(), "−$1.00")
        XCTAssertEqual(Money(0.0).locale(.switzerland).formatted(), "$0.00")
        XCTAssertEqual(Money(1.0).locale(.switzerland).formatted(), "$1.00")
        XCTAssertEqual(Money(1000.0).locale(.switzerland).formatted(), "$1’000.00")

        // Ireland
        XCTAssertEqual(Money(-1000.0).locale(.ireland).formatted(), "−$1,000.00")
        XCTAssertEqual(Money(-1.0).locale(.ireland).formatted(), "−$1.00")
        XCTAssertEqual(Money(0.0).locale(.ireland).formatted(), "$0.00")
        XCTAssertEqual(Money(1.0).locale(.ireland).formatted(), "$1.00")
        XCTAssertEqual(Money(1000.0).locale(.ireland).formatted(), "$1,000.00")

        // Indonesia
        XCTAssertEqual(Money(-1000.0).locale(.indonesia).formatted(), "−$1.000,00")
        XCTAssertEqual(Money(-1.0).locale(.indonesia).formatted(), "−$1,00")
        XCTAssertEqual(Money(0.0).locale(.indonesia).formatted(), "$0,00")
        XCTAssertEqual(Money(1.0).locale(.indonesia).formatted(), "$1,00")
        XCTAssertEqual(Money(1000.0).locale(.indonesia).formatted(), "$1.000,00")
    }
}

// MARK: - Helpers

extension Locale {
    fileprivate static let indiaHindi = Locale(identifier: "hi_IN")
    fileprivate static let indiaSanskrit = Locale(identifier: "sa_IN")
    fileprivate static let puertoRico = Locale(identifier: "es_PR")
    fileprivate static let china = Locale(identifier: "zh_Hans_CN")
    fileprivate static let canadaFr = Locale(identifier: "fr_CA")
    fileprivate static let canadaEn = Locale(identifier: "en_CA")
    fileprivate static let mexico = Locale(identifier: "es_MX")
    fileprivate static let portugal = Locale(identifier: "pt_PT")
    fileprivate static let brazil = Locale(identifier: "pt_BR")
    fileprivate static let germany = Locale(identifier: "de_DE")

    /// No fractional numbers: 55.00 -> 55
    fileprivate static let japan = Locale(identifier: "ja_JP")

    // Extra countries with different decimal separators
    // - Source: https://en.wikipedia.org/wiki/Decimal_mark

    fileprivate static let pakistanUrdu = Locale(identifier: "ur_PK")
    fileprivate static let pakistanPunjabi = Locale(identifier: "pa_Arab_PK")
    fileprivate static let switzerland = Locale(identifier: "gsw_CH")
    fileprivate static let ireland = Locale(identifier: "ga_IE")
    fileprivate static let indonesia = Locale(identifier: "id_ID")
}
