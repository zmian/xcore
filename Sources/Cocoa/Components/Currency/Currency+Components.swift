//
// Xcore
// Copyright © 2017 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

extension Currency {
    /// A structure that parses currency into and constructs currency from their
    /// constituent parts.
    public struct Components: CustomStringConvertible {
        public typealias Range = (dollars: NSRange?, cents: NSRange?)

        public let amount: Double
        public let dollars: String
        public let cents: String
        public let currencySymbol: String
        public let groupingSeparator: String
        public let decimalSeparator: String
        private var isZeroCents: Bool {
            cents == "00"
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
            joined(style: .none)
        }

        /// Returns a new string by concatenating the components, using the given
        /// formatting style.
        ///
        /// The default value is `.none`.
        ///
        /// - Parameter style: The formatting style to use when joining the components.
        /// - Returns: The joined string based on the given style.
        public func joined(style: Style = .none) -> String {
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
        public func range(style: Style = .none) -> Range {
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
}
