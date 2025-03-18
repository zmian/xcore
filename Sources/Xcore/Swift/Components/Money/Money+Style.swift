//
// Xcore
// Copyright © 2017 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

extension Money {
    /// A structure representing formatting styles for `Money`.
    ///
    /// `Money.Style` provides a flexible way to define how monetary values
    /// are formatted, including:
    /// - Displaying minor units (`cents` or `pennies`)
    /// - Removing minor units if they are zero
    /// - Abbreviating large amounts (e.g., `$1.2M`)
    ///
    /// **Usage**
    ///
    /// ```swift
    /// let amount = Money(1200.30)
    ///
    /// let formatted = amount.style(.default)  // "$1,200.30"
    /// let withoutMinorUnit = amount.style(.removeMinorUnit)  // "$1,200"
    /// let abbreviated = Money(1200000).style(.abbreviated)  // "$1.2M"
    /// ```
    public struct Style: Sendable {
        /// A unique identifier for the style.
        public let id: Identifier<Self>

        /// A closure that formats `Money` values according to the style.
        public let format: @Sendable (Money) -> Components

        /// Creates a `Money.Style` with a given formatting function.
        ///
        /// - Parameters:
        ///   - id: A unique identifier for the style.
        ///   - format: A closure that transforms `Money` into formatted components.
        public init(
            id: Identifier<Self>,
            format: @escaping @Sendable (Money) -> Components
        ) {
            self.id = id
            self.format = format
        }

        /// Represents the structured components of a formatted money value.
        ///
        /// This structure provides access to:
        /// - The **raw amount** (without formatting)
        /// - The **formatted amount** (including currency symbols, locale adjustments)
        /// - The **index ranges** for major and minor units within the formatted string.
        public struct Components: Sendable, Hashable {
            /// The raw numeric representation of the money value without currency symbol
            /// and sign (e.g., `"1,200.30"`).
            public let rawAmount: String

            /// The fully formatted monetary value (e.g., `"$1,200.30"`).
            public let formattedAmount: String

            /// The index range for the **major unit** (e.g., `"1,200"` in `"$1,200.30"`).
            public let majorUnitRange: Range<String.Index>?

            /// The index range for the **minor unit** (e.g., `"30"` in `"$1,200.30"`).
            public let minorUnitRange: Range<String.Index>?

            /// Creates a `Components` instance representing formatted money details.
            ///
            /// - Parameters:
            ///   - rawAmount: The numeric string without currency symbol and sign.
            ///   - formattedAmount: The formatted money string.
            ///   - majorUnitRange: The index range for the major unit.
            ///   - minorUnitRange: The index range for the minor unit.
            public init(
                rawAmount: String,
                formattedAmount: String,
                majorUnitRange: Range<String.Index>?,
                minorUnitRange: Range<String.Index>?
            ) {
                self.rawAmount = rawAmount
                self.formattedAmount = formattedAmount
                self.majorUnitRange = majorUnitRange
                self.minorUnitRange = minorUnitRange
            }
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

// MARK: - Built-in Styles

extension Money.Style {
    /// Default formatting style with all components intact.
    ///
    /// ```swift
    /// let amount = Money(120.30)
    ///     .style(.default) // ← Specifying style format
    ///
    /// print(amount) // "$120.30"
    /// ```
    ///
    /// - Returns: A `Money.Style` style with all components intact.
    public static var `default`: Self {
        .init(
            id: #function,
            format: { $0.components(includeMinorUnit: true) }
        )
    }

    /// Removes minor units from the formatted money string.
    ///
    /// ```swift
    /// let amount = Money(120.30)
    ///     .style(.removeMinorUnit) // ← Specifying style format
    ///
    /// print(amount) // "$120"
    /// ```
    ///
    /// - Returns: A `Money.Style` removing minor unit.
    public static var removeMinorUnit: Self {
        .init(
            id: #function,
            format: { $0.components(includeMinorUnit: false) }
        )
    }

