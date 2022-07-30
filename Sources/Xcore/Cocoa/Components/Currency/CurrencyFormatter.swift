//
// Xcore
// Copyright © 2017 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

public final class CurrencyFormatter: Currency.SymbolsProvider, Appliable {
    public static let shared = CurrencyFormatter()

    /// An enumeration representing the position of currency symbol.
    public enum CurrencySymbolPosition: Sendable, Hashable {
        case prefix
        case suffix
    }

    public init() {}

    /// This formatter must be used only to transform Double values into US dollars.
    /// Reference: http://unicode.org/reports/tr35/tr35-10.html#Number_Format_Patterns
    private lazy var formatter = NumberFormatter().apply {
        $0.numberStyle = .currency
        $0.locale = locale
        // We need to manually override the currency symbol in order to support
        // different locals but keep currency symbol at the correct position to keep the
        // design consistent (e.g., German (de) locale: "1.000,11 $" → "$1.000,11").
        $0.currencySymbol = currencySymbol
        $0.isDecimalEnabled = true
        // When truncating fraction digits, if needed, we should round up.
        // For example, `0.165` → `0.17` instead of `0.16`. 
        $0.roundingMode = .halfUp
    }

    /// The locale of the receiver.
    ///
    /// The locale determines the default values for many formatter attributes, such
    /// as ISO country and language codes, currency code, calendar, system of
    /// measurement, and decimal separator.
    ///
    /// The default value is `.us`.
    public var locale: Locale = .us {
        didSet {
            formatter.locale = locale
        }
    }

    /// The currency symbol position.
    public var currencySymbolPosition: CurrencySymbolPosition = .prefix

    /// The character the receiver uses as a currency symbol.
    ///
    /// Currency symbol can be independently set of locale to ensure correct
    /// currency symbol is used while localizing decimal and grouping separators.
    /// For example, `$ (USA)` currency symbol should be used when user changes
    /// their locale to France, while grouping and decimal separator is changed to
    /// space and comma respectively.
    ///
    /// While currency isn't directly translated (e.g.,`$100 != €100`), however, it
    /// is safe to use locale aware grouping and decimal separator to make it user
    /// locale friendly (e.g., France locale  `$1,000.00` == `$1 000,00`).
    public var currencySymbol = Locale.us.currencySymbol ?? "$" {
        didSet {
            formatter.currencySymbol = currencySymbol
        }
    }

    /// The character the receiver uses as a grouping separator.
    ///
    /// For example, the grouping separator used in the United States is the comma
    /// (`"10,000"`) whereas in France it is the space (`"10 000"`).
    public var groupingSeparator: String {
        formatter.groupingSeparator ?? ","
    }

    /// The character the receiver uses as a decimal separator.
    ///
    /// For example, the decimal separator used in the United States is the period
    /// (`"10,000.00"`) whereas in France it is the comma (`"10 000,00"`).
    public var decimalSeparator: String {
        formatter.decimalSeparator ?? "."
    }
}

// MARK: - Equatable

extension CurrencyFormatter: Equatable {
    public static func ==(lhs: CurrencyFormatter, rhs: CurrencyFormatter) -> Bool {
        lhs.locale == rhs.locale &&
            lhs.currencySymbolPosition == rhs.currencySymbolPosition &&
            lhs.currencySymbol == rhs.currencySymbol &&
            lhs.groupingSeparator == rhs.groupingSeparator &&
            lhs.decimalSeparator == rhs.decimalSeparator &&
            lhs.formatter.isEqual(rhs.formatter)
    }
}

// MARK: - Hashable

extension CurrencyFormatter: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(locale)
        hasher.combine(currencySymbolPosition)
        hasher.combine(currencySymbol)
        hasher.combine(groupingSeparator)
        hasher.combine(decimalSeparator)
        hasher.combine(formatter)
    }
}

// MARK: - Format

extension CurrencyFormatter {
    /// Returns a numeric representation by parsing the given string.
    ///
    /// - Parameter string: A string that is parsed to generate the returned numeric
    ///   value.
    /// - Returns: A numeric representation by parsing the given string, or `nil` if
    ///   no single number could be parsed.
    public func decimal(from string: String) -> Decimal? {
        formatter.number(from: string)?.decimalValue
    }

    /// Returns a numeric representation by parsing the given string.
    ///
    /// - Parameter string: A string that is parsed to generate the returned numeric
    ///   value.
    /// - Returns: A numeric representation by parsing the given string, or `nil` if
    ///   no single number could be parsed.
    public func double(from string: String) -> Double? {
        formatter.number(from: string)?.doubleValue
    }

    public func format(amount value: Any, allowDecimal: Bool) -> String? {
        var string = "\(value)"

        let shouldCleanString: Bool

        if Decimal(string: string) != nil {
            shouldCleanString = false
        } else {
            shouldCleanString = string.contains(.specialCharacters, provider: self)
        }

        if shouldCleanString {
            string = string.trimmingCurrencySymbols(.all, provider: self)
        }

        let needsDecimalConversion = shouldCleanString && allowDecimal

        return formatter.synchronized {
            formatter.isDecimalEnabled = allowDecimal

            guard
                let number = Decimal(string: string),
                let formattedString = formatter.string(from: needsDecimalConversion ? number / 100 : number)
            else {
                return nil
            }

            return formattedString
        }
    }
}

// MARK: - Components

extension CurrencyFormatter {
    func components(
        from amount: Decimal,
        fractionLength limits: ClosedRange<Int>? = nil,
        sign: Money.Sign = .default
    ) -> Money.Components {
        let limits = limits ?? amount.calculatePrecision()
        var majorUnitString = "0"
        var minorUnitString = "00"

        let amountString = with(fractionLength: limits) {
            formatter.string(from: amount)!
        }

        let pieces = amountString.components(separatedBy: decimalSeparator)

        if let majorUnit = pieces.first {
            majorUnitString = majorUnit
        }

        if pieces.count > 1 {
            let rawMinorUnitString = pieces[1] as NSString
            let range = NSRange(location: 0, length: rawMinorUnitString.length)
            minorUnitString = rawMinorUnitString.replacingOccurrences(
                of: "\\D",
                with: "",
                options: .regularExpression,
                range: range
            )
        }

        return .init(
            amount: amount,
            majorUnit: majorUnitString,
            minorUnit: minorUnitString,
            sign: sign,
            formatter: self
        )
    }

    private func with<T>(fractionLength: ClosedRange<Int>, _ block: () -> T) -> T {
        // Save
        let existingPositivePrefix = formatter.positivePrefix
        let existingNegativePrefix = formatter.negativePrefix
        let existingFractionLength = formatter.fractionLength

        formatter.fractionLength = fractionLength
        formatter.positivePrefix = ""
        formatter.negativePrefix = ""

        // Compute
        let result = block()

        // Restore
        formatter.positivePrefix = existingPositivePrefix
        formatter.negativePrefix = existingNegativePrefix
        formatter.fractionLength = existingFractionLength
        return result
    }
}

extension NumberFormatter {
    fileprivate var isDecimalEnabled: Bool {
        get { minimumFractionDigits == 0 }
        set {
            // This ensures that regions without fraction numbers or a different decimal
            // separator are at least getting a '.00'
            minimumFractionDigits = newValue ? 2 : 0
        }
    }
}
