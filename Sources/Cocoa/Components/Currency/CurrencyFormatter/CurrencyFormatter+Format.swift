//
// Xcore
// Copyright © 2017 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

extension CurrencyFormatter {
    /// Returns a string representation of a given money formatted using money
    /// properties.
    ///
    /// - Parameters:
    ///   - money: The money to format.
    /// - Returns: A string representation of the given money.
    public func string(from money: Money, format: String? = nil) -> String {
        let amountString = components(from: money.amount, sign: money.sign).joined(style: money.style)

        guard let format = format else {
            return amountString
        }

        return String(format: format, amountString)
    }

    public func attributedString(from money: Money, format: String? = nil) -> NSMutableAttributedString {
        let formattedMoney = _attributedString(from: money)

        guard let format = format else {
            return formattedMoney
        }

        let range = (format as NSString).range(of: "%@")

        guard range.length > 0 else {
            return formattedMoney
        }

        let mainFormat = NSMutableAttributedString(string: format, attributes: majorUnitFont(money))
        mainFormat.replaceCharacters(in: range, with: formattedMoney)
        return mainFormat
    }
}

extension CurrencyFormatter {
    private func _attributedString(from money: Money) -> NSMutableAttributedString {
        let attributedString = _attributedStringWithoutColor(from: money)

        guard let foregroundColor = foregroundColor(money) else {
            return attributedString
        }

        return attributedString.foregroundColor(foregroundColor)
    }

    private func _attributedStringWithoutColor(from money: Money) -> NSMutableAttributedString {
        let amount = money.amount

        if amount == 0 && !money.shouldDisplayZero {
            return NSMutableAttributedString(string: " " + money.zeroString)
        }

        let components = self.components(from: amount, sign: money.sign)
        let joinedAmount = components.joined(style: money.style)

        let attributedString = NSMutableAttributedString(
            string: joinedAmount,
            attributes: majorUnitFont(money)
        )

        guard money.shouldSuperscriptMinorUnit else {
            return attributedString
        }

        if let minorUnitRange = components.range(style: money.style).minorUnit {
            attributedString.setAttributes(minorUnitFont(money), range: minorUnitRange)
        }

        return attributedString
    }

    private func foregroundColor(_ money: Money) -> UIColor? {
        let color = money.color

        guard color != .none else {
            return nil
        }

        let amount = money.amount
        var foregroundColor: UIColor

        if amount == 0 {
            foregroundColor = color.zero
        } else {
            foregroundColor = amount > 0 ? color.positive : color.negative
        }

        return foregroundColor
    }
}

// MARK: - Helpers

extension CurrencyFormatter {
    private func majorUnitFont(_ money: Money) -> [NSAttributedString.Key: Any] {
        [.font: money.font.majorUnit].compactMapValues { $0 }
    }

    private func minorUnitFont(_ money: Money) -> [NSAttributedString.Key: Any] {
        let attributes: [NSAttributedString.Key: Any?] = [
            .font: money.font.minorUnit,
            .baselineOffset: money.font.minorUnitOffset
        ]

        return attributes.compactMapValues { $0 }
    }
}