    /// Removes minor units if the fractional part is zero.
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
    ///
    /// - Returns: A `Money.Style` removing minor unit when it's value is zero.
    public static var removeMinorUnitIfZero: Self {
        .init(
            id: #function,
            format: {
                ($0.amount.isInteger ? removeMinorUnit : .default)
                    .format($0)
            }
        )
    }

    /// Abbreviates the money components to their compact representation.
    /// (e.g., `$120K`, `$1.2M`).
    ///
    /// ```swift
    /// let amount = Money(1200000)
    ///     .style(.abbreviated)
    ///
    /// print(amount) // "$1.2M"
    ///
    /// 987     // → 987
    /// 1200    // → 1.2K
    /// 12000   // → 12K
    /// 120000  // → 120K
    /// 1200000 // → 1.2M
    /// 1340    // → 1.3K
    /// 132456  // → 132.5K
    /// ```
    ///
    /// - Returns: A `Money.Style` applying abbreviation.
    public static var abbreviated: Self {
        abbreviated(threshold: 0)
    }

    /// Abbreviates the money components to their compact representation with a
    /// customizable threshold.
    ///
    /// ```swift
    /// let amount = Money(1200000)
    ///     .style(.abbreviated(threshold: 0))
    ///
    /// print(amount) // "$1.2M"
    ///
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
    ///   - threshold: The minimum value required before abbreviating amount.
    ///   - fractionLength:The minimum and maximum number of digits after the
    ///     decimal separator.
    ///   - fallback: The formatting style to use when threshold isn't reached.
    /// - Returns: A `Money.Style` applying abbreviation when necessary.
    public static func abbreviated(
        threshold: Decimal,
        fractionLength: ClosedRange<Int> = .defaultFractionDigits,
        fallback: Self = .default
    ) -> Self {
        @Sendable
        func shouldAbbreviate(amount: Decimal) -> Bool {
            let amount = abs(amount)
            return amount >= 1000 && amount >= threshold
        }

        return .init(
            id: .init(rawValue: "abbreviated\(threshold)\(fallback.id)"),
            format: {
                guard shouldAbbreviate(amount: $0.amount) else {
                    return fallback.format($0)
                }

                let amount = $0.amount.formatted(
                    .asAbbreviated(threshold: threshold)
                    .fractionLength(fractionLength)
                    .locale($0.locale)
                    // sign is appended by `string(from:)` method below.
                    .signSymbols(.none)
                )

                return .init(
                    rawAmount: amount,
                    formattedAmount: $0.format(amount),
                    majorUnitRange: nil,
                    minorUnitRange: nil
                )
            }
        )
    }
}

// MARK: - Internal API

extension Money {
    /// Splits the amount into major and minor units.
    func components(includeMinorUnit: Bool) -> Style.Components {
        // 1200.30 → "$1,200.30" → ["1,200", "30"]
        let parts = amount.formatted(
            .number
                .precision(.fractionLength(fractionLength))
                .sign(strategy: .never)
                .locale(locale)
                .grouping(.automatic)
                // When truncating fraction digits, if needed, we should round up.
                // For example, `0.165` → `0.17` instead of `0.16`.
                .rounded(rule: .toNearestOrAwayFromZero)
        )
        .components(separatedBy: decimalSeparator)

        let majorUnit = parts.first ?? "0"
        let minorUnit = parts.dropFirst().first?.replacing("\\D", with: "") ?? "00"

        let rawAmount = [majorUnit, includeMinorUnit ? minorUnit : nil].joined(separator: decimalSeparator)
        let formattedString = format(rawAmount)
        let majorRange = formattedString.range(of: majorUnit)
        let minorRange = includeMinorUnit ? formattedString.range(of: minorUnit) : nil

        return .init(
            rawAmount: rawAmount,
            formattedAmount: formattedString,
            majorUnitRange: majorRange,
            minorUnitRange: minorRange
        )
    }

    fileprivate func format(_ amount: String) -> String {
        switch currencySymbolPosition {
            case .prefix:
                "\(sign)\(currencySymbol)\(amount)"
            case .suffix:
                "\(sign)\(amount) \(currencySymbol)"
        }
    }
}
