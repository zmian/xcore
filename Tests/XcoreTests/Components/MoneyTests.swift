//
// Xcore
// Copyright © 2017 Xcore
// MIT license, see LICENSE file for details
//
// swiftlint:disable empty_string

import Testing
import Foundation
@testable import Xcore

struct MoneyTests {
    init() {
        Money.appearance().locale = .us
    }

    @Test
    func roundingMode() {
        #expect(Money(0.165).formatted() == "$0.17")
        #expect(Money(-0.165).formatted() == "−$0.17")
    }

    @Test
    func currentSign() {
        // signSymbols: .default
        #expect(Money(-1200).sign == "−")
        #expect(Money(1200).sign == "")
        #expect(Money(0).sign == "")

        // signSymbols: .whenPositive
        #expect(Money(-1200).signSymbols(.whenPositive).sign == "")
        #expect(Money(1200).signSymbols(.whenPositive).sign == "+")
        #expect(Money(0).signSymbols(.whenPositive).sign == "")

        // signSymbols: .both
        #expect(Money(-1200).signSymbols(.both).sign == "−")
        #expect(Money(1200).signSymbols(.both).sign == "+")
        #expect(Money(0).signSymbols(.both).sign == "")

        // signSymbols: .none
        #expect(Money(-1200).signSymbols(.none).sign == "")
        #expect(Money(1200).signSymbols(.none).sign == "")
        #expect(Money(0).signSymbols(.none).sign == "")

        // signSymbols: .emoji
        let emojiSigned = Money.SignSymbols(positive: "✅", negative: "❌", zero: "0️⃣")
        #expect(Money(-1200).signSymbols(emojiSigned).sign == "❌")
        #expect(Money(1200).signSymbols(emojiSigned).sign == "✅")
        #expect(Money(0).signSymbols(emojiSigned).sign == "0️⃣")
    }

    @Test
    func defaults() {
        #expect(String(describing: Money(1200.30)) == "$1,200.30")
        #expect(String(describing: Money(1200)) == "$1,200.00")
        #expect(String(describing: Money(-1200)) == "−$1,200.00")

        let amount4 = Money(-1200)
            .style(.default)
            .signSymbols(.default)

        #expect(String(describing: amount4) == "−$1,200.00")
        #expect(Money(-1200).formatted() == "−$1,200.00")
        #expect(String(describing: Money(0)) == "$0.00")
    }

    @Test
    func signed_both() {
        // Sign for positive value
        let amount1 = Money(1200)
            .signSymbols(.both)

        #expect(String(describing: amount1) == "+$1,200.00")

        // Sign for negative value
        let amount2 = Money(-1200)
            .signSymbols(.both)

        #expect(String(describing: amount2) == "−$1,200.00")

        // Sign for zero value
        let amount3 = Money(0)
            .signSymbols(.both)

        #expect(String(describing: amount3) == "$0.00")
    }

    @Test
    func signed_whenPositive() {
        let amount1 = Money(0)
            .signSymbols(.whenPositive)

        #expect(String(describing: amount1) == "$0.00")

        let amount2 = Money(1200.30)
            .signSymbols(.whenPositive)

        #expect(String(describing: amount2) == "+$1,200.30")

        let amount3 = Money(-1200.30)
            .signSymbols(.whenPositive)

        #expect(String(describing: amount3) == "$1,200.30")
    }

    @Test
    func signed_custom() {
        let emojiSigned = Money.SignSymbols(positive: "✅", negative: "❌", zero: "0️⃣")

        let amount1 = Money(0)
            .signSymbols(emojiSigned)

        #expect(String(describing: amount1) == "0️⃣$0.00")

        let amount2 = Money(120.30)
            .signSymbols(emojiSigned)

        #expect(String(describing: amount2) == "✅$120.30")

        let amount3 = Money(-120.30)
            .signSymbols(emojiSigned)

        #expect(String(describing: amount3) == "❌$120.30")

        let amount4 = Money(0)
            .zeroString("--")
            .signSymbols(emojiSigned)

        #expect(String(describing: amount4) == "--")
    }

    @Test
    func style_removeMinorUnit() {
        let amount = Money(1200.30)
            .style(.removeMinorUnit)

        #expect(String(describing: amount) == "$1,200")
    }

