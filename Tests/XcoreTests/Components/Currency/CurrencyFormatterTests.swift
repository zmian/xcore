//
// Xcore
// Copyright © 2017 Xcore
// MIT license, see LICENSE file for details
//

import XCTest
@testable import Xcore

final class CurrencyFormatterTests: TestCase {
    // This tests if different language / region settings can get parsed to US.
    func testDollarsAndCents() {
        // US - Default
        CurrencyFormatter.shared.localeTest = .usa
        assertEqual(dollarsAndCents(from: -1000.0), ("-$1,000.", "00"))
        assertEqual(dollarsAndCents(from: -1.0), ("-$1.", "00"))
        assertEqual(dollarsAndCents(from: 0.0), ("$0.", "00"))
        assertEqual(dollarsAndCents(from: 1.0), ("$1.", "00"))
        assertEqual(dollarsAndCents(from: 1000.0), ("$1,000.", "00"))

        // India - Hindi
        CurrencyFormatter.shared.localeTest = .indiaHindi
        assertEqual(dollarsAndCents(from: -1000.0), ("-$1,000.", "00"))
        assertEqual(dollarsAndCents(from: -1.0), ("-$1.", "00"))
        assertEqual(dollarsAndCents(from: 0.0), ("$0.", "00"))
        assertEqual(dollarsAndCents(from: 1.0), ("$1.", "00"))
        assertEqual(dollarsAndCents(from: 1000.0), ("$1,000.", "00"))

        // India - Sanskrit
        CurrencyFormatter.shared.localeTest = .indiaSanskrit
        assertEqual(dollarsAndCents(from: -1000.0), ("-$१,०००.", "००"))
        assertEqual(dollarsAndCents(from: -1.0), ("-$१.", "००"))
        assertEqual(dollarsAndCents(from: 0.0), ("$०.", "००"))
        assertEqual(dollarsAndCents(from: 1.0), ("$१.", "००"))
        assertEqual(dollarsAndCents(from: 1000.0), ("$१,०००.", "००"))

        // Puerto Rico
        CurrencyFormatter.shared.localeTest = .puertoRico
        assertEqual(dollarsAndCents(from: -1000.0), ("-$1,000.", "00"))
        assertEqual(dollarsAndCents(from: -10000.0), ("-$10,000.", "00"))
        assertEqual(dollarsAndCents(from: -1.0), ("-$1.", "00"))
        assertEqual(dollarsAndCents(from: 0.0), ("$0.", "00"))
        assertEqual(dollarsAndCents(from: 1.0), ("$1.", "00"))
        assertEqual(dollarsAndCents(from: 1000.0), ("$1,000.", "00"))

        // China
        CurrencyFormatter.shared.localeTest = .china
        assertEqual(dollarsAndCents(from: -1000.0), ("-$1,000.", "00"))
        assertEqual(dollarsAndCents(from: -1.0), ("-$1.", "00"))
        assertEqual(dollarsAndCents(from: 0.0), ("$0.", "00"))
        assertEqual(dollarsAndCents(from: 1.0), ("$1.", "00"))
        assertEqual(dollarsAndCents(from: 1000.0), ("$1,000.", "00"))

        // Canada - Fr
        CurrencyFormatter.shared.localeTest = .canadaFr
        assertEqual(dollarsAndCents(from: -1000.0), ("-$1 000,", "00"))
        assertEqual(dollarsAndCents(from: -1.0), ("-$1,", "00"))
        assertEqual(dollarsAndCents(from: 0.0), ("$0,", "00"))
        assertEqual(dollarsAndCents(from: 1.0), ("$1,", "00"))
        assertEqual(dollarsAndCents(from: 1000.0), ("$1 000,", "00"))

        // Canada - En
        CurrencyFormatter.shared.localeTest = .canadaEn
        assertEqual(dollarsAndCents(from: -1000.0), ("-$1,000.", "00"))
        assertEqual(dollarsAndCents(from: -1.0), ("-$1.", "00"))
        assertEqual(dollarsAndCents(from: 0.0), ("$0.", "00"))
        assertEqual(dollarsAndCents(from: 1.0), ("$1.", "00"))
        assertEqual(dollarsAndCents(from: 1000.0), ("$1,000.", "00"))

        // UK
        CurrencyFormatter.shared.localeTest = .uk
        assertEqual(dollarsAndCents(from: -1000.0), ("-$1,000.", "00"))
        assertEqual(dollarsAndCents(from: -1.0), ("-$1.", "00"))
        assertEqual(dollarsAndCents(from: 0.0), ("$0.", "00"))
        assertEqual(dollarsAndCents(from: 1.0), ("$1.", "00"))
        assertEqual(dollarsAndCents(from: 1000.0), ("$1,000.", "00"))

        // Mexico
        CurrencyFormatter.shared.localeTest = .mexico
        assertEqual(dollarsAndCents(from: -1000.0), ("-$1,000.", "00"))
        assertEqual(dollarsAndCents(from: -10000.0), ("-$10,000.", "00"))
        assertEqual(dollarsAndCents(from: -1.0), ("-$1.", "00"))
        assertEqual(dollarsAndCents(from: 0.0), ("$0.", "00"))
        assertEqual(dollarsAndCents(from: 1.0), ("$1.", "00"))
        assertEqual(dollarsAndCents(from: 1000.0), ("$1,000.", "00"))

        // Brazil
        CurrencyFormatter.shared.localeTest = .brazil
        assertEqual(dollarsAndCents(from: -1000.0), ("-$1.000,", "00"))
        assertEqual(dollarsAndCents(from: -1.0), ("-$1,", "00"))
        assertEqual(dollarsAndCents(from: 0.0), ("$0,", "00"))
        assertEqual(dollarsAndCents(from: 1.0), ("$1,", "00"))
        assertEqual(dollarsAndCents(from: 1000.0), ("$1.000,", "00"))

        // Germany
        CurrencyFormatter.shared.localeTest = .germany
        assertEqual(dollarsAndCents(from: -1000.0), ("-$1.000,", "00"))
        assertEqual(dollarsAndCents(from: -1.0), ("-$1,", "00"))
        assertEqual(dollarsAndCents(from: 0.0), ("$0,", "00"))
        assertEqual(dollarsAndCents(from: 1.0), ("$1,", "00"))
        assertEqual(dollarsAndCents(from: 1000.0), ("$1.000,", "00"))

        // Japan
        CurrencyFormatter.shared.localeTest = .japan
        assertEqual(dollarsAndCents(from: -1000.0), ("-$1,000.", "00"))
        assertEqual(dollarsAndCents(from: -1.0), ("-$1.", "00"))
        assertEqual(dollarsAndCents(from: 0.0), ("$0.", "00"))
        assertEqual(dollarsAndCents(from: 1.0), ("$1.", "00"))
        assertEqual(dollarsAndCents(from: 1000.0), ("$1,000.", "00"))

        // Pakistan - Urdu
        CurrencyFormatter.shared.localeTest = .pakistanUrdu
        assertEqual(dollarsAndCents(from: -1000.0), ("-$1,000.", "00"))
        assertEqual(dollarsAndCents(from: -1.0), ("-$1.", "00"))
        assertEqual(dollarsAndCents(from: 0.0), ("$0.", "00"))
        assertEqual(dollarsAndCents(from: 1.0), ("$1.", "00"))
        assertEqual(dollarsAndCents(from: 1000.0), ("$1,000.", "00"))

        // Pakistan - Punjabi
        CurrencyFormatter.shared.localeTest = .pakistanPunjabi
        assertEqual(dollarsAndCents(from: -1000.0), ("-$۱٬۰۰۰٫", "۰۰"))
        assertEqual(dollarsAndCents(from: -1.0), ("-$۱٫", "۰۰"))
        assertEqual(dollarsAndCents(from: 0.0), ("$۰٫", "۰۰"))
        assertEqual(dollarsAndCents(from: 1.0), ("$۱٫", "۰۰"))
        assertEqual(dollarsAndCents(from: 1000.0), ("$۱٬۰۰۰٫", "۰۰"))

        // Switzerland
        CurrencyFormatter.shared.localeTest = .switzerland
        assertEqual(dollarsAndCents(from: -1000.0), ("-$1’000.", "00"))
        assertEqual(dollarsAndCents(from: -1.0), ("-$1.", "00"))
        assertEqual(dollarsAndCents(from: 0.0), ("$0.", "00"))
        assertEqual(dollarsAndCents(from: 1.0), ("$1.", "00"))
        assertEqual(dollarsAndCents(from: 1000.0), ("$1’000.", "00"))

        // Ireland
        CurrencyFormatter.shared.localeTest = .ireland
        assertEqual(dollarsAndCents(from: -1000.0), ("-$1,000.", "00"))
        assertEqual(dollarsAndCents(from: -1.0), ("-$1.", "00"))
        assertEqual(dollarsAndCents(from: 0.0), ("$0.", "00"))
        assertEqual(dollarsAndCents(from: 1.0), ("$1.", "00"))
        assertEqual(dollarsAndCents(from: 1000.0), ("$1,000.", "00"))

        // Indonesia
        CurrencyFormatter.shared.localeTest = .indonesia
        assertEqual(dollarsAndCents(from: -1000.0), ("-$1.000,", "00"))
        assertEqual(dollarsAndCents(from: -1.0), ("-$1,", "00"))
        assertEqual(dollarsAndCents(from: 0.0), ("$0,", "00"))
        assertEqual(dollarsAndCents(from: 1.0), ("$1,", "00"))
        assertEqual(dollarsAndCents(from: 1000.0), ("$1.000,", "00"))
    }

