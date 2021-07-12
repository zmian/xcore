//
// Xcore
// Copyright © 2017 Xcore
// MIT license, see LICENSE file for details
//

import Foundation
import SwiftUI

extension CurrencyFormatter {
    /// Returns a string representation of a given money formatted using money
    /// properties.
    ///
    /// - Parameters:
    ///   - money: The money to format.
    /// - Returns: A string representation of the given money.
    public func string(from money: Money, format: String? = nil) -> String {
        let amountString = components(
            from: money.amount,
            sign: money.sign
        )
        .joined(style: money.style)

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

        guard let foregroundColor = money.foregroundColor else {
            return attributedString
        }

        return attributedString.foregroundColor(foregroundColor)
    }

    private func _attributedStringWithoutColor(from money: Money) -> NSMutableAttributedString {
        let amount = money.amount

        if amount == 0, !money.shouldDisplayZero {
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

extension Money {
    fileprivate var foregroundColor: UIColor? {
        guard color != .none else {
            return nil
        }

        var foregroundColor: UIColor

        if amount == 0 {
            foregroundColor = color.zero
        } else {
            foregroundColor = amount > 0 ? color.positive : color.negative
        }

        return foregroundColor
    }
}

// MARK: - SwiftUI Support

extension Money: View {
    public var body: some View {
        if amount == 0, !shouldDisplayZero {
            Text(zeroString)
        } else {
            let components = formatter.components(from: amount, sign: sign)
            let joinedAmount = components.joined(style: style)

            Text(joinedAmount)
                .unwrap(font.majorUnit) { view, value in
                    view.font(SwiftUI.Font(value))
                }
                .unwrap(foregroundColor) { view, value in
                    view.foregroundColor(SwiftUI.Color(value))
                }
//                .applyIf(shouldSuperscriptMinorUnit) {
//                    EmptyView()
//                }
        }
    }
}

// TODO: Add support for "shouldSuperscriptMinorUnit"

/*
  extension String {
      func rangeFromNSRange(nsRange : NSRange) -> Range<String.Index>? {
          Range(nsRange, in: self)
      }
  }

 let amount = money.amount

 if let minorUnitRange = components.range(style: money.style).minorUnit {
     attributedString.setAttributes(minorUnitFont(money), range: minorUnitRange)
 }

 return attributedString
 */
