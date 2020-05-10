//
// Xcore
// Copyright © 2017 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

public class CurrencyFormatter: Currency.SymbolsProvider {
    public static let shared = CurrencyFormatter()

    /// This formatter must be used only to transform Double values into US dollars.
    private lazy var formatter = NumberFormatter().apply {
        $0.numberStyle = .currency
        $0.locale = locale
        $0.positiveFormat = defaultPositiveFormat
        $0.negativeFormat = defaultNegativeFormat
        // We need to add the $-Symbol manually in order to support different locals but
        // keep $ sign at the correct position to keep the design consistent
        // (i.e., Germany: 1.000,11 $ -> $1.000,11).
        $0.currencySymbol = currencySymbol
        $0.isDecimalEnabled = true
    }

    // Separators will get replaced by locale ones.
    /// `¤#,##0.00`
    private let defaultFormat = "¤#,##0.00"
    /// `¤#,##0.00`
    private let defaultPositiveFormat = "¤#,##0.00"
    /// `-¤#,##0.00`
    private let defaultNegativeFormat = "-¤#,##0.00"

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

    /// The character the receiver uses as a decimal separator.
    ///
    /// For example, the decimal separator used in the United States is the period
    /// (“10,000.00”) whereas in France it is the comma (“10 000,00”).
    public var decimalSeparator: String {
        formatter.decimalSeparator ?? "."
    }

    /// The string used by the receiver for a grouping separator.
    ///
    /// For example, the grouping separator used in the United States is the comma
    /// (“10,000”) whereas in France it is the space (“10 000”).
    public var groupingSeparator: String {
        formatter.groupingSeparator ?? ","
    }

    /// We always want to make sure the `USA` currency symbol is used when
    /// formatting to avoid bugs and confusions.
    ///
    /// For example, $100 != €100
    ///
    /// However, it is safe to use locale aware grouping and decimal separator to
    /// make it user locale friendly.
    ///
    /// For example, France locale  $1,000.00 == $1 000,00
    public var currencySymbol: String {
        Locale.us.currencySymbol ?? "$"
    }
}

// MARK: - Components

extension CurrencyFormatter {
    public func components(from amount: Double, sign: Currency.Sign = .default) -> Currency.Components {
        var majorUnitString = "0"
        var minorUnitString = "00"

        // Important to ensure decimal is enabled since the formatter is shared
        // instance potentially mutated by other code.
        formatter.isDecimalEnabled = true

        let currencyString = with(sign: sign) {
             formatter.string(from: NSNumber(value: amount))!
        }

        let pieces = currencyString.components(separatedBy: decimalSeparator)

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
    ///            given style.
    public func string(
        from value: Double,
        style: Currency.Components.Style = .none,
        sign: Currency.Sign = .default
    ) -> String {
        components(from: value, sign: sign).joined(style: style)
    }

    /// Returns a numeric representation by parsing the given string.
    ///
    /// - Parameter string: A string that is parsed to generate the returned numeric
    ///                     value.
    /// - Returns: A numeric representation by parsing the given string, or `nil` if
    ///            no single number could be parsed.
    public func double(from string: String) -> Double? {
        if let doubleValue = Double(string) {
            return doubleValue
        }

        return formatter.number(from: string)?.doubleValue
    }

    public func format(amount value: Any, allowDecimal: Bool) -> String? {
        var string = "\(value)"

        let shouldCleanString: Bool

        if Double(string) != nil {
            shouldCleanString = false
        } else {
            shouldCleanString = string.contains(.specialCharacters, provider: self)
        }

        if shouldCleanString {
            string = string.trimmingCurrencySymbols(.all, provider: self)
        }

        let needsDecimalConversion = shouldCleanString && allowDecimal

        return synchronized(formatter) {
            formatter.isDecimalEnabled = allowDecimal

            guard
                let number = Double(string),
                let formattedString = formatter.string(from: NSNumber(value: needsDecimalConversion ? number / 100 : number))
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
    private func with<T>(sign: Currency.Sign, _ block: () -> T) -> T {
        formatter.positiveFormat = sign.plus + defaultFormat
        formatter.negativeFormat = sign.minus + defaultFormat
        let result = block()
        formatter.positiveFormat = defaultPositiveFormat
        formatter.negativeFormat = defaultNegativeFormat
        return result
    }
}