    @Test
    func style_removeMinorUnitIfZero() {
        let amount1 = Money(1200.30)
            .style(.removeMinorUnitIfZero)

        #expect(String(describing: amount1) == "$1,200.30")

        let amount2 = Money(120.00)
            .style(.removeMinorUnitIfZero)

        #expect(String(describing: amount2) == "$120")

        let amount3 = Money(1200)
            .style(.removeMinorUnitIfZero)

        #expect(String(describing: amount3) == "$1,200")

        let amount4 = Money(1234.567)
            .style(.removeMinorUnitIfZero)

        #expect(String(describing: amount4) == "$1,234.57")
    }

    @Test
    func style_abbreviated_fallback_default() {
        let amount1 = Money(120.30)
            .style(.abbreviated)

        #expect(String(describing: amount1) == "$120.30")

        let amount2 = Money(987)
            .style(.abbreviated)

        #expect(String(describing: amount2) == "$987.00")

        let amount3 = Money(1200)
            .style(.abbreviated)

        #expect(String(describing: amount3) == "$1.2K")

        let amount4 = Money(12000)
            .style(.abbreviated)

        #expect(String(describing: amount4) == "$12K")

        let amount5 = Money(120_000)
            .style(.abbreviated)

        #expect(String(describing: amount5) == "$120K")

        let amount6 = Money(1_200_000)
            .style(.abbreviated)

        #expect(String(describing: amount6) == "$1.2M")

        let amount7 = Money(1340)
            .style(.abbreviated)

        #expect(String(describing: amount7) == "$1.34K")

        let amount8 = Money(132_456)
            .style(.abbreviated)

        #expect(String(describing: amount8) == "$132.46K")

        let amount9 = Money(1200)
            .style(.abbreviated(threshold: 1201))

        #expect(String(describing: amount9) == "$1,200.00")

        let amount10 = Money(1200)
            .style(.abbreviated(threshold: 1200))

        #expect(String(describing: amount10) == "$1.2K")

        let amount11 = Money(-1200)
            .style(.abbreviated(threshold: 1200))

        #expect(String(describing: amount11) == "−$1.2K")

        let amount12 = Money(1200)
            .style(.abbreviated(threshold: 1200))
            .signSymbols(.both)

        #expect(String(describing: amount12) == "+$1.2K")

        let amount13 = Money(-1200)
            .style(.abbreviated(threshold: 1200))
            .signSymbols(.whenPositive)

        #expect(String(describing: amount13) == "$1.2K")
    }

    @Test
    func style_abbreviated_fallback_removeMinorUnit() {
        let amount1 = Money(120.30)
            .style(.abbreviated(threshold: 0, fallback: .removeMinorUnit))

        #expect(String(describing: amount1) == "$120")

        let amount2 = Money(987)
            .style(.abbreviated(threshold: 0, fallback: .removeMinorUnit))

        #expect(String(describing: amount2) == "$987")

        let amount3 = Money(1200)
            .style(.abbreviated(threshold: 0, fallback: .removeMinorUnit))

        #expect(String(describing: amount3) == "$1.2K")

        let amount4 = Money(12000)
            .style(.abbreviated(threshold: 0, fallback: .removeMinorUnit))

        #expect(String(describing: amount4) == "$12K")

        let amount5 = Money(120_000)
            .style(.abbreviated(threshold: 0, fallback: .removeMinorUnit))

        #expect(String(describing: amount5) == "$120K")

        let amount6 = Money(1_200_000)
            .style(.abbreviated(threshold: 0, fallback: .removeMinorUnit))

        #expect(String(describing: amount6) == "$1.2M")

        let amount7 = Money(1340)
            .style(.abbreviated(threshold: 0, fallback: .removeMinorUnit))

        #expect(String(describing: amount7) == "$1.34K")

        let amount8 = Money(132_456)
            .style(.abbreviated(threshold: 0, fallback: .removeMinorUnit))

        #expect(String(describing: amount8) == "$132.46K")
    }

    @Test
    func fractionLength_default() {
        #expect(Money(1).formatted() == "$1.00")
        #expect(Money(1.234).formatted() == "$1.23")
        #expect(Money(1.000031).formatted() == "$1.00")
        #expect(Money(0.000031).formatted() == "$0.000031")
        #expect(Money(0.00001).formatted() == "$0.00001")
        #expect(Money(0.000010000).formatted() == "$0.00001")
        #expect(Money(0.000012).formatted() == "$0.000012")
        #expect(Money(0.00001243).formatted() == "$0.000012")
        #expect(Money(0.00001253).formatted() == "$0.000013")
        #expect(Money(0.00001283).formatted() == "$0.000013")
        #expect(Money(0.000000138).formatted() == "$0.00000014")
        #expect(Money(-0.000000138).formatted() == "−$0.00000014")
    }

