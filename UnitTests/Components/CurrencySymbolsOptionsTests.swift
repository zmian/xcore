//
// CurrencySymbolsOptionsTests.swift
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

final class CurrencySymbolsOptionsTests: TestCase {
    private typealias TestData<OutputType> = (input: String, output: OutputType, manipulator: CurrencySymbolsOptions)
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
            XCTAssertTrue(returned == item.output, "Expected output to be \"\(item.output)\", instead found \"\(returned).\"")
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
            XCTAssertTrue(returned == item.output, "Expected output to be \"\(item.output)\", instead found \"\(returned).\"")
        }
    }
}

private struct StubCurrencySymbolsProvider: CurrencySymbolsProvider {
    var currencySymbol: String {
        return "$"
    }

    var groupingSeparator: String {
        return ","
    }

    var decimalSeparator: String {
        return "."
    }
}