    func testCurrencyWithoutDecimals() {
        let amounts = [-1000.0, -1.0, 0.0, 1.0, 1000.0, 2000.88, 150_555.0, 4_627_042]

        for locale in Locale.allCases {
            CurrencyFormatter.shared.localeTest = locale

            for amount in amounts {
                guard let currencyString = CurrencyFormatter.shared.format(amount: amount, allowDecimal: true) else {
                    XCTFail("Invalid currency amount.")
                    break
                }

                guard let doubleValue = CurrencyFormatter.shared.double(from: currencyString) else {
                    XCTFail("Failed to convert \(currencyString) to valid number.")
                    break
                }

                XCTAssertTrue(doubleValue == amount, "result is: \(doubleValue) but amount is: \(amount), for \(locale.rawValue)")
            }
        }
    }

    func testCurrencyWithDecimals() {
        let amounts: [Double] = [-1000, -1, 0, 1, 1000, 200_088, 150_555, 4_627_042]

        for locale in Locale.allCases {
            CurrencyFormatter.shared.localeTest = locale

            for amount in amounts {
                guard let currencyString = CurrencyFormatter.shared.format(amount: amount, allowDecimal: false) else {
                    XCTFail("Invalid currency amount.")
                    break
                }

                guard let doubleValue = CurrencyFormatter.shared.double(from: currencyString) else {
                    XCTFail("Failed to convert \(currencyString) to valid number.")
                    break
                }

                XCTAssertTrue(doubleValue == amount, "result is: \(doubleValue) but amount is: \(amount), for \(locale.rawValue)")
            }
        }
    }
}