    @Test
    func customCurrencySymbol_after() {
        let amount1 = Money(1200.30)
            .currencySymbol("BTC", position: .suffix)

        #expect(String(describing: amount1) == "1,200.30 BTC")

        let amount2 = Money(120)
            .currencySymbol("BTC", position: .suffix)

        #expect(String(describing: amount2) == "120.00 BTC")

        let amount3 = Money(-120)
            .currencySymbol("BTC", position: .suffix)

        #expect(String(describing: amount3) == "−120.00 BTC")

        let amount4 = Money(-120)
            .currencySymbol("ETH", position: .suffix)
            .style(.default)
            .signSymbols(.default)

        #expect(String(describing: amount4) == "−120.00 ETH")

        let amount5 = Money(-120)
            .currencySymbol("BTC", position: .suffix)
        #expect(amount5.formatted() == "−120.00 BTC")
    }

    @Test
    func customCurrencySymbol_before() {
        let amount = Money(-1200.30)
            .currencySymbol("BTC", position: .prefix)

        #expect(String(describing: amount) == "−BTC1,200.30")
    }

    @Test
    func customCurrencySymbol_before_custom() {
        let customStyle = Money.Style(
            id: "custom",
            format: {
                let components = $0.components(includeMinorUnit: true)

                let sign = $0.sign
                let formattedAmount: String

                switch $0.currencySymbolPosition {
                    case .prefix:
                        formattedAmount = "\($0.currencySymbol) \(sign)\(components.rawAmount)"
                    case .suffix:
                        formattedAmount = "\(sign)\(components.rawAmount) \($0.currencySymbol)"
                }

                return .init(
                    rawAmount: components.rawAmount,
                    formattedAmount: formattedAmount,
                    majorUnitRange: components.majorUnitRange,
                    minorUnitRange: components.minorUnitRange
                )
            }
        )

        let amount1 = Money(1200.30)
            .currencySymbol("₿", position: .prefix)
            .style(customStyle)

        #expect(String(describing: amount1) == "₿ 1,200.30")

        let amount2 = Money(-1200.30)
            .currencySymbol("BTC", position: .prefix)
            .style(customStyle)

        #expect(String(describing: amount2) == "BTC −1,200.30")
    }

    @Test
    func zeroString() {
        let amount1 = Money(0)
            .zeroString("--")
            .formatted(format: "%@ per month")

        #expect(amount1 == "--")

        let amount2 = Money(0)
            .zeroString("oops")
            .formatted(format: "%@ per month")

        #expect(amount2 == "oops")

        let amount3 = Money(9.99)
            .zeroString("--")
            .formatted(format: "%@ per month")

        #expect(amount3 == "$9.99 per month")

        let amount4 = Money(-9.99)
            .style(.default)
            .zeroString("oops")
            .formatted(format: "%@ per month")

        #expect(amount4 == "−$9.99 per month")

        let amount5 = Money(0)
            .zeroString(nil)
            .formatted(format: "%@ per month")

        #expect(amount5 == "$0.00 per month")
    }

    @Test
    func edgeCaseNumbers() {
        #expect(Money(Decimal(string: "20.05588"))?.formatted() == "$20.06")
        #expect(Money(Decimal(string: "5.04198"))?.formatted() == "$5.04")
        #expect(Money(5.04198).formatted() == "$5.04")

        #expect(Money(Decimal(string: "20.05588"))?.fractionLength(.maxFractionDigits).formatted() == "$20.05588")
        #expect(Money(Decimal(string: "5.04198"))?.fractionLength(.maxFractionDigits).formatted() == "$5.04198")
        #expect(Money(5.04198).fractionLength(.maxFractionDigits).formatted() == "$5.041979999999998976")

        let amount = Money(Decimal(string: "0.064144"))?
            .currencySymbol("ETH", position: .suffix)
            .fractionLength(.maxFractionDigits)

        #expect(amount?.formatted() == "0.064144 ETH")
    }

    @Test
    func polandLocale() {
        let złoty = Money(120.30)
            .currencySymbol("zł", position: .suffix)
            .locale(.poland)

        #expect(złoty.formatted() == "120,30 zł")
    }
}

