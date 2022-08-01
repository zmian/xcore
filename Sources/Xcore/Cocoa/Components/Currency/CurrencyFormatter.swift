//
// Xcore
// Copyright © 2017 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

/// A formatter used by `Money` type to format the their textual
/// representations.
///
/// - Warning: This is an implementation detail of the `Money` type. Please use
///   the higher-level `Money` and `Money.appearance()` types.
final class CurrencyFormatter: Currency.SymbolsProvider, Appliable {
    static let shared = CurrencyFormatter()

    /// This formatter must be used only to transform Double values into US dollars.
    /// Reference: http://unicode.org/reports/tr35/tr35-10.html#Number_Format_Patterns
    private lazy var formatter = NumberFormatter().apply {
        $0.numberStyle = .currency
        $0.positivePrefix = ""
        $0.negativePrefix = ""
        // When truncating fraction digits, if needed, we should round up.
        // For example, `0.165` → `0.17` instead of `0.16`.
        $0.roundingMode = .halfUp
        $0.locale = locale
        // We need to manually override the currency symbol in order to support
        // different locals but keep currency symbol at the correct position to keep the
        // design consistent (e.g., German (de) locale: "1.000,11 $" → "$1.000,11").
        $0.currencySymbol = currencySymbol
    }

    /// The locale of the receiver.
    ///
    /// The locale determines the default values for many formatter attributes, such
    /// as ISO country and language codes, currency code, calendar, system of
    /// measurement, and decimal separator.
    ///
    /// The default value is `.us`.
    var locale: Locale = .us {
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
    var currencySymbol = Locale.us.currencySymbol ?? "$" {
        didSet {
            formatter.currencySymbol = currencySymbol
        }
    }

    /// The character the receiver uses as a grouping separator.
    ///
    /// For example, the grouping separator used in the United States is the comma
    /// (`"10,000"`) whereas in France it is the space (`"10 000"`).
    var groupingSeparator: String {
        formatter.groupingSeparator ?? ","
    }

    /// The character the receiver uses as a decimal separator.
    ///
    /// For example, the decimal separator used in the United States is the period
    /// (`"10,000.00"`) whereas in France it is the comma (`"10 000,00"`).
    var decimalSeparator: String {
        formatter.decimalSeparator ?? "."
    }
}

// MARK: - Equatable

extension CurrencyFormatter: Equatable {
    static func ==(lhs: CurrencyFormatter, rhs: CurrencyFormatter) -> Bool {
        lhs.locale == rhs.locale &&
            lhs.currencySymbol == rhs.currencySymbol &&
            lhs.groupingSeparator == rhs.groupingSeparator &&
            lhs.decimalSeparator == rhs.decimalSeparator &&
            lhs.formatter.isEqual(rhs.formatter)
    }
}

// MARK: - Hashable

extension CurrencyFormatter: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(locale)
        hasher.combine(currencySymbol)
        hasher.combine(groupingSeparator)
        hasher.combine(decimalSeparator)
        hasher.combine(formatter)
    }
}

// MARK: - Components

extension CurrencyFormatter {
    func components(of money: Money) -> Money.Components {
        formatter.fractionLength = money.fractionLength
        let amountString = formatter.string(from: money.amount)!

        var majorUnitString = "0"
        var minorUnitString = "00"

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
            money: money,
            majorUnit: majorUnitString,
            minorUnit: minorUnitString
        )
    }
}
