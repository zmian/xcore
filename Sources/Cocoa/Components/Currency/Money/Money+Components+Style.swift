//
// Xcore
// Copyright © 2017 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

extension Money.Components {
    /// An structure that represent formatting styles for money components.
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

        public static func ==(lhs: Self, rhs: Self) -> Bool {
            lhs.id == rhs.id
        }
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
    public static var none: Self {
        .init(
            id: #function,
            join: { "\($0.majorUnit)\($0.decimalSeparator)\($0.minorUnit)" },
            range: { $0.ranges }
        )
    }

    /// ```swift
    /// let amount = Decimal(120.30)
    /// // 120 - major unit
    /// // 30 - minor unit
    /// ```
    public static var removeMinorUnit: Self {
        .init(
            id: #function,
            join: { $0.majorUnit },
            range: { ($0.ranges.majorUnit, nil) }
        )
    }

    /// ```swift
    /// let amount = Decimal(120.30)
    /// // 120 - major unit
    /// // 30 - minor unit
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
    public static func abbreviation(threshold: Decimal, fallback: Self = .none) -> Self {
        .init(
            id: .init(rawValue: "abbreviation\(threshold)\(fallback.id)"),
            join: {
                guard
                    $0.amount >= threshold,
                    let amountValue = Double(exactly: NSDecimalNumber(decimal: $0.amount.rounded(2))),
                    let thresholdValue = Double(exactly: NSDecimalNumber(decimal: threshold))
                else {
                    return fallback.join($0)
                }

                return $0.currencySymbol + amountValue.abbreviate(threshold: thresholdValue)
            },
            range: {
                if $0.amount < threshold {
                    return fallback.range($0)
                }

                return (nil, nil)
            }
        )
    }
}
