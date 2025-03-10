//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

/// A formatter that converts numeric values to and from localized decimal or
/// currency text.
///
/// Use this formatter to format user input as either plain decimals or currency
/// strings based on locale-aware rules.
///
/// ```swift
/// let formatter = DecimalTextFieldFormatter(style: .currency)
/// formatter.format("1234.567") // "$1,234.56" (en_US)
/// ```
public struct DecimalTextFieldFormatter: TextFieldFormatter {
    /// An enumeration representing the formatting style to apply to numeric values.
    enum Style: Sendable, Hashable, Codable {
        /// A locale-aware decimal number format.
        ///
        /// Example: "1234.5678" → "1,234.568" in en_US locale.
        case decimal

        /// A locale-aware currency format using the current locale's currency symbol.
        ///
        /// Example:
        /// - "1234.5678" → "$1,234.57" in en_US locale.
        /// - "1234.5678" → "1 234,57 €" in fr_FR locale.
        case currency
    }

    /// The selected formatting style.
    private let style: Style

    /// Creates a formatter with the specified numeric style.
    ///
    /// - Parameter style: The numeric formatting style.
    init(style: Style) {
        self.style = style
    }

    public func string(from value: Double?) -> String {
        value?.formatted(.number) ?? ""
    }

    public func value(from string: String) -> Double? {
        try? Double(string, format: .number)
    }

    public func format(_ string: String) -> String? {
        let components = string.components(separatedBy: decimalSeparator)

        guard
            let wholeNumberPartString = components.first,
            let wholeNumberPart = Int(wholeNumberPartString)
        else {
            return string.isEmpty ? "" : nil
        }

        let symbol = style == .currency ? currency.currencySymbol : nil
        let wholeNumber = wholeNumberPart.formatted(.number)
        let decimalPoint = string.contains(decimalSeparator) ? decimalSeparator : ""
        var fractionalPart = components.at(1)

        // Limit fractional part to two digits when formatting as currency.
        if style == .currency, let fraction = fractionalPart {
            fractionalPart = String(fraction.prefix(2))
        }

        return [
            symbol,
            wholeNumber,
            decimalPoint,
            fractionalPart
        ].joined()
    }

    public func unformat(_ string: String) -> String {
        let decimalSeparator = Character(decimalSeparator)
        return string.filter { $0.isNumber || $0 == decimalSeparator }
    }

    /// Provides the current currency settings, including the currency symbol and
    /// locale.
    private var currency: Money.Appearance {
        Money.appearance()
    }

    /// The locale-specific decimal separator character (e.g., "." or ",").
    private var decimalSeparator: String {
        style == .currency ? currency.locale.decimalSeparator ?? "." : "."
    }
}
