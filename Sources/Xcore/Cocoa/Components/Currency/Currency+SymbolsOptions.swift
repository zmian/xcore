//
// Xcore
// Copyright © 2017 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

// MARK: - Namespace

public enum Currency {}

// MARK: - SymbolsProvider

extension Currency {
    public typealias SymbolsProvider = CurrencySymbolsProvider
}

public protocol CurrencySymbolsProvider {
    var currencySymbol: String { get }

    /// The character the receiver uses as a grouping separator.
    ///
    /// For example, the grouping separator used in the United States is the comma
    /// (`"10,000"`) whereas in France it is the space (`"10 000"`).
    var groupingSeparator: String { get }

    /// The character the receiver uses as a decimal separator.
    ///
    /// For example, the decimal separator used in the United States is the period
    /// (`"10,000.00"`) whereas in France it is the comma (`"10 000,00"`).
    var decimalSeparator: String { get }
}

// MARK: - SymbolsOptions

extension Currency {
    public struct SymbolsOptions: OptionSet {
        public let rawValue: Int

        public init(rawValue: Int) {
            self.rawValue = rawValue
        }

        public static let currencySymbol = Self(rawValue: 1 << 0)
        public static let groupingSeparator = Self(rawValue: 1 << 1)
        public static let decimalSeparator = Self(rawValue: 1 << 2)
        public static let specialCharacters: Self = [
            currencySymbol,
            groupingSeparator
        ]

        public static let all: Self = [
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

        return replacing("[\(pattern)]+", with: "")
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
    /// false -> ("2000.88").contains(.specialCharacters),
    /// false -> ("200088").contains(.all)
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