// MARK: - Locale

extension MoneyTests {
    /// Tests different language / region formatting.
    @Test
    func locale() {
        // US - Default
        #expect(Money(-1000.0).locale(.us).formatted() == "−$1,000.00")
        #expect(Money(-1.0).locale(.us).formatted() == "−$1.00")
        #expect(Money(0.0).locale(.us).formatted() == "$0.00")
        #expect(Money(1.0).locale(.us).formatted() == "$1.00")
        #expect(Money(1000.0).locale(.us).formatted() == "$1,000.00")

        // India - Hindi
        #expect(Money(-1000.0).locale(.indiaHindi).formatted() == "−$1,000.00")
        #expect(Money(-1.0).locale(.indiaHindi).formatted() == "−$1.00")
        #expect(Money(0.0).locale(.indiaHindi).formatted() == "$0.00")
        #expect(Money(1.0).locale(.indiaHindi).formatted() == "$1.00")
        #expect(Money(1000.0).locale(.indiaHindi).formatted() == "$1,000.00")

        // India - Sanskrit
        #expect(Money(-1000.0).locale(.indiaSanskrit).formatted() == "−$१,०००.००")
        #expect(Money(-1.0).locale(.indiaSanskrit).formatted() == "−$१.००")
        #expect(Money(0.0).locale(.indiaSanskrit).formatted() == "$०.००")
        #expect(Money(1.0).locale(.indiaSanskrit).formatted() == "$१.००")
        #expect(Money(1000.0).locale(.indiaSanskrit).formatted() == "$१,०००.००")

        // Puerto Rico
        #expect(Money(-1000.0).locale(.puertoRico).formatted() == "−$1,000.00")
        #expect(Money(-10000.0).locale(.puertoRico).formatted() == "−$10,000.00")
        #expect(Money(-1.0).locale(.puertoRico).formatted() == "−$1.00")
        #expect(Money(0.0).locale(.puertoRico).formatted() == "$0.00")
        #expect(Money(1.0).locale(.puertoRico).formatted() == "$1.00")
        #expect(Money(1000.0).locale(.puertoRico).formatted() == "$1,000.00")

        // China
        #expect(Money(-1000.0).locale(.china).formatted() == "−$1,000.00")
        #expect(Money(-1.0).locale(.china).formatted() == "−$1.00")
        #expect(Money(0.0).locale(.china).formatted() == "$0.00")
        #expect(Money(1.0).locale(.china).formatted() == "$1.00")
        #expect(Money(1000.0).locale(.china).formatted() == "$1,000.00")

        // Canada - Fr
        #expect(Money(-1000.0).locale(.canadaFr).formatted() == "−$1 000,00")
        #expect(Money(-1.0).locale(.canadaFr).formatted() == "−$1,00")
        #expect(Money(0.0).locale(.canadaFr).formatted() == "$0,00")
        #expect(Money(1.0).locale(.canadaFr).formatted() == "$1,00")
        #expect(Money(1000.0).locale(.canadaFr).formatted() == "$1 000,00")

        // Canada - En
        #expect(Money(-1000.0).locale(.canadaEn).formatted() == "−$1,000.00")
        #expect(Money(-1.0).locale(.canadaEn).formatted() == "−$1.00")
        #expect(Money(0.0).locale(.canadaEn).formatted() == "$0.00")
        #expect(Money(1.0).locale(.canadaEn).formatted() == "$1.00")
        #expect(Money(1000.0).locale(.canadaEn).formatted() == "$1,000.00")

        // UK
        #expect(Money(-1000.0).locale(.uk).formatted() == "−$1,000.00")
        #expect(Money(-1.0).locale(.uk).formatted() == "−$1.00")
        #expect(Money(0.0).locale(.uk).formatted() == "$0.00")
        #expect(Money(1.0).locale(.uk).formatted() == "$1.00")
        #expect(Money(1000.0).locale(.uk).formatted() == "$1,000.00")

        // Mexico
        #expect(Money(-1000.0).locale(.mexico).formatted() == "−$1,000.00")
        #expect(Money(-10000.0).locale(.mexico).formatted() == "−$10,000.00")
        #expect(Money(-1.0).locale(.mexico).formatted() == "−$1.00")
        #expect(Money(0.0).locale(.mexico).formatted() == "$0.00")
        #expect(Money(1.0).locale(.mexico).formatted() == "$1.00")
        #expect(Money(1000.0).locale(.mexico).formatted() == "$1,000.00")

        // Brazil
        #expect(Money(-1000.0).locale(.brazil).formatted() == "−$1.000,00")
        #expect(Money(-1.0).locale(.brazil).formatted() == "−$1,00")
        #expect(Money(0.0).locale(.brazil).formatted() == "$0,00")
        #expect(Money(1.0).locale(.brazil).formatted() == "$1,00")
        #expect(Money(1000.0).locale(.brazil).formatted() == "$1.000,00")

        // Portugal
        #expect(Money(-1000.0).locale(.portugal).formatted() == "−$1000,00")
        #expect(Money(-1.0).locale(.portugal).formatted() == "−$1,00")
        #expect(Money(0.0).locale(.portugal).formatted() == "$0,00")
        #expect(Money(1.0).locale(.portugal).formatted() == "$1,00")
        #expect(Money(1000.0).locale(.portugal).formatted() == "$1000,00")

        // Germany
        #expect(Money(-1000.0).locale(.germany).formatted() == "−$1.000,00")
        #expect(Money(-1.0).locale(.germany).formatted() == "−$1,00")
        #expect(Money(0.0).locale(.germany).formatted() == "$0,00")
        #expect(Money(1.0).locale(.germany).formatted() == "$1,00")
        #expect(Money(1000.0).locale(.germany).formatted() == "$1.000,00")

        // Japan
        #expect(Money(-1000.0).locale(.japan).formatted() == "−$1,000.00")
        #expect(Money(-1.0).locale(.japan).formatted() == "−$1.00")
        #expect(Money(0.0).locale(.japan).formatted() == "$0.00")
        #expect(Money(1.0).locale(.japan).formatted() == "$1.00")
        #expect(Money(1000.0).locale(.japan).formatted() == "$1,000.00")

        // Pakistan - Urdu
        #expect(Money(-1000.0).locale(.pakistanUrdu).formatted() == "−$1,000.00")
        #expect(Money(-1.0).locale(.pakistanUrdu).formatted() == "−$1.00")
        #expect(Money(0.0).locale(.pakistanUrdu).formatted() == "$0.00")
        #expect(Money(1.0).locale(.pakistanUrdu).formatted() == "$1.00")
        #expect(Money(1000.0).locale(.pakistanUrdu).formatted() == "$1,000.00")

        // Pakistan - Punjabi
        #expect(Money(-1000.0).locale(.pakistanPunjabi).formatted() == "−$۱٬۰۰۰٫۰۰")
        #expect(Money(-1.0).locale(.pakistanPunjabi).formatted() == "−$۱٫۰۰")
        #expect(Money(0.0).locale(.pakistanPunjabi).formatted() == "$۰٫۰۰")
        #expect(Money(1.0).locale(.pakistanPunjabi).formatted() == "$۱٫۰۰")
        #expect(Money(1000.0).locale(.pakistanPunjabi).formatted() == "$۱٬۰۰۰٫۰۰")

        // Switzerland
        #expect(Money(-1000.0).locale(.switzerland).formatted() == "−$1’000.00")
        #expect(Money(-1.0).locale(.switzerland).formatted() == "−$1.00")
        #expect(Money(0.0).locale(.switzerland).formatted() == "$0.00")
        #expect(Money(1.0).locale(.switzerland).formatted() == "$1.00")
        #expect(Money(1000.0).locale(.switzerland).formatted() == "$1’000.00")

        // Ireland
        #expect(Money(-1000.0).locale(.ireland).formatted() == "−$1,000.00")
        #expect(Money(-1.0).locale(.ireland).formatted() == "−$1.00")
        #expect(Money(0.0).locale(.ireland).formatted() == "$0.00")
        #expect(Money(1.0).locale(.ireland).formatted() == "$1.00")
        #expect(Money(1000.0).locale(.ireland).formatted() == "$1,000.00")

        // Indonesia
        #expect(Money(-1000.0).locale(.indonesia).formatted() == "−$1.000,00")
        #expect(Money(-1.0).locale(.indonesia).formatted() == "−$1,00")
        #expect(Money(0.0).locale(.indonesia).formatted() == "$0,00")
        #expect(Money(1.0).locale(.indonesia).formatted() == "$1,00")
        #expect(Money(1000.0).locale(.indonesia).formatted() == "$1.000,00")
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
    fileprivate static let poland = Locale(identifier: "pl_PL")

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
