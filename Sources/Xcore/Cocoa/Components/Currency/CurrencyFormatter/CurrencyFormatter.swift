//
// Xcore
// Copyright © 2017 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

public class CurrencyFormatter: Currency.SymbolsProvider {
    public static let shared = CurrencyFormatter()

    /// This formatter must be used only to transform Double values into US dollars.
    /// Reference: http://unicode.org/reports/tr35/tr35-10.html#Number_Format_Patterns
    private lazy var formatter = NumberFormatter().apply {
        $0.numberStyle = .currency
        $0.locale = locale
        $0.positiveFormat = "¤#,##0.00"
        $0.negativeFormat = "-¤#,##0.00"
        // We need to add the $-Symbol manually in order to support different locals but
        // keep $ sign at the correct position to keep the design consistent
        // (i.e., Germany: 1.000,11 $ -> $1.000,11).
        $0.currencySymbol = currencySymbol
        $0.isDecimalEnabled = true
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
    public var currencySymbol = Locale.us.currencySymbol ?? "$"

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
        hasher.combine(currencySymbol)
        hasher.combine(groupingSeparator)
        hasher.combine(decimalSeparator)
        hasher.combine(formatter)
    }
}

// MARK: - Components

extension CurrencyFormatter {
    public func components(from amount: Decimal, sign: Money.Sign = .default) -> Money.Components {
        var majorUnitString = "0"
        var minorUnitString = "00"

        // Important to ensure decimal is enabled since the formatter is shared instance
        // potentially mutated by other code.
        formatter.isDecimalEnabled = true

        let amountString = with(sign: sign) {
            formatter.string(from: NSDecimalNumber(decimal: amount))!
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
            currencySymbol: currencySymbol,
            groupingSeparator: groupingSeparator,
            decimalSeparator: decimalSeparator
        )
    }
}

// MARK: - Format

extension CurrencyFormatter {
    /// Returns a string representation of a given value formatted using the given
    /// style.
    ///
    /// - Parameters:
    ///   - value: The value to format.
    ///   - style: The style to format the result.
    ///   - sign: The sign to use when formatting the result.
    /// - Returns: A string representation of a given value formatted using the
    ///   given style.
    public func string(
        from value: Decimal,
        style: Money.Components.Style = .default,
        sign: Money.Sign = .default
    ) -> String {
        components(from: value, sign: sign).joined(style: style)
    }

    /// Returns a string representation of a given value formatted using the given
    /// style.
    ///
    /// - Parameters:
    ///   - value: The value to format.
    ///   - style: The style to format the result.
    ///   - sign: The sign to use when formatting the result.
    /// - Returns: A string representation of a given value formatted using the
    ///   given style.
    public func string(
        from value: Int,
        style: Money.Components.Style = .default,
        sign: Money.Sign = .default
    ) -> String {
        string(from: Decimal(value), style: style, sign: sign)
    }

    /// Returns a string representation of a given value formatted using the given
    /// style.
    ///
    /// - Parameters:
    ///   - value: The value to format.
    ///   - style: The style to format the result.
    ///   - sign: The sign to use when formatting the result.
    /// - Returns: A string representation of a given value formatted using the
    ///   given style.
    public func string(
        from value: Double,
        style: Money.Components.Style = .default,
        sign: Money.Sign = .default
    ) -> String {
        string(from: Decimal(value), style: style, sign: sign)
    }

    /// Returns a numeric representation by parsing the given string.
    ///
    /// - Parameter string: A string that is parsed to generate the returned numeric
    ///   value.
    /// - Returns: A numeric representation by parsing the given string, or `nil` if
    ///   no single number could be parsed.
    public func decimal(from string: String) -> Decimal? {
        if let decimalValue = Decimal(string: string) {
            return decimalValue
        }

        return formatter.number(from: string)?.decimalValue
    }

    /// Returns a numeric representation by parsing the given string.
    ///
    /// - Parameter string: A string that is parsed to generate the returned numeric
    ///   value.
    /// - Returns: A numeric representation by parsing the given string, or `nil` if
    ///   no single number could be parsed.
    public func double(from string: String) -> Double? {
        if let doubleValue = Double(string) {
            return doubleValue
        }

        return formatter.number(from: string)?.doubleValue
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
                let formattedString = formatter.string(from: NSDecimalNumber(
                    decimal: needsDecimalConversion ? number / 100 : number
                ))
            else {
                return nil
            }

            return formattedString
        }
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

// MARK: - Sign

extension CurrencyFormatter {
    private func with<T>(sign: Money.Sign, _ block: () -> T) -> T {
        let existingPositivePrefix = formatter.positivePrefix
        let existingNegativePrefix = formatter.negativePrefix
        formatter.positivePrefix = sign.plus + formatter.currencySymbol
        formatter.negativePrefix = sign.minus + formatter.currencySymbol
        let result = block()
        formatter.positivePrefix = existingPositivePrefix
        formatter.negativePrefix = existingNegativePrefix
        return result
    }
}