// MARK: - Helpers

extension CurrencyFormatterTests {
    fileprivate enum Locale: String, CaseIterable {
        case usa = "en_US"
        case indiaHindi = "hi_IN"
        case indiaSanskrit = "sa_IN"
        case puertoRico = "es_PR"
        case china = "zh_Hans_CN"
        case canadaFr = "fr_CA"
        case canadaEn = "en_CA"
        case uk = "en_GB"
        case mexico = "es_MX"
        case brazil = "pt_BR"
        case germany = "de_DE"
        case japan = "ja_JP" // no fractional numbers: 55.00 -> 55

        // Extra countries with different decimal separators
        // - Source: https://en.wikipedia.org/wiki/Decimal_mark
        case pakistanUrdu = "ur_PK"
        case pakistanPunjabi = "pa_Arab_PK"
        case switzerland = "gsw_CH"
        case ireland = "ga_IE"
        case indonesia = "id_ID"
    }

    private func dollarsAndCents(from amount: Decimal) -> (dollars: String, cents: String) {
        let components = CurrencyFormatter.shared.components(from: amount)
        return ("\(components.majorUnit)\(components.decimalSeparator)", components.minorUnit)
    }
}

extension CurrencyFormatter {
    fileprivate var localeTest: CurrencyFormatterTests.Locale {
        get { CurrencyFormatterTests.Locale(rawValue: locale.identifier) ?? .usa }
        set { locale = .init(identifier: newValue.rawValue) }
    }
}
