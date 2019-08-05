//
// CurrencyFormatter+Format.swift
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
