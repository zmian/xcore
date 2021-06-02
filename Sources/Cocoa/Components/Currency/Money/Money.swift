//
// Xcore
// Copyright © 2017 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

/// A structure representing money type and set of attributes to formats the
/// output.
///
/// # Example
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
/// # Using Custom Formats
///
/// ```swift
/// let monthlyPayment = Money(9.99)
///     .font(.headline)
///     .attributedString(format: "%@ per month")
///
/// // Display the amount in a label.
/// let amountLabel = UILabel()
/// amountLabel.setText(amount)
/// ```
public struct Money: Equatable, Hashable, MutableAppliable {
    /// The amount of money.
    public var amount: Decimal

    public init(_ amount: Decimal) {
        self.amount = amount
        shouldSuperscriptMinorUnit = Self.appearance().shouldSuperscriptMinorUnit
    }

    public init?(_ amount: Double?) {
        guard let amount = amount else {
            return nil
        }

        self.init(amount)
    }

    /// The currency formatter used to format the amount.
    ///
    /// The default value is `.shared`.
    public var formatter: CurrencyFormatter = .shared

    /// The style used to format money components.
    ///
    /// The default value is `.default`.
    public var style: Components.Style = .default

    /// The font used to display money components.
    ///
    /// The default value is `.none`.
    public var font: Components.Font = .none

    /// The sign (+/-) used to format money components.
    ///
    /// The default value is `.none`.
    public var sign: Sign = .none

    /// A property to indicate whether the color changes based on the amount.
    public var color: Color = .none

    /// The custom string to use when the amount is `0`.
    ///
    /// This value is ignored if the `shouldDisplayZero` property is `true`.
    ///
    /// The default value is `--`.
    public var zeroString: String = "--"

    public var shouldDisplayZero = true

    /// A property to indicate whether the minor unit is rendered as superscript.
    ///
    /// The default value is `false`.
    public var shouldSuperscriptMinorUnit: Bool

    public var accessibilityLabel: String {
        formatter.string(from: amount, style: style)
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

// MARK: - CustomStringConvertible

extension Money: CustomStringConvertible {
    public var description: String {
        formatter.string(from: self)
    }
}

// MARK: - StringRepresentable

extension Money: StringRepresentable {
    public var stringSource: StringSourceType {
        .attributedString(formatter.attributedString(from: self))
    }
}

// MARK: - Appearance

extension Money {
    /// This configuration exists to allow some of the properties to be configured
    /// to match app's appearance style. The `UIAppearance` protocol doesn't work
    /// when the stored properites are set using associated object.
    ///
    /// **Usage:**
    ///
    /// ```swift
    /// Money.appearance().shouldSuperscriptMinorUnit = true
    /// ```
    final public class Appearance: Appliable {
        public var shouldSuperscriptMinorUnit = false
    }

    private static var appearanceProxy = Appearance()
    public static func appearance() -> Appearance {
        appearanceProxy
    }
}

// MARK: - Chaining Syntactic Syntax

extension Money {
    public func style(_ style: Components.Style) -> Self {
        applying {
            $0.style = style
        }
    }

    public func font(_ font: Components.Font) -> Self {
        applying {
            $0.font = font
        }
    }

    public func sign(_ sign: Sign) -> Self {
        applying {
            $0.sign = sign
        }
    }

    public func color(_ color: Color) -> Self {
        applying {
            $0.color = color
        }
    }

    public func color(_ color: UIColor) -> Self {
        applying {
            $0.color = .init(color)
        }
    }

    public func signed() -> Self {
        sign(.default)
    }

    /// Signed positive amount with (`"+"`), minus (`""`) and `0` amount omits
    /// `+` or `-` sign.
    public func positiveSigned() -> Self {
        sign(.init(plus: amount == 0 ? "" : "+", minus: ""))
    }

    /// Zero amount will be displayed as "--".
    ///
    /// See: `zeroString` to customize the default value.
    public func dasherizeZero() -> Self {
        applying {
            $0.shouldDisplayZero = false
        }
    }

    public func attributedString(format: String? = nil) -> NSAttributedString {
        formatter.attributedString(from: self, format: format)
    }

    public func string(format: String? = nil) -> String {
        formatter.string(from: self, format: format)
    }
}
