//
// Xcore
// Copyright © 2017 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

extension Money.Components {
    /// A structure representing formatting used to display money components.
    public struct Style {
        public let id: Identifier<Self>
        let join: (Money.Components) -> String
        let range: (Money.Components) -> Range

        public init(
            id: Identifier<Self>,
            join: @escaping (Money.Components) -> String,
            range: @escaping (Money.Components) -> Range
        ) {
            self.id = id
            self.join = join
            self.range = range
        }
    }
}

// MARK: - Equatable

extension Money.Components.Style: Equatable {
    public static func ==(lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: - Hashable

extension Money.Components.Style: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

// MARK: - Built-in

extension Money.Components.Style {
    /// ```swift
    /// let amount = Money(120.30)
    ///     .style(.default) // ← Specifying style format
    ///
    /// print(amount) // "$120.30"
    /// ```
    public static var `default`: Self {
        .init(
            id: #function,
            join: { "\($0.majorUnit)\($0.decimalSeparator)\($0.minorUnit)" },
            range: { $0.ranges }
        )
    }

    /// ```swift
    /// let amount = Money(120.30)
    ///     .style(.removeMinorUnit) // ← Specifying style format
    ///
    /// print(amount) // "$120"
    /// ```
    public static var removeMinorUnit: Self {
        .init(
            id: #function,
            join: { $0.majorUnit },
            range: { ($0.ranges.majorUnit, nil) }
        )
    }

    /// ```swift
    /// let amount = Money(120.30)
    ///     .style(.removeMinorUnitIfZero) // ← Specifying style format
    ///
    /// print(amount) // "$120.30"
    ///
    /// let amount = Money(120.00)
    ///     .style(.removeMinorUnitIfZero) // ← Specifying style format
    ///
    /// print(amount) // "$120"
    /// ```
    public static var removeMinorUnitIfZero: Self {
        .init(
            id: #function,
            join: {
                guard $0.isMinorUnitValueZero else {
                    return "\($0.majorUnit)\($0.decimalSeparator)\($0.minorUnit)"
                }

                return $0.majorUnit
            },
            range: {
                let ranges = $0.ranges

                guard $0.isMinorUnitValueZero else {
                    return ranges
                }

                return (ranges.majorUnit, nil)
            }
        )
    }

    /// Abbreviate amount to compact format.
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
    ///   - threshold: A property to only apply abbreviation if `self` is greater
    ///                then given threshold.
    ///   - fallback: The formatting style to use when threshold isn't reached.
    /// - Returns: Abbreviated version of `self`.
    public static func abbreviation(threshold: Decimal, fallback: Self = .default) -> Self {
        func canAbbreviation(amount: Decimal) -> (amount: Double, threshold: Double)? {
            guard
                amount >= 1000,
                amount >= threshold,
                let amountValue = Double(exactly: NSDecimalNumber(decimal: amount.rounded(2))),
                let thresholdValue = Double(exactly: NSDecimalNumber(decimal: threshold))
            else {
                return nil
            }

            return (amountValue, thresholdValue)
        }

        return .init(
            id: .init(rawValue: "abbreviation\(threshold)\(fallback.id)"),
            join: {
                guard let value = canAbbreviation(amount: $0.amount) else {
                    return fallback.join($0)
                }

                return $0.currencySymbol + value.amount.abbreviate(threshold: value.threshold)
            },
            range: {
                guard canAbbreviation(amount: $0.amount) != nil else {
                    return fallback.range($0)
                }

                return (nil, nil)
            }
        )
    }
}
