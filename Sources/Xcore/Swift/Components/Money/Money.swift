//
// Xcore
// Copyright © 2017 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

/// A structure representing money type and a set of attributes used to format
/// the output.
///
/// Money conforms to ``SwiftUI.View`` protocol and can be used directly in any
/// view.
///
/// ```swift
/// struct ContentView: View {
///     var body: some View {
///         Money(120.30) // Renders "$120.30"
///     }
/// }
/// ```
///
/// Custom currency symbol:
///
/// ```swift
/// let btc = Money(0.5)
///     .currencySymbol("BTC", position: .suffix)
///
/// print(btc)
/// // Prints "0.5 BTC"
///
/// let britishPounds = Money(120.30)
///     .currencySymbol("£", position: .prefix)
///
/// print(britishPounds)
/// // Prints "£120.30"
/// ```
///
/// Custom region and currency symbol:
///
/// ```swift
/// let poland = Locale(identifier: "pl_PL")
///
/// let złoty = Money(120.30)
///     .currencySymbol("zł", position: .suffix)
///     .locale(poland)
///
/// print(złoty)
/// // Prints "120,30 zł"
/// ```
///
/// UIKit support is also provided out of the box:
///
/// ```swift
/// let amount = Money(120.30)
///     .signed()
///     .font(.body)
///     .style(.removeMinorUnitIfZero)
///
/// // Display the amount in a label
/// let amountLabel = UILabel()
/// amountLabel.setText(amount)
/// ```
///
/// **Using Custom Formats**
///
/// ```swift
/// let monthlyPayment = Money(9.99)
///     .font(.headline)
///     .attributedString(format: "%@ per month")
///
/// print(monthlyPayment)
/// // Prints "$9.99 per month"
///
/// // Display the amount in a label
/// let amountLabel = UILabel()
/// amountLabel.setText(monthlyPayment)
/// ```
public struct Money: Hashable, MutableAppliable {
    /// The amount of money.
    public let amount: Decimal

    public init(_ amount: Decimal) {
        self.amount = amount
        fractionLength = amount.calculatePrecision()
        locale = Self.appearance().locale
        currencySymbol = Self.appearance().currencySymbol
        superscriptMinorUnitEnabled = Self.appearance().superscriptMinorUnitEnabled
    }

    public init?(_ amount: Decimal?) {
        guard let amount else {
            return nil
        }

        self.init(amount)
    }

    @_disfavoredOverload
    public init?(_ amount: Double?) {
        guard let amount else {
            return nil
        }

        self.init(amount)
    }

    /// The locale the formatter uses when formatting the amount.
    ///
    /// The locale determines the default values for many formatter attributes, such
    /// as ISO country and language codes, currency code, calendar, system of
    /// measurement, and decimal separator.
    ///
    /// The default value is `.us`.
    public var locale: Locale

    /// The character the formatter uses as a currency symbol for the amount.
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
    public var currencySymbol: String

    /// The currency symbol position.
    public var currencySymbolPosition: CurrencySymbolPosition = .prefix

    /// The minimum and maximum number of digits after the decimal separator.
    public var fractionLength: ClosedRange<Int>

    /// The sign (+/−) used to format money.
    ///
    /// The default value is `.default`, meaning, displays minus sign (`"−"`) for
    /// the negative values and empty string (`""`) for positive and zero values.
    ///
    /// ```swift
    /// // When the amount is positive then the sign is empty string ("").
    /// let amount = Money(120.30)
    ///     .sign(.default) // ← Specifying the sign
    ///
    /// print(amount) // "$120.30"
    ///
    /// // When the amount is negative then the sign is "−".
    /// let amount = Money(-120.30)
    ///     .sign(.default) // ← Specifying the sign
    ///
    /// print(amount) // "−$120.30"
    /// ```
    public var sign: Sign = .default

    /// The style used to format money components.
    ///
    /// The default value is `.default`. For example:
    ///
    /// ```swift
    /// let amount = Money(120.30)
    ///     .style(.default) // ← Specifying style format
    ///
    /// print(amount) // "$120.30"
    /// ```
    public var style: Style = .default

    /// The font used to format money components.
    ///
    /// The default value is `nil`.
    public var font: Font?

    /// A property to indicate whether the color changes based on the amount.
    public var color: Color?

    /// The custom string to use when the amount is `0`.
    ///
    /// The default value is `nil`, meaning to display `0` amount.
    public var zeroString: String?

    /// A property to indicate whether the minor unit can be rendered as a
    /// superscript.
    ///
    /// The default value is `true`.
    public var superscriptMinorUnitEnabled: Bool
}

// MARK: - Chaining Syntactic Syntax

extension Money {
    /// The locale the formatter uses when formatting the amount.
    public func locale(_ locale: Locale) -> Self {
        applying {
            $0.locale = locale
        }
    }

    /// The currency symbol of the amount and its position.
    public func currencySymbol(_ currencySymbol: String, position: CurrencySymbolPosition) -> Self {
        applying {
            $0.currencySymbol = currencySymbol
            $0.currencySymbolPosition = position
        }
    }

