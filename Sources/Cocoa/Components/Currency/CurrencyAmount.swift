//
// CurrencyAmount.swift
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

// MARK: - FormattingStyle

extension CurrencyAmount {
    public indirect enum FormattingStyle: Equatable {
        case none
        case removeCentsIfZero
        case removeCents
        case abbreviationWith(threshold: Double, fallback: FormattingStyle)

        /// Abbreviate `self` to smaller format.
        ///
        /// ```swift
        /// 987     // -> 987
        /// 1200    // -> 1.2K
        /// 12000   // -> 12K
        /// 120000  // -> 120K
        /// 1200000 // -> 1.2M
        /// 1340    // -> 1.3K
        /// 132456  // -> 132.5K
        /// ```
        ///
        /// - Parameters:
        ///   - threshold: A property to only apply abbreviation
        ///                if `self` is greater then given threshold.
        ///   - fallback: The formatting style to use when threshold isn't reached.
        /// - Returns: Abbreviated version of `self`.
        public static func abbreviation(threshold: Double, fallback: FormattingStyle = .none) -> FormattingStyle {
            var fallback = fallback
            if case .abbreviationWith = fallback {
                #if DEBUG
                fatalError(because: .unsupportedFallbackFormattingStyle)
                #else
                fallback = .none
                #endif
            }
            return .abbreviationWith(threshold: threshold, fallback: fallback)
        }
    }
}

// MARK: - CurrencyAmount

public struct CurrencyAmount: CustomStringConvertible {
    public let amount: Double
    public let dollars: String
    public let cents: String
    public let currencySymbol: String
    public let groupingSeparator: String
    public let decimalSeparator: String
    private var isZeroCents: Bool {
        return cents == "00"
    }

    public init(
        amount: Double,
        dollars: String,
        cents: String,
        currencySymbol: String,
        groupingSeparator: String,
        decimalSeparator: String
    ) {
        self.amount = amount
        self.dollars = dollars
        self.cents = cents
        self.currencySymbol = currencySymbol
        self.groupingSeparator = groupingSeparator
        self.decimalSeparator = decimalSeparator
    }

    public var description: String {
        return joined(style: .none)
    }

    /// Returns a new string by concatenating the components, using the given
    /// formatting style.
    ///
    /// The default value is `.none`.
    ///
    /// - Parameter style: The formatting style to use when joining the components.
    /// - Returns: The joined string based on the given style.
    public func joined(style: FormattingStyle = .none) -> String {
        switch style {
            case .abbreviationWith(let (threshold, fallback)):
                guard amount >= threshold else {
                    return joined(style: fallback)
                }

                return currencySymbol + amount.rounded(places: 2).abbreviate(threshold: threshold)
            case .none:
                return "\(dollars)\(decimalSeparator)\(cents)"
            case .removeCentsIfZero:
                guard isZeroCents else {
                    return "\(dollars)\(decimalSeparator)\(cents)"
                }

                return dollars
            case .removeCents:
                return dollars
        }
    }

    /// The range tuple of the components with respects to the given formatting
    /// style.
    ///
    /// - Parameter style: The formatting style to us when determining the ranges.
    /// - Returns: The tuple with range for each components.
    public func range(style: FormattingStyle = .none) -> (dollars: NSRange?, cents: NSRange?) {
        if case .abbreviationWith(let (threshold, fallback)) = style, amount < threshold {
            return range(style: fallback)
        }

        let dollarsAndDecimalSeparator = "\(dollars)\(decimalSeparator)"
        let dollarsRange = NSRange(location: 0, length: dollarsAndDecimalSeparator.count)
        let centsRange = NSRange(location: dollarsRange.length, length: cents.count)

        let finalDollarsRange = dollarsRange.location == NSNotFound ? nil : dollarsRange
        let finalCentsRange = centsRange.location == NSNotFound ? nil : centsRange

        switch style {
            case .abbreviationWith:
                return (nil, nil)
            case .none:
                return (finalDollarsRange, finalCentsRange)
            case .removeCentsIfZero:
                guard isZeroCents else {
                    return (finalDollarsRange, finalCentsRange)
                }

                return (finalDollarsRange, nil)
            case .removeCents:
                return (finalDollarsRange, nil)
        }
    }
}
