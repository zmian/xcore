//
// Xcore
// Copyright © 2017 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

/// A formatter used by `Money` type to format the amount to textual
/// representation.
///
/// - Warning: This is an implementation detail of the `Money` type. Please use
///   the higher-level `Money` and `Money.appearance()` types.
@available(iOS, introduced: 14, deprecated: 15, message: "Use Decimal.FormatStyle directly.")
final class MoneyFormatter: Appliable {
    static let shared = MoneyFormatter()

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

    var locale: Locale = .us {
        didSet {
            formatter.locale = locale
        }
    }

    var currencySymbol = Locale.us.currencySymbol ?? "$" {
        didSet {
            formatter.currencySymbol = currencySymbol
        }
    }

    func string(from amount: Decimal, fractionLength: ClosedRange<Int>) -> String {
        formatter.fractionLength = fractionLength
        return formatter.string(from: amount)!
    }
}
