//
// Currency+SymbolsOptions.swift
//
// Copyright © 2017 Xcore
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

import Foundation

// MARK: - SymbolsProvider

extension Currency {
    public typealias SymbolsProvider = CurrencySymbolsProvider
}

public protocol CurrencySymbolsProvider {
    var currencySymbol: String { get }

    /// The string used by the receiver for a grouping separator.
    ///
    /// For example, the grouping separator used in the United States is the comma
    /// (“10,000”) whereas in France it is the space (“10 000”).
    var groupingSeparator: String { get }

    /// The character the receiver uses as a decimal separator.
    ///
    /// For example, the grouping separator used in the United States is the period
    /// (“10,000.00”) whereas in France it is the comma (“10 000,00”).
    var decimalSeparator: String { get }
}

// MARK: - SymbolsOptions

extension Currency {
    public struct SymbolsOptions: OptionSet {
        public let rawValue: Int

        public init(rawValue: Int) {
            self.rawValue = rawValue
        }

        public static let currencySymbol = SymbolsOptions(rawValue: 1 << 0)
        public static let groupingSeparator = SymbolsOptions(rawValue: 1 << 1)
        public static let decimalSeparator = SymbolsOptions(rawValue: 1 << 2)
        public static let specialCharacters: SymbolsOptions = [
            currencySymbol,
            groupingSeparator
        ]

        public static let all: SymbolsOptions = [
            currencySymbol,
            groupingSeparator,
            decimalSeparator
        ]
    }
}

// MARK: - String Extension

extension String {
    /// A function to remove specified currency symbols (`$ , .`) from `self`.
    ///
    /// ```swift
    /// $2,000.88 -> 200088   // "$2,000.8".trimmingCurrencySymbols(.all)
    /// $2,000.88 -> 2,000.88 // "$2,000.8".trimmingCurrencySymbols(.currencySymbol)
    /// $2,000.88 -> $2000.88 // "$2,000.8".trimmingCurrencySymbols(.groupingSeparator)
    /// $2,000.88 -> $2,00088 // "$2,000.8".trimmingCurrencySymbols(.decimalSeparator)
    /// $2,000.88 -> 2000.88  // "$2,000.8".trimmingCurrencySymbols([.currencySymbol, .groupingSeparator])
    /// $2,000.88 -> 2000.88  // "$2,000.8".trimmingCurrencySymbols(.specialCharacters)
    /// ```
    public func trimmingCurrencySymbols(_ options: Currency.SymbolsOptions, provider: Currency.SymbolsProvider) -> String {
        guard !options.isEmpty else { return self }

        var pattern = ""

        if options.contains(.currencySymbol) {
            pattern += "\(provider.currencySymbol)"
        }

        if options.contains(.groupingSeparator) {
            pattern += "\(provider.groupingSeparator)"
        }

        if options.contains(.decimalSeparator) {
            pattern += "\(provider.decimalSeparator)"
        }

        return replace("[\(pattern)]+", with: "")
    }

    /// Returns true iff other is non-empty and contained within `self` by
    /// case-sensitive, non-literal search.
    ///
    /// ```swift
    /// true  -> ("$2,000.88").contains(.all),
    /// true  -> ("$2,000.88").contains([.currencySymbol, .groupingSeparator, .decimalSeparator]),
    /// true  -> ("$2,000.88").contains(.currencySymbol),
    /// true  -> ("$2,000.88").contains(.groupingSeparator),
    /// true  -> ("$2,000.88").contains(.decimalSeparator),
    /// true  -> ("$2,000.88").contains([.currencySymbol, .groupingSeparator]),
    /// true  -> ("$2,000.88").contains(.specialCharacters),
    /// false ->   ("2000.88").contains(.specialCharacters),
    /// false ->    ("200088").contains(.all)
    /// ```
    public func contains(_ other: Currency.SymbolsOptions, provider: Currency.SymbolsProvider) -> Bool {
        guard !other.isEmpty else { return false }

        var result = [Bool]()

        if other.contains(.currencySymbol) {
            result.append(contains(provider.currencySymbol))
        }

        if other.contains(.groupingSeparator) {
            result.append(contains(provider.groupingSeparator))
        }

        if other.contains(.decimalSeparator) {
            result.append(contains(provider.decimalSeparator))
        }

        return result.contains(true)
    }
}
