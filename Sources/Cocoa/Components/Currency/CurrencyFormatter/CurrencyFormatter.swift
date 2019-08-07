//
// CurrencyFormatter.swift
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

public class CurrencyFormatter: Currency.SymbolsProvider {
    public static let shared = CurrencyFormatter()

    /// This formatter must be used only to transform Double values into US dollars.
    private lazy var formatter = NumberFormatter().apply {
        $0.numberStyle = .currency
        $0.locale = locale
        $0.positiveFormat = "¤#,##0.00"
        // Separators are getting replaced by locale ones
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

    /// The character the receiver uses as a decimal separator.
    ///
    /// For example, the grouping separator used in the United States is the period
    /// (“10,000.00”) whereas in France it is the comma (“10 000,00”).
    public var decimalSeparator: String {
        return formatter.decimalSeparator ?? "."
    }

    /// The string used by the receiver for a grouping separator.
    ///
    /// For example, the grouping separator used in the United States is the comma
    /// (“10,000”) whereas in France it is the space (“10 000”).
    public var groupingSeparator: String {
        return formatter.groupingSeparator ?? ","
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
        return Locale.us.currencySymbol ?? "$"
    }
}

// MARK: - Components

extension CurrencyFormatter {
    public func components(from amount: Double) -> Currency.Components {
        var dollarString = "0"
        var centString = "00"

        // Important to ensure decimal is enabled since the formatter is shared
        // instance potentially mutated by other code.
        formatter.isDecimalEnabled = true
        let currencyString = formatter.string(from: NSNumber(value: amount))!
        var pieces = currencyString.components(separatedBy: decimalSeparator)

        if let dollars = pieces.first {
            dollarString = dollars
        }

        if pieces.count > 1 {
            let rawCentString = pieces[1] as NSString
            let range = NSRange(location: 0, length: rawCentString.length)
            centString = rawCentString.replacingOccurrences(
                of: "\\D",
                with: "",
                options: .regularExpression,
                range: range
            )
        }

        return .init(
            amount: amount,
            dollars: dollarString,
            cents: centString,
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
    /// - Returns: A string representation of a given value formatted using the
    ///            given style.
    public func string(
        from value: Double,
        style: Currency.Components.Style = .none
    ) -> String {
        return components(from: value).joined(style: style)
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
        get { return minimumFractionDigits == 0 }
        set {
            // This ensures that regions without fraction numbers or a different decimal
            // separator are at least getting a '.00'
            minimumFractionDigits = newValue ? 2 : 0
        }
    }
}
