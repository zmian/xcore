//
// Xcore
// Copyright © 2017 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

public struct Currency: Equatable, MutableAppliable {
    public init(_ amount: Double? = nil) {
        self.amount = amount
        color = Self.appearance().color
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
    public var color: Color

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

    public var accessibilityLabel: String? {
        guard let amount = amount else {
            return nil
        }

        return CurrencyFormatter.shared.string(from: amount, style: style)
    }

    public var amount: Double?
}

// MARK: - ExpressibleByFloatLiteral

extension Currency: ExpressibleByFloatLiteral {
    public init(floatLiteral value: FloatLiteralType) {
        self.init(Double(value))
    }
}

// MARK: - ExpressibleByIntegerLiteral

extension Currency: ExpressibleByIntegerLiteral {
    public init(integerLiteral value: IntegerLiteralType) {
        self.init(Double(value))
    }
}

// MARK: - CustomStringConvertible

extension Currency: CustomStringConvertible {
    public var description: String {
        #warning("FIXME: Make Amount required")
        return CurrencyFormatter.shared.string(from: amount ?? 0, style: style, sign: sign)
    }
}

// MARK: - StringRepresentable

extension Currency: StringRepresentable {
    public var stringSource: StringSourceType {
        .attributedString(CurrencyFormatter.shared.attributedString(from: self))
    }
}

// MARK: - Appearance

extension Currency {
    /// This configuration exists to allow some of the properties to be configured
    /// to match app's appearance style. The `UIAppearance` protocol doesn't work
    /// when the stored properites are set using associated object.
    ///
    /// **Usage:**
    ///
    /// ```swift
    /// Currency.appearance().color = Color(positive: .systemGreen, negative: .systemRed)
    /// ```
    final public class Appearance: Appliable {
        public var color = Color.none
        public var shouldSuperscriptMinorUnit = false
    }

    private static var appearanceProxy = Appearance()
    public static func appearance() -> Appearance {
        appearanceProxy
    }
}
