//
// CurrencyFormatterTests.swift
//
// Copyright © 2017 Zeeshan Mian
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

import XCTest
@testable import Xcore

final class CurrencyFormatterTests: TestCase {
    // This tests if different language / region settings can get parsed to US.
    func testDollarsAndCents() {
        // US - Default
        CurrencyFormatter.shared.localeTest = .usa
        XCTAssertTrue(dollarsAndCents(from: -1000.0) == ("-$1,000.", "00"))
        XCTAssertTrue(dollarsAndCents(from: -1.0) == ("-$1.", "00"))
        XCTAssertTrue(dollarsAndCents(from: 0.0) == ("$0.", "00"))
        XCTAssertTrue(dollarsAndCents(from: 1.0) == ("$1.", "00"))
        XCTAssertTrue(dollarsAndCents(from: 1000.0) == ("$1,000.", "00"))

        // India
        CurrencyFormatter.shared.localeTest = .india
        XCTAssertTrue(dollarsAndCents(from: -1000.0) == ("-$१,०००.", "००"))
        XCTAssertTrue(dollarsAndCents(from: -1.0) == ("-$१.", "००"))
        XCTAssertTrue(dollarsAndCents(from: 0.0) == ("$०.", "००"))
        XCTAssertTrue(dollarsAndCents(from: 1.0) == ("$१.", "००"))
        XCTAssertTrue(dollarsAndCents(from: 1000.0) == ("$१,०००.", "००"))

        // Puerto Rico
        CurrencyFormatter.shared.localeTest = .puertoRico
        XCTAssertTrue(dollarsAndCents(from: -1000.0) == ("-$1,000.", "00"))
        XCTAssertTrue(dollarsAndCents(from: -1.0) == ("-$1.", "00"))
        XCTAssertTrue(dollarsAndCents(from: 0.0) == ("$0.", "00"))
        XCTAssertTrue(dollarsAndCents(from: 1.0) == ("$1.", "00"))
        XCTAssertTrue(dollarsAndCents(from: 1000.0) == ("$1,000.", "00"))

        // China
        CurrencyFormatter.shared.localeTest = .china
        XCTAssertTrue(dollarsAndCents(from: -1000.0) == ("-$1,000.", "00"))
        XCTAssertTrue(dollarsAndCents(from: -1.0) == ("-$1.", "00"))
        XCTAssertTrue(dollarsAndCents(from: 0.0) == ("$0.", "00"))
        XCTAssertTrue(dollarsAndCents(from: 1.0) == ("$1.", "00"))
        XCTAssertTrue(dollarsAndCents(from: 1000.0) == ("$1,000.", "00"))

        // Canada - Fr
        CurrencyFormatter.shared.localeTest = .canadaFr
        XCTAssertTrue(dollarsAndCents(from: -1000.0) == ("-$1 000,", "00"))
        XCTAssertTrue(dollarsAndCents(from: -1.0) == ("-$1,", "00"))
        XCTAssertTrue(dollarsAndCents(from: 0.0) == ("$0,", "00"))
        XCTAssertTrue(dollarsAndCents(from: 1.0) == ("$1,", "00"))
        XCTAssertTrue(dollarsAndCents(from: 1000.0) == ("$1 000,", "00"))

        // Canada - En
        CurrencyFormatter.shared.localeTest = .canadaEn
        XCTAssertTrue(dollarsAndCents(from: -1000.0) == ("-$1,000.", "00"))
        XCTAssertTrue(dollarsAndCents(from: -1.0) == ("-$1.", "00"))
        XCTAssertTrue(dollarsAndCents(from: 0.0) == ("$0.", "00"))
        XCTAssertTrue(dollarsAndCents(from: 1.0) == ("$1.", "00"))
        XCTAssertTrue(dollarsAndCents(from: 1000.0) == ("$1,000.", "00"))

        // UK
        CurrencyFormatter.shared.localeTest = .uk
        XCTAssertTrue(dollarsAndCents(from: -1000.0) == ("-$1,000.", "00"))
        XCTAssertTrue(dollarsAndCents(from: -1.0) == ("-$1.", "00"))
        XCTAssertTrue(dollarsAndCents(from: 0.0) == ("$0.", "00"))
        XCTAssertTrue(dollarsAndCents(from: 1.0) == ("$1.", "00"))
        XCTAssertTrue(dollarsAndCents(from: 1000.0) == ("$1,000.", "00"))

        // Mexico
        CurrencyFormatter.shared.localeTest = .mexico
        XCTAssertTrue(dollarsAndCents(from: -1000.0) == ("-$1,000.", "00"))
        XCTAssertTrue(dollarsAndCents(from: -1.0) == ("-$1.", "00"))
        XCTAssertTrue(dollarsAndCents(from: 0.0) == ("$0.", "00"))
        XCTAssertTrue(dollarsAndCents(from: 1.0) == ("$1.", "00"))
        XCTAssertTrue(dollarsAndCents(from: 1000.0) == ("$1,000.", "00"))

        // Brazil
        CurrencyFormatter.shared.localeTest = .brazil
        XCTAssertTrue(dollarsAndCents(from: -1000.0) == ("-$1.000,", "00"))
        XCTAssertTrue(dollarsAndCents(from: -1.0) == ("-$1,", "00"))
        XCTAssertTrue(dollarsAndCents(from: 0.0) == ("$0,", "00"))
        XCTAssertTrue(dollarsAndCents(from: 1.0) == ("$1,", "00"))
        XCTAssertTrue(dollarsAndCents(from: 1000.0) == ("$1.000,", "00"))

        // Germany
        CurrencyFormatter.shared.localeTest = .germany
        XCTAssertTrue(dollarsAndCents(from: -1000.0) == ("-$1.000,", "00"))
        XCTAssertTrue(dollarsAndCents(from: -1.0) == ("-$1,", "00"))
        XCTAssertTrue(dollarsAndCents(from: 0.0) == ("$0,", "00"))
        XCTAssertTrue(dollarsAndCents(from: 1.0) == ("$1,", "00"))
        XCTAssertTrue(dollarsAndCents(from: 1000.0) == ("$1.000,", "00"))

        // Japan
        CurrencyFormatter.shared.localeTest = .japan
        XCTAssertTrue(dollarsAndCents(from: -1000.0) == ("-$1,000.", "00"))
        XCTAssertTrue(dollarsAndCents(from: -1.0) == ("-$1.", "00"))
        XCTAssertTrue(dollarsAndCents(from: 0.0) == ("$0.", "00"))
        XCTAssertTrue(dollarsAndCents(from: 1.0) == ("$1.", "00"))
        XCTAssertTrue(dollarsAndCents(from: 1000.0) == ("$1,000.", "00"))

        // Pakistan
        CurrencyFormatter.shared.localeTest = .pakistan
        XCTAssertTrue(dollarsAndCents(from: -1000.0) == ("-$1,000.", "00"))
        XCTAssertTrue(dollarsAndCents(from: -1.0) == ("-$1.", "00"))
        XCTAssertTrue(dollarsAndCents(from: 0.0) == ("$0.", "00"))
        XCTAssertTrue(dollarsAndCents(from: 1.0) == ("$1.", "00"))
        XCTAssertTrue(dollarsAndCents(from: 1000.0) == ("$1,000.", "00"))

        // Switzerland
        CurrencyFormatter.shared.localeTest = .switzerland
        XCTAssertTrue(dollarsAndCents(from: -1000.0) == ("−$1’000.", "00"))
        XCTAssertTrue(dollarsAndCents(from: -1.0) == ("−$1.", "00"))
        XCTAssertTrue(dollarsAndCents(from: 0.0) == ("$0.", "00"))
        XCTAssertTrue(dollarsAndCents(from: 1.0) == ("$1.", "00"))
        XCTAssertTrue(dollarsAndCents(from: 1000.0) == ("$1’000.", "00"))

        // Ireland
        CurrencyFormatter.shared.localeTest = .ireland
        XCTAssertTrue(dollarsAndCents(from: -1000.0) == ("-$1,000.", "00"))
        XCTAssertTrue(dollarsAndCents(from: -1.0) == ("-$1.", "00"))
        XCTAssertTrue(dollarsAndCents(from: 0.0) == ("$0.", "00"))
        XCTAssertTrue(dollarsAndCents(from: 1.0) == ("$1.", "00"))
        XCTAssertTrue(dollarsAndCents(from: 1000.0) == ("$1,000.", "00"))

        // Indonesia
        CurrencyFormatter.shared.localeTest = .indonesia
        XCTAssertTrue(dollarsAndCents(from: -1000.0) == ("-$1,000.", "00"))
        XCTAssertTrue(dollarsAndCents(from: -1.0) == ("-$1.", "00"))
        XCTAssertTrue(dollarsAndCents(from: 0.0) == ("$0.", "00"))
        XCTAssertTrue(dollarsAndCents(from: 1.0) == ("$1.", "00"))
        XCTAssertTrue(dollarsAndCents(from: 1000.0) == ("$1,000.", "00"))
    }

