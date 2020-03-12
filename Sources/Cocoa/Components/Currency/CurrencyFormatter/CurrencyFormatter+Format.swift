//
// CurrencyFormatter+Format.swift
// Copyright © 2017 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

extension CurrencyFormatter {
    public func attributedString(
        for amount: Double,
        attributes: Currency.Components.Attributes,
        format: String?
    ) -> NSMutableAttributedString? {
        guard let format = format else { return nil }
        let mainFormat = NSMutableAttributedString(string: format, attributes: [.font: attributes.dollarsFont])
        let range = (mainFormat.string as NSString).range(of: "%@")
        guard range.length > 0 else { return nil }
        let formattedDollars = self.attributedString(for: amount, attributes: attributes)
        mainFormat.replaceCharacters(in: range, with: formattedDollars)
        return mainFormat
    }

    public func attributedString(
        for amount: Double,
        attributes: Currency.Components.Attributes,
        style: Currency.Components.Style = .none,
        superscriptCents: Bool = true
    ) -> NSMutableAttributedString {
        let components = self.components(from: amount)
        let joinedAmount = components.joined(style: style)

        let attributedString = NSMutableAttributedString(
            string: joinedAmount,
            attributes: [.font: attributes.dollarsFont]
        )

        guard superscriptCents else {
            return attributedString
        }

        if let centsRange = components.range(style: style).cents {
            attributedString.setAttributes([
                .font: attributes.centsFont,
                .baselineOffset: attributes.centsOffset
            ], range: centsRange)
        }

        return attributedString
    }
}
