//
// Xcore
// Copyright © 2017 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

/// A structure representing money type and a set of attributes used to format
/// the output.
///
/// **Usage**
///
/// ```swift
/// let amount = Money(120.30)
///     .signed()
///     .font(.body)
///     .style(.removeMinorUnitIfZero)
///
/// // Display the amount in a label.
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
/// // Display the amount in a label.
/// let amountLabel = UILabel()
/// amountLabel.setText(amount)
/// ```
public struct Money: Hashable, MutableAppliable {
    /// The amount of money.
    public let amount: Decimal

    public init(_ amount: Decimal) {
        self.amount = amount
        self.fractionLength = amount.calculatePrecision()
        superscriptMinorUnitEnabled = Self.appearance().superscriptMinorUnitEnabled
    }

    public init?(_ amount: Decimal?) {
        guard let amount = amount else {
            return nil
        }

        self.init(amount)
    }

    @_disfavoredOverload
    public init?(_ amount: Double?) {
        guard let amount = amount else {
            return nil
        }

        self.init(amount)
    }

    /// The formatter used to format the amount.
    ///
    /// The default value is `.shared`.
    public var formatter: CurrencyFormatter = .shared

    /// The minimum and maximum number of digits after the decimal separator.
    public var fractionLength: ClosedRange<Int>

    /// The sign (+/-) used to format money.
    ///
    /// The default value is `.default`, meaning, displays minus sign (`"-"`) for
    /// the negative values and empty string (`""`) for positive and zero values.
    ///
    /// ```swift
    /// // When the amount is positive then the sign is empty string ("").
    /// let amount = Money(120.30)
    ///     .sign(.default) // ← Specifying the sign
    ///
    /// print(amount) // "$120.30"
    ///
    /// // When the amount is negative then the sign is "-".
    /// let amount = Money(-120.30)
    ///     .sign(.default) // ← Specifying the sign
    ///
    /// print(amount) // "-$120.30"
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
    public var style: Components.Style = .default

    /// The font used to format money components.
    ///
    /// The default value is `nil`.
    public var font: Components.Font?

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
    /// The formatter used to format the amount.
    public func formatter(_ formatter: CurrencyFormatter) -> Self {
        applying {
            $0.formatter = formatter
        }
    }

    /// The minimum and maximum number of digits after the decimal separator.
    public func fractionLength(_ limits: ClosedRange<Int>) -> Self {
        applying {
            $0.fractionLength = limits
        }
    }

    /// The minimum and maximum number of digits after the decimal separator.
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
    public func style(_ style: Components.Style) -> Self {
        applying {
            $0.style = style
        }
    }

    /// The font used to format money components.
    public func font(_ font: Components.Font?) -> Self {
        applying {
            $0.font = font
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
            $0.color = .init(.init(color))
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

// MARK: - StringRepresentable

extension Money: StringRepresentable {
    public var stringSource: StringSourceType {
        if #available(iOS 15, *) {
            return .attributedString(NSAttributedString(attributedString()))
        } else {
            return .string(formatted())
        }
    }
}

// MARK: - ExpressibleByFloatLiteral

extension Money: ExpressibleByFloatLiteral {
    public init(floatLiteral value: FloatLiteralType) {
        self.init(Decimal(value))
    }

    public init(_ value: Double) {
        self.init(Decimal(value))
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
    /// }
    /// ```
    public final class Appearance: Appliable {
        public var superscriptMinorUnitEnabled = true
    }

    private static var appearanceProxy = Appearance()
    public static func appearance() -> Appearance {
        appearanceProxy
    }
}