    /// The minimum and maximum number of digits after the decimal separator.
    public func fractionLength(_ limits: ClosedRange<Int>) -> Self {
        applying {
            $0.fractionLength = limits
        }
    }

    /// The minimum and maximum number of digits after the decimal separator.
    @_disfavoredOverload
    public func fractionLength(_ limit: Int) -> Self {
        fractionLength(limit...limit)
    }

    /// Returns precision range to be used to ensure at least 2 significant fraction
    /// digits are shown.
    ///
    /// Minimum precision is always set to 2. For higher precisions, for amounts
    /// lower than $0.01, we want to show the first two significant digits after the
    /// decimal point.
    ///
    /// ```swift
    /// $1           → $1.00
    /// $1.234       → $1.23
    /// $1.000031    → $1.00
    /// $0.00001     → $0.00001
    /// $0.000010000 → $0.00001
    /// $0.000012    → $0.000012
    /// $0.00001243  → $0.000012
    /// $0.00001253  → $0.000013
    /// $0.00001283  → $0.000013
    /// $0.000000138 → $0.00000014
    /// ```
    public func fractionLengthDefault() -> Self {
        fractionLength(amount.calculatePrecision())
    }

    /// The sign (+/-) used to format money.
    public func sign(_ sign: Sign) -> Self {
        applying {
            $0.sign = sign
        }
    }

    /// The style used to format money components.
    public func style(_ style: Style) -> Self {
        applying {
            $0.style = style
        }
    }

    /// The font used to format money components.
    public func font(_ font: Font?) -> Self {
        applying {
            $0.font = font
        }
    }

    /// The font used to format money components.
    @_disfavoredOverload
    public func font(_ font: UIFont) -> Self {
        applying {
            $0.font = .init(font)
        }
    }

    /// The color used to format money components.
    public func color(_ color: Color?) -> Self {
        applying {
            $0.color = color
        }
    }

    /// The color used to format money components.
    @_disfavoredOverload
    public func color(_ color: UIColor) -> Self {
        applying {
            $0.color = .init(.init(uiColor: color))
        }
    }

    /// The custom string to use when the amount is `0`.
    ///
    /// Displays `0` amount when `zeroString` is nil.
    public func zeroString(_ zeroString: String?) -> Self {
        applying {
            $0.zeroString = zeroString
        }
    }

    /// Enable or disable the minor unit rendereding as superscript.
    public func superscriptMinorUnit(_ enable: Bool) -> Self {
        applying {
            $0.superscriptMinorUnitEnabled = enable
        }
    }
}

// MARK: - CustomStringConvertible

extension Money: CustomStringConvertible {
    public var description: String {
        formatted()
    }
}

// MARK: - ExpressibleByFloatLiteral

extension Money: ExpressibleByFloatLiteral {
    public init(floatLiteral value: FloatLiteralType) {
        self.init(Decimal(value))
    }

    public init(_ value: Double) {
        self.init(Decimal(string: value.stringValue, locale: .usPosix) ?? Decimal(value))
    }
}

// MARK: - ExpressibleByIntegerLiteral

extension Money: ExpressibleByIntegerLiteral {
    public init(integerLiteral value: IntegerLiteralType) {
        self.init(Decimal(value))
    }

    public init(_ value: Int) {
        self.init(Decimal(value))
    }
}

// MARK: - CurrencySymbolPosition

extension Money {
    /// An enumeration representing the position of currency symbol.
    public enum CurrencySymbolPosition: Sendable, Hashable {
        /// Adds currency symbol before the amount (e.g., `$10.00`).
        case prefix

        /// Adds currency symbol after the amount (e.g., `1 BTC`).
        case suffix
    }

    /// The character the formatter uses as a decimal separator.
    ///
    /// For example, the decimal separator used in the United States is the period
    /// (`"10,000.00"`) whereas in France it is the comma (`"10 000,00"`).
    public var decimalSeparator: String {
        locale.decimalSeparator ?? "."
    }
}

// MARK: - Appearance

extension Money {
    /// This configuration exists to allow some of the properties to be configured
    /// to match app's appearance style. The `UIAppearance` protocol doesn't work
    /// when the stored properites are set using associated object.
    ///
    /// **Usage**
    ///
    /// ```swift
    /// Money.appearance().apply {
    ///     $0.superscriptMinorUnitEnabled = false
    ///     $0.currencySymbol = "£"
    ///     $0.locale = .uk
    /// }
    /// ```
    public final class Appearance: Appliable {
        public var superscriptMinorUnitEnabled = true

        /// The character the formatter uses as a currency symbol for the amount.
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

        /// The locale of the formatter.
        ///
        /// The locale determines the default values for many formatter attributes, such
        /// as ISO country and language codes, currency code, calendar, system of
        /// measurement, and decimal separator.
        ///
        /// The default value is `.us`.
        public var locale: Locale = .us
    }

    private static var appearanceProxy = Appearance()
    public static func appearance() -> Appearance {
        appearanceProxy
    }
}
