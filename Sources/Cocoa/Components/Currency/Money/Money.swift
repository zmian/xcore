//
// Xcore
// Copyright © 2017 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

public struct Money: Equatable, Hashable, MutableAppliable {
    /// The amount of money.
    public var amount: Decimal

    public init(_ amount: Decimal) {
        self.amount = amount
        shouldSuperscriptMinorUnit = Self.appearance().shouldSuperscriptMinorUnit
    }

    /// A property to change the formatting style.
    ///
    /// The default value is `.none`.
    public var style: Components.Style = .none

    /// A property to change the attributes to adjust font sizes.
    ///
    /// The default value is `.body`.
    public var attributes: Components.Attributes = .body

    /// A property to indicate whether the output shows the sign (+/-).
    ///
    /// The default value is `.none`.
    public var sign: Sign = .none

    /// A property to indicate whether the color changes based on the amount.
    public var color: Color = .none

    /// The custom string to use when the amount is `0`.
    /// This value is ignored if the `shouldDisplayZeroAmounts` property is `true`.
    ///
    /// The default value is `--`.
    public var zeroAmountString: String = "--"

    public var shouldDisplayZeroAmounts = true

    /// A property to indicate whether the minor unit is rendered as superscript.
    ///
    /// The default value is `false`.
    public var shouldSuperscriptMinorUnit: Bool

    public var accessibilityLabel: String {
        CurrencyFormatter.shared.string(from: amount, style: style)
    }
}

// MARK: - ExpressibleByFloatLiteral

extension Money: ExpressibleByFloatLiteral {
    public init(floatLiteral value: FloatLiteralType) {
        self.init(Decimal(floatLiteral: value))
    }

    public init(_ value: Double) {
        self.init(Decimal(value))
    }
}

// MARK: - ExpressibleByIntegerLiteral

extension Money: ExpressibleByIntegerLiteral {
    public init(integerLiteral value: IntegerLiteralType) {
        self.init(Decimal(integerLiteral: value))
    }

    public init(_ value: Int) {
        self.init(Decimal(value))
    }
}

// MARK: - CustomStringConvertible

extension Money: CustomStringConvertible {
    public var description: String {
        CurrencyFormatter.shared.string(from: self)
    }
}

// MARK: - StringRepresentable

extension Money: StringRepresentable {
    public var stringSource: StringSourceType {
        .attributedString(CurrencyFormatter.shared.attributedString(from: self))
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

extension Money {
    public func signed() -> Self {
        sign(.default)
    }

    public func color(_ color: Color) -> Self {
        applying {
            $0.color = color
        }
    }

    public func sign(_ sign: Sign) -> Self {
        applying {
            $0.sign = sign
        }
    }

    /// Zero amount will be displayed as "--".
    ///
    /// See: `zeroAmountString` to customize the default value.
    public func dasherizeZeroAmounts() -> Self {
        applying {
            $0.shouldDisplayZeroAmounts = false
        }
    }

    public func attributes(_ attributes: Components.Attributes) -> Self {
        applying {
            $0.attributes = attributes
        }
    }

    public func style(_ style: Components.Style) -> Self {
        applying {
            $0.style = style
        }
    }

    public func attributedString(format: String? = nil) -> NSAttributedString {
        CurrencyFormatter.shared.attributedString(from: self, format: format)
    }

    public func string(format: String? = nil) -> String {
        CurrencyFormatter.shared.string(from: self, format: format)
    }
}
