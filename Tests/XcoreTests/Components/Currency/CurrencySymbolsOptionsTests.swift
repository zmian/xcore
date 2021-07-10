//
// Xcore
// Copyright © 2017 Xcore
// MIT license, see LICENSE file for details
//

import XCTest
@testable import Xcore

final class CurrencySymbolsOptionsTests: TestCase {
    private typealias TestData<OutputType> = (input: String, output: OutputType, manipulator: Currency.SymbolsOptions)
    private let provider = StubCurrencySymbolsProvider()

    func testCurrencySymbolsTrimming() {
        let data: [TestData<String>] = [
            ("$2,000.88", "200088", .all),
            ("$2,000.88", "200088", [.currencySymbol, .groupingSeparator, .decimalSeparator]),
            ("$2,000.88", "2,000.88", .currencySymbol),
            ("$2,000.88", "$2000.88", .groupingSeparator),
            ("$2,000.88", "$2,00088", .decimalSeparator),
            ("$2,000.88", "2000.88", [.currencySymbol, .groupingSeparator]),
            ("$2,000.88", "2000.88", .specialCharacters)
        ]

        for item in data {
            let returned = item.input.trimmingCurrencySymbols(item.manipulator, provider: provider)
            XCTAssertEqual(returned, item.output)
        }
    }

    func testCurrencySymbolsContains() {
        let data: [TestData<Bool>] = [
            ("$2,000.88", true, .all),
            ("$2,000.88", true, [.currencySymbol, .groupingSeparator, .decimalSeparator]),
            ("$2,000.88", true, .currencySymbol),
            ("$2,000.88", true, .groupingSeparator),
            ("$2,000.88", true, .decimalSeparator),
            ("$2,000.88", true, [.currencySymbol, .groupingSeparator]),
            ("$2,000.88", true, .specialCharacters),
            ("2000.88", false, .specialCharacters),
            ("200088", false, .all)
        ]

        for item in data {
            let returned = item.input.contains(item.manipulator, provider: provider)
            XCTAssertEqual(returned, item.output)
        }
    }
}

private struct StubCurrencySymbolsProvider: Currency.SymbolsProvider {
    var currencySymbol: String {
        "$"
    }

    var groupingSeparator: String {
        ","
    }

    var decimalSeparator: String {
        "."
    }
}
