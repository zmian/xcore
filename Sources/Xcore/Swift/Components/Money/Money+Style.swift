//
// Xcore
// Copyright © 2017 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

extension Money {
    /// A structure representing formatting used to format money components.
    public struct Style {
        public typealias Components = (majorUnit: String, minorUnit: String)
        public typealias Range = (majorUnit: NSRange?, minorUnit: NSRange?)
        public let id: Identifier<Self>
        public let format: (Money) -> String
        public let range: (Money) -> Range

        public init(
            id: Identifier<Self>,
            format: @escaping (Money) -> String,
            range: @escaping (Money) -> Range
        ) {
            self.id = id
            self.format = format
            self.range = range
        }
    }
}

// MARK: - Equatable

extension Money.Style: Equatable {
    public static func ==(lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: - Hashable

extension Money.Style: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

// MARK: - Built-in

extension Money.Style {
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
                let components = $0.components()
                return $0.string(majorUnit: components.majorUnit, minorUnit: components.minorUnit)
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
            format: { $0.string(majorUnit: $0.components().majorUnit) },
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
                ($0.amount.isFractionZero ? Self.removeMinorUnit : .default)
                    .format($0)
            },
            range: {
                ($0.amount.isFractionZero ? Self.removeMinorUnit : .default)
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
        fractionLength: ClosedRange<Int> = 0...Int.defaultFractionDigits,
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
                    fractionLength: fractionLength,
                    locale: $0.locale
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

// MARK: - Internal API

extension Money {
    func components() -> Style.Components {
        // 1200.30 → "$1,200.30" → ["1,200", "30"]
        let parts: [String]

        if #available(iOS 15.0, *) {
            parts = amount
                .formatted(
                    .number
                    .precision(.fractionLength(fractionLength))
                    .sign(strategy: .never)
                    .locale(locale)
                    // When truncating fraction digits, if needed, we should round up.
                    // For example, `0.165` → `0.17` instead of `0.16`.
                    .rounded(rule: .toNearestOrAwayFromZero)
                )
                .components(separatedBy: decimalSeparator)
        } else {
            parts = MoneyFormatter.shared
                .string(from: amount, fractionLength: fractionLength)
                .components(separatedBy: decimalSeparator)
        }

        var majorUnit = "0"
        var minorUnit = "00"

        if let majorUnitString = parts.first {
            majorUnit = majorUnitString
        }

        if let minorUnitString = parts.at(1) {
            minorUnit = minorUnitString.replacing("\\D", with: "")
        }

        return (majorUnit: majorUnit, minorUnit: minorUnit)
    }

    var ranges: Style.Range {
        let components = components()
        let majorUnitAndDecimalSeparator = "\(string(majorUnit: components.majorUnit))\(decimalSeparator)"
        let majorUnitRange = NSRange(location: 0, length: majorUnitAndDecimalSeparator.count)
        let minorUnitRange = NSRange(location: majorUnitRange.length, length: components.minorUnit.count)

        let finalMajorUnitRange = majorUnitRange.location == NSNotFound ? nil : majorUnitRange
        let finalMinorUnitRange = minorUnitRange.location == NSNotFound ? nil : minorUnitRange

        return (finalMajorUnitRange, finalMinorUnitRange)
    }

    fileprivate func string(majorUnit: String, minorUnit: String? = nil) -> String {
        string(from: [majorUnit, minorUnit].joined(separator: decimalSeparator))
    }

    fileprivate func string(from amount: String) -> String {
        let sign = currentSign

        switch currencySymbolPosition {
            case .prefix:
                return "\(sign)\(currencySymbol)\(amount)"
            case .suffix:
                return "\(sign)\(amount) \(currencySymbol)"
        }
    }
}
