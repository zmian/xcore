//
// Xcore
// Copyright © 2017 Xcore
// MIT license, see LICENSE file for details
//

import XCTest
@testable import Xcore

final class MoneyLocaleTests: TestCase {
    /// Tests different language / region formatting.
    func testLocale() {
        // US - Default
        Money.appearance().locale = .us
        XCTAssertEqual(Money(-1000.0).formatted(), "−$1,000.00")
        XCTAssertEqual(Money(-1.0).formatted(), "−$1.00")
        XCTAssertEqual(Money(0.0).formatted(), "$0.00")
        XCTAssertEqual(Money(1.0).formatted(), "$1.00")
        XCTAssertEqual(Money(1000.0).formatted(), "$1,000.00")

        // India - Hindi
        Money.appearance().locale = .indiaHindi
        XCTAssertEqual(Money(-1000.0).formatted(), "−$1,000.00")
        XCTAssertEqual(Money(-1.0).formatted(), "−$1.00")
        XCTAssertEqual(Money(0.0).formatted(), "$0.00")
        XCTAssertEqual(Money(1.0).formatted(), "$1.00")
        XCTAssertEqual(Money(1000.0).formatted(), "$1,000.00")

        // India - Sanskrit
        Money.appearance().locale = .indiaSanskrit
        XCTAssertEqual(Money(-1000.0).formatted(), "−$१,०००.००")
        XCTAssertEqual(Money(-1.0).formatted(), "−$१.००")
        XCTAssertEqual(Money(0.0).formatted(), "$०.००")
        XCTAssertEqual(Money(1.0).formatted(), "$१.००")
        XCTAssertEqual(Money(1000.0).formatted(), "$१,०००.००")

        // Puerto Rico
        Money.appearance().locale = .puertoRico
        XCTAssertEqual(Money(-1000.0).formatted(), "−$1,000.00")
        XCTAssertEqual(Money(-10000.0).formatted(), "−$10,000.00")
        XCTAssertEqual(Money(-1.0).formatted(), "−$1.00")
        XCTAssertEqual(Money(0.0).formatted(), "$0.00")
        XCTAssertEqual(Money(1.0).formatted(), "$1.00")
        XCTAssertEqual(Money(1000.0).formatted(), "$1,000.00")

        // China
        Money.appearance().locale = .china
        XCTAssertEqual(Money(-1000.0).formatted(), "−$1,000.00")
        XCTAssertEqual(Money(-1.0).formatted(), "−$1.00")
        XCTAssertEqual(Money(0.0).formatted(), "$0.00")
        XCTAssertEqual(Money(1.0).formatted(), "$1.00")
        XCTAssertEqual(Money(1000.0).formatted(), "$1,000.00")

        // Canada - Fr
        Money.appearance().locale = .canadaFr
        XCTAssertEqual(Money(-1000.0).formatted(), "−$1 000,00")
        XCTAssertEqual(Money(-1.0).formatted(), "−$1,00")
        XCTAssertEqual(Money(0.0).formatted(), "$0,00")
        XCTAssertEqual(Money(1.0).formatted(), "$1,00")
        XCTAssertEqual(Money(1000.0).formatted(), "$1 000,00")

        // Canada - En
        Money.appearance().locale = .canadaEn
        XCTAssertEqual(Money(-1000.0).formatted(), "−$1,000.00")
        XCTAssertEqual(Money(-1.0).formatted(), "−$1.00")
        XCTAssertEqual(Money(0.0).formatted(), "$0.00")
        XCTAssertEqual(Money(1.0).formatted(), "$1.00")
        XCTAssertEqual(Money(1000.0).formatted(), "$1,000.00")

        // UK
        Money.appearance().locale = .uk
        XCTAssertEqual(Money(-1000.0).formatted(), "−$1,000.00")
        XCTAssertEqual(Money(-1.0).formatted(), "−$1.00")
        XCTAssertEqual(Money(0.0).formatted(), "$0.00")
        XCTAssertEqual(Money(1.0).formatted(), "$1.00")
        XCTAssertEqual(Money(1000.0).formatted(), "$1,000.00")

        // Mexico
        Money.appearance().locale = .mexico
        XCTAssertEqual(Money(-1000.0).formatted(), "−$1,000.00")
        XCTAssertEqual(Money(-10000.0).formatted(), "−$10,000.00")
        XCTAssertEqual(Money(-1.0).formatted(), "−$1.00")
        XCTAssertEqual(Money(0.0).formatted(), "$0.00")
        XCTAssertEqual(Money(1.0).formatted(), "$1.00")
        XCTAssertEqual(Money(1000.0).formatted(), "$1,000.00")

        // Brazil
        Money.appearance().locale = .brazil
        XCTAssertEqual(Money(-1000.0).formatted(), "−$1.000,00")
        XCTAssertEqual(Money(-1.0).formatted(), "−$1,00")
        XCTAssertEqual(Money(0.0).formatted(), "$0,00")
        XCTAssertEqual(Money(1.0).formatted(), "$1,00")
        XCTAssertEqual(Money(1000.0).formatted(), "$1.000,00")

        // Portugal
        Money.appearance().locale = .portugal
        XCTAssertEqual(Money(-1000.0).formatted(), "−$1000,00")
        XCTAssertEqual(Money(-1.0).formatted(), "−$1,00")
        XCTAssertEqual(Money(0.0).formatted(), "$0,00")
        XCTAssertEqual(Money(1.0).formatted(), "$1,00")
        XCTAssertEqual(Money(1000.0).formatted(), "$1000,00")

        // Germany
        Money.appearance().locale = .germany
        XCTAssertEqual(Money(-1000.0).formatted(), "−$1.000,00")
        XCTAssertEqual(Money(-1.0).formatted(), "−$1,00")
        XCTAssertEqual(Money(0.0).formatted(), "$0,00")
        XCTAssertEqual(Money(1.0).formatted(), "$1,00")
        XCTAssertEqual(Money(1000.0).formatted(), "$1.000,00")

        // Japan
        Money.appearance().locale = .japan
        XCTAssertEqual(Money(-1000.0).formatted(), "−$1,000.00")
        XCTAssertEqual(Money(-1.0).formatted(), "−$1.00")
        XCTAssertEqual(Money(0.0).formatted(), "$0.00")
        XCTAssertEqual(Money(1.0).formatted(), "$1.00")
        XCTAssertEqual(Money(1000.0).formatted(), "$1,000.00")

        // Pakistan - Urdu
        Money.appearance().locale = .pakistanUrdu
        XCTAssertEqual(Money(-1000.0).formatted(), "−$1,000.00")
        XCTAssertEqual(Money(-1.0).formatted(), "−$1.00")
        XCTAssertEqual(Money(0.0).formatted(), "$0.00")
        XCTAssertEqual(Money(1.0).formatted(), "$1.00")
        XCTAssertEqual(Money(1000.0).formatted(), "$1,000.00")

        // Pakistan - Punjabi
        Money.appearance().locale = .pakistanPunjabi
        XCTAssertEqual(Money(-1000.0).formatted(), "−$۱٬۰۰۰٫۰۰")
        XCTAssertEqual(Money(-1.0).formatted(), "−$۱٫۰۰")
        XCTAssertEqual(Money(0.0).formatted(), "$۰٫۰۰")
        XCTAssertEqual(Money(1.0).formatted(), "$۱٫۰۰")
        XCTAssertEqual(Money(1000.0).formatted(), "$۱٬۰۰۰٫۰۰")

        // Switzerland
        Money.appearance().locale = .switzerland
        XCTAssertEqual(Money(-1000.0).formatted(), "−$1’000.00")
        XCTAssertEqual(Money(-1.0).formatted(), "−$1.00")
        XCTAssertEqual(Money(0.0).formatted(), "$0.00")
        XCTAssertEqual(Money(1.0).formatted(), "$1.00")
        XCTAssertEqual(Money(1000.0).formatted(), "$1’000.00")

        // Ireland
        Money.appearance().locale = .ireland
        XCTAssertEqual(Money(-1000.0).formatted(), "−$1,000.00")
        XCTAssertEqual(Money(-1.0).formatted(), "−$1.00")
        XCTAssertEqual(Money(0.0).formatted(), "$0.00")
        XCTAssertEqual(Money(1.0).formatted(), "$1.00")
        XCTAssertEqual(Money(1000.0).formatted(), "$1,000.00")

        // Indonesia
        Money.appearance().locale = .indonesia
        XCTAssertEqual(Money(-1000.0).formatted(), "−$1.000,00")
        XCTAssertEqual(Money(-1.0).formatted(), "−$1,00")
        XCTAssertEqual(Money(0.0).formatted(), "$0,00")
        XCTAssertEqual(Money(1.0).formatted(), "$1,00")
        XCTAssertEqual(Money(1000.0).formatted(), "$1.000,00")
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
