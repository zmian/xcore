//
// Currency.swift
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

public enum Currency {}

/*
public struct Currency: Equatable, With {
    public init(_ amount: Double? = nil) {
        self.amount = amount
    }

    /// A property to change the formatting style.
    ///
    /// The default value is `.none`.
    public var style: Components.Style = .none

    /// A property to change the attributes to adjust font sizes.
    ///
    /// The default value is `.body`.
    public var attributes: Components.Attributes = .body

    /// A boolean property to indicate whether the color changes based on the amount
    /// using the `positiveColor` and `negativeColor` properties.
    ///
    /// - Note: If this is `false` then `positiveColor` property's value is used.
    ///
    /// The default value is `false`.
    public var isColored = false

    /// A property to indicate whether the output shows the sign (+/-).
    ///
    /// The default value is `false`.
    public var isSigned = false

    /// The color to use when the amount is positive.
    ///
    /// This value is ignored if the `colored` property is `false`.
    ///
    /// The default value is `.appleGreen`.
    public var positiveColor: UIColor = .appleGreen

    /// The color to use when the amount is negative.
    ///
    /// This value is ignored if the `colored` property is `false`.
    ///
    /// The default value is `.appleBlue`.
    public var negativeColor: UIColor = .appleBlue

    /// The custom color to use when the amount is `0`.
    /// This value is ignored if the `colored` property is `false`.
    ///
    /// The default value is `nil`.
    public var zeroAmountColor: UIColor?

    /// The custom string to use when the amount is `0`.
    /// This value is ignored if the `shouldDisplayZeroAmounts` property is `true`.
    ///
    /// The default value is `--`.
    public var customZeroAmountString: String = "--"

    public var shouldDisplayZeroAmounts = true

    /// A property to indicate whether the cents are rendered as superscript.
    ///
    /// The default value is `true`.
    public var shouldSuperscriptCents = true

    public var accessibilityLabel: String? {
        guard let amount = amount else {
            return nil
        }

        return CurrencyFormatter.shared.string(from: amount, style: format)
    }

    public var amount: Double?

    public func value() -> NSAttributedString? {
        return attributedString()?.foregroundColor(foregroundColor)
    }

    private func attributedString() -> NSMutableAttributedString? {
        guard let amount = amount else {
            return nil
        }

        if amount == 0 && !shouldDisplayZeroAmounts {
            return NSMutableAttributedString(string: " " + customZeroAmountString)
        }

        let value = isSigned ? amount : abs(amount) // +/- represented by color

        return CurrencyFormatter.shared.format(
            amount: value,
            attributes: style,
            formattingStyle: format,
            superscriptCents: shouldSuperscriptCents
        )
    }

    private var foregroundColor: UIColor {
        guard isColored, let amount = amount else {
            return positiveColor
        }

        var color: UIColor

        if let zeroAmountColor = zeroAmountColor, amount == 0 {
            color = zeroAmountColor
        } else {
            color = amount >= 0 ? positiveColor : negativeColor
        }

        return color
    }
}

// MARK: - Currency

extension Currency: StringRepresentable {
    public var stringSource: StringSourceType {
        guard let value = value() else {
            return .string("")
        }

        return .attributedString(value)
    }
}
*/