    func testCurrencyWithoutDecimals() {
        let amounts = [-1000.0, -1.0, 0.0, 1.0, 1000.0, 2000.88, 150555.0, 4627042]

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
        let amounts: [Double] = [-1000, -1, 0, 1, 1000, 200088, 150555, 4627042]

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

extension CurrencyFormatterTests {
    fileprivate enum Locale: String, CaseIterable {
        case usa = "en-US"
        case india = "hin-ID"
        case puertoRico = "spn-PR"
        case china = "mdr-CN"
        case canadaFr = "fr-CAN"
        case canadaEn = "en-CAN"
        case uk = "en-UK"
        case mexico = "spn-MX"
        case brazil = "por-BR"
        case germany = "de-DE"
        case japan = "jpn-JP" // no fractional numbers: 55.00 -> 55

        // Extra countries with different decimal separators
        // - Source: https://en.wikipedia.org/wiki/Decimal_mark
        case pakistan = "ab-PK"
        case switzerland = "gsw-CH"
        case ireland = "ga-IR"
        case indonesia = "idn-ID"
    }

    private func dollarsAndCents(from amount: Double) -> (dollars: String, cents: String) {
        let components = CurrencyFormatter.shared.components(from: amount)
        return ("\(components.dollars)\(components.decimalSeparator)", components.cents)
    }
}

extension CurrencyFormatter {
    fileprivate var localeTest: CurrencyFormatterTests.Locale {
        get { return CurrencyFormatterTests.Locale(rawValue: locale.identifier) ?? .usa }
        set { locale = Locale(identifier: newValue.rawValue) }
    }
}
