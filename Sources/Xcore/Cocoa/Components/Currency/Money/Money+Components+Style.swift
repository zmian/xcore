//
// Xcore
// Copyright © 2017 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

extension Money.Components {
    /// A structure representing formatting used to format money components.
    public struct Style {
        public let id: Identifier<Self>
        public let format: (Money.Components) -> String
        public let range: (Money.Components) -> Range

        public init(
            id: Identifier<Self>,
            format: @escaping (Money.Components) -> String,
            range: @escaping (Money.Components) -> Range
        ) {
            self.id = id
            self.format = format
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
    /// Joins all of the money components.
    ///
    /// ```swift
    /// let amount = Money(120.30)
    ///     .style(.default) // ← Specifying style format
    ///
    /// print(amount) // "$120.30"
    /// ```
    public static var `default`: Self {
        .init(
            id: #function,
            format: {
                $0.string(majorUnit: $0.majorUnit, minorUnit: $0.minorUnit)
            },
            range: { $0.ranges }
        )
    }

    /// Removes minor units and then joins all of the money components.
    ///
    /// ```swift
    /// let amount = Money(120.30)
    ///     .style(.removeMinorUnit) // ← Specifying style format
    ///
    /// print(amount) // "$120"
    /// ```
    public static var removeMinorUnit: Self {
        .init(
            id: #function,
            format: { $0.string(majorUnit: $0.majorUnit) },
            range: { ($0.ranges.majorUnit, nil) }
        )
    }

    /// Conditionally removes minor units if the value is zero and then joins
    /// remaining money components.
    ///
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
            format: {
                ($0.isMinorUnitValueZero ? Self.removeMinorUnit : .default)
                    .format($0)
            },
            range: {
                ($0.isMinorUnitValueZero ? Self.removeMinorUnit : .default)
                    .range($0)
            }
        )
    }

    /// Abbreviates the money components to the compact representation.
    ///
    /// ```swift
    /// 987     // → 987
    /// 1200    // → 1.2K
    /// 12000   // → 12K
    /// 120000  // → 120K
    /// 1200000 // → 1.2M
    /// 1340    // → 1.3K
    /// 132456  // → 132.5K
    /// ```
    ///
    /// - Returns: Abbreviated version of `self`.
    public static var abbreviate: Self {
        abbreviate(threshold: 0)
    }

    /// Abbreviates the money components to the compact representation.
    ///
    /// ```swift
    /// 987     // → 987
    /// 1200    // → 1.2K
    /// 12000   // → 12K
    /// 120000  // → 120K
    /// 1200000 // → 1.2M
    /// 1340    // → 1.3K
    /// 132456  // → 132.5K
    /// ```
    ///
    /// - Parameters:
    ///   - threshold: A property to only abbreviate if `amount` is greater then
    ///     this value.
    ///   - thresholdAbs: A boolean property indicating whether threshold is of
    ///     absolute value (e.g., `"abs(value)"`).
    ///   - fallback: The formatting style to use when threshold isn't reached.
    /// - Returns: Abbreviated version of `self`.
    public static func abbreviate(
        threshold: Decimal,
        thresholdAbs: Bool = true,
        fractionDigits: Int = .defaultFractionDigits,
        fallback: Self = .default
    ) -> Self {
        func canAbbreviate(amount: Decimal) -> Bool {
            let compareAmount = thresholdAbs ? abs(amount) : amount
            return compareAmount >= 1000 && compareAmount >= threshold
        }

        return .init(
            id: .init(rawValue: "abbreviation\(threshold)\(fallback.id)"),
            format: {
                guard canAbbreviate(amount: $0.amount) else {
                    return fallback.format($0)
                }

                let amount = $0.amount.abbreviate(
                    threshold: threshold,
                    thresholdAbs: thresholdAbs,
                    fractionDigits: fractionDigits,
                    locale: $0.formatter.locale
                )

                return $0.string(from: amount)
            },
            range: {
                guard canAbbreviate(amount: $0.amount) else {
                    return fallback.range($0)
                }

                return (nil, nil)
            }
        )
    }
}
