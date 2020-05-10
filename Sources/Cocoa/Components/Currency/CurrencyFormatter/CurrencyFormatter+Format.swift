//
// Xcore
// Copyright © 2017 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

extension CurrencyFormatter {
    /// Returns a string representation of a given value formatted using the given
    /// style.
    ///
    /// - Parameters:
    ///   - value: The value to format.
    ///   - style: The style to format the result.
    ///   - sign: The sign to use when formatting the result.
    /// - Returns: A string representation of a given value formatted using the
    ///            given style.
    public func string(from currency: Currency) -> String {
        guard let amount = currency.amount else {
            return ""
        }

        return components(from: amount, sign: currency.sign).joined(style: currency.style)
    }

    public func attributedString(from currency: Currency, format: String? = nil) -> NSMutableAttributedString {
        let formattedCurrency = _attributedString(from: currency)

        guard
            let format = format,
            currency.amount != nil
        else {
            return formattedCurrency
        }

        let range = (format as NSString).range(of: "%@")

        guard range.length > 0 else {
            return formattedCurrency
        }

        let mainFormat = NSMutableAttributedString(string: format, attributes: [
            .font: currency.attributes.majorUnitFont
        ])
        mainFormat.replaceCharacters(in: range, with: formattedCurrency)
        return mainFormat
    }
}

extension CurrencyFormatter {
    private func _attributedString(from currency: Currency) -> NSMutableAttributedString {
        let attributedString = _attributedStringWithoutColor(from: currency)

        guard let foregroundColor = foregroundColor(currency) else {
            return attributedString
        }

        return attributedString.foregroundColor(foregroundColor)
    }

    private func _attributedStringWithoutColor(from currency: Currency) -> NSMutableAttributedString {
        guard let amount = currency.amount else {
            return NSMutableAttributedString(string: "")
        }

        if amount == 0 && !currency.shouldDisplayZeroAmounts {
            return NSMutableAttributedString(string: " " + currency.zeroAmountString)
        }

        let components = self.components(from: amount, sign: currency.sign)
        let joinedAmount = components.joined(style: currency.style)

        let attributedString = NSMutableAttributedString(
            string: joinedAmount,
            attributes: [.font: currency.attributes.majorUnitFont]
        )

        guard currency.shouldSuperscriptMinorUnit else {
            return attributedString
        }

        if let minorUnitRange = components.range(style: currency.style).minorUnit {
            attributedString.setAttributes([
                .font: currency.attributes.minorUnitFont,
                .baselineOffset: currency.attributes.minorUnitOffset
            ], range: minorUnitRange)
        }

        return attributedString
    }

    private func foregroundColor(_ currency: Currency) -> UIColor? {
        guard let amount = currency.amount else {
            return nil
        }

        let color = currency.color

        guard color != .none else {
            return nil
        }

        var foregroundColor: UIColor

        if let zeroAmountColor = color.zero, amount == 0 {
            foregroundColor = zeroAmountColor
        } else {
            foregroundColor = amount >= 0 ? color.positive : color.negative
        }

        return foregroundColor
    }
}
