//
// Xcore
// Copyright © 2017 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

extension Money {
    /// A structure representing components of the given amount and constructs money
    /// from their constituent parts.
    public struct Components: Equatable, CustomStringConvertible {
        public typealias Range = (majorUnit: NSRange?, minorUnit: NSRange?)

        /// The amount of money.
        public let amount: Decimal

        /// The major unit of the amount.
        ///
        /// ```swift
        /// let amount = Decimal(120.30)
        /// // 120 - major unit
        /// // 30 - minor unit
        /// ```
        public let majorUnit: String

        /// The minor unit of the amount.
        ///
        /// ```swift
        /// let amount = Decimal(120.30)
        /// // 120 - major unit
        /// // 30 - minor unit
        /// ```
        public let minorUnit: String

        /// The currency symbol associated with the amount.
        ///
        /// For example, `$` for US dollars.
        public let currencySymbol: String

        /// The grouping separator associated with the amount.
        ///
        /// For example, United States uses comma (`"10,000.00"`) whereas in France
        /// space (`"10 000,00"`) is used instead for grouping separator.
        public let groupingSeparator: String

        /// The decimal separator associated with the amount.
        ///
        /// For example, United States uses period (`"10,000.00"`) whereas in France
        /// comma (`"10 000,00"`) is used instead for decimal separator.
        public let decimalSeparator: String

        public init(
            amount: Decimal,
            majorUnit: String,
            minorUnit: String,
            currencySymbol: String,
            groupingSeparator: String,
            decimalSeparator: String
        ) {
            self.amount = amount
            self.majorUnit = majorUnit
            self.minorUnit = minorUnit
            self.currencySymbol = currencySymbol
            self.groupingSeparator = groupingSeparator
            self.decimalSeparator = decimalSeparator
        }

        public var description: String {
            joined(style: .default)
        }

        /// Returns a new string by concatenating the components, using the given
        /// formatting style.
        ///
        /// The default value is `.default`.
        ///
        /// - Parameter style: The formatting style to use when joining the components.
        /// - Returns: The joined string based on the given style.
        public func joined(style: Style = .default) -> String {
            style.join(self)
        }

        /// The range tuple of the components with respects to the given formatting
        /// style.
        ///
        /// - Parameter style: The formatting style to us when determining the ranges.
        /// - Returns: The tuple with range for each components.
        public func range(style: Style = .default) -> Range {
            style.range(self)
        }
    }
}

// MARK: - Internal API

extension Money.Components {
    var isMinorUnitValueZero: Bool {
        minorUnit == "00"
    }

    var ranges: Range {
        let majorUnitAndDecimalSeparator = "\(majorUnit)\(decimalSeparator)"
        let majorUnitRange = NSRange(location: 0, length: majorUnitAndDecimalSeparator.count)
        let minorUnitRange = NSRange(location: majorUnitRange.length, length: minorUnit.count)

        let finalMajorUnitRange = majorUnitRange.location == NSNotFound ? nil : majorUnitRange
        let finalMinorUnitRange = minorUnitRange.location == NSNotFound ? nil : minorUnitRange

        return (finalMajorUnitRange, finalMinorUnitRange)
    }
}
