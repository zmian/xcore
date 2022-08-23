//
// Xcore
// Copyright © 2017 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

// MARK: - Formatted

extension Money {
    /// Returns a locale-aware string representation.
    ///
    /// - Parameter format: An optional string format.
    /// - Returns: A locale-aware string representation.
    public func formatted(format: String? = nil) -> String {
        if amount == 0, let zeroString = zeroString {
            return zeroString
        }

        let amountString = style.format(self)

        guard let format else {
            return amountString
        }

        return String(format: format, amountString)
    }
}

// MARK: - AttributedString

extension Money {
    /// Returns a locale-aware attributed string representation.
    ///
    /// - Parameter format: An optional string format.
    /// - Returns: A locale-aware attributed string representation.
    @available(iOS 15, *)
    public func attributedString(format: String? = nil) -> AttributedString {
        if amount == 0, let zeroString = zeroString {
            return AttributedString(zeroString)
        }

        var attributedString = AttributedString(style.format(self))

        // ForegroundColor
        if let foregroundColor = foregroundColor {
            attributedString.foregroundColor = foregroundColor
        }

        // Font
        if let font = font {
            attributedString.font = font.majorUnit

            // Superscript: MinorUnit
            if superscriptMinorUnitEnabled, let minorUnitInfo = font.minorUnit {
                if let minorUnitRange = style.range(self).minorUnit {
                    if let range = Range(minorUnitRange, in: attributedString) {
                        attributedString.setAttributes(minorUnitInfo, range: range)
                    }
                }
            }

            // Superscript: CurrencySymbol
            if
                let currencySymbolInfo = font.currencySymbol,
                let range = attributedString.range(of: currencySymbol)
            {
                attributedString.setAttributes(currencySymbolInfo, range: range)
            }
        }

        // Format String
        if let format = format {
            var formatAttributedString = AttributedString(format)
            if let range = formatAttributedString.range(of: "%@") {
                formatAttributedString.replaceSubrange(range, with: attributedString)
                return formatAttributedString
            }
        }

        return attributedString
    }
}

// MARK: - Helpers

extension Money {
    private var foregroundColor: SwiftUI.Color? {
        guard let color else {
            return nil
        }

        if amount == 0 {
            return color.zero
        }

        return amount > 0 ? color.positive : color.negative
    }
}

@available(iOS 15, *)
extension AttributedString {
    fileprivate mutating func setAttributes(_ attributes: Money.Font.Superscript, range: Range<Index>) {
        var attributeContainer = AttributeContainer()
        attributeContainer.font = attributes.font
        attributeContainer.baselineOffset = attributes.baselineOffset
        self[range].mergeAttributes(attributeContainer)
    }
}
