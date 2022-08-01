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

        /// The money used to extract the components.
        public let money: Money

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

        public init(
            money: Money,
            majorUnit: String,
            minorUnit: String
        ) {
            self.money = money
            self.majorUnit = majorUnit
            self.minorUnit = minorUnit
        }

        public var description: String {
            formatted()
        }

        /// Returns a new string by concatenating the components, using the given
        /// formatting style.
        ///
        /// The default value is `.default`.
        ///
        /// - Parameter style: The formatting style for the components.
        /// - Returns: A formatted string based on the given style.
        public func formatted(style: Style = .default) -> String {
            style.format(self)
        }

        /// The range tuple of the components with respects to the given formatting
        /// style.
        ///
        /// - Parameter style: The formatting style to us when determining the ranges.
        /// - Returns: A tuple with range for each components.
        public func range(style: Style = .default) -> Range {
            style.range(self)
        }
    }
}

// MARK: - Internal API

extension Money.Components {
    var isMinorUnitValueZero: Bool {
        money.amount.exponent == 1
    }

    var ranges: Range {
        let majorUnitAndDecimalSeparator = "\(string(majorUnit: majorUnit))\(money.decimalSeparator)"
        let majorUnitRange = NSRange(location: 0, length: majorUnitAndDecimalSeparator.count)
        let minorUnitRange = NSRange(location: majorUnitRange.length, length: minorUnit.count)

        let finalMajorUnitRange = majorUnitRange.location == NSNotFound ? nil : majorUnitRange
        let finalMinorUnitRange = minorUnitRange.location == NSNotFound ? nil : minorUnitRange

        return (finalMajorUnitRange, finalMinorUnitRange)
    }

    func string(majorUnit: String, minorUnit: String? = nil) -> String {
        string(from: [majorUnit, minorUnit].joined(separator: money.decimalSeparator))
    }

    func string(from amount: String) -> String {
        let sign = money.currentSign

        switch money.currencySymbolPosition {
            case .prefix:
                return "\(sign)\(money.currencySymbol)\(amount)"
            case .suffix:
                return "\(sign)\(amount) \(money.currencySymbol)"
        }
    }
}
