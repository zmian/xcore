//
// Xcore
// Copyright © 2017 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

private struct AbbreviatedNumberFormatter<Number: DoubleDecimal> {
    private typealias Abbreviation = (suffix: String, threshold: Number, divisor: Number)

    private let formatter = NumberFormatter().apply {
        $0.numberStyle = .decimal
        $0.minimumIntegerDigits = 1
        $0.minimumFractionDigits = 0
        $0.maximumFractionDigits = 1
    }

    private let abbreviations: [Abbreviation] = [
        ("", 0, 1),
        ("K", 1000, 1000),
        ("M", 499_000, 1_000_000),
        ("M", 1_000_000, 1_000_000),
        ("B", 1_000_000_000, 1_000_000_000),
        ("T", 1_000_000_000_000, 1_000_000_000_000)
    ]

    init(locale: Locale? = nil) {
        if let locale = locale {
            self.formatter.locale = locale
        }
    }

    /// Returns a string representation of the abbreviation of the given value.
    ///
    /// Abbreviates `value` to compact format:
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
    ///   - value: The value to abbreviate.
    ///   - threshold: An optional property to only abbreviate if `value` is
    ///     greater then this value.
    ///   - thresholdAbs: A boolean property indicating whether threshold is of
    ///     absolute value (e.g., `"abs(value)"`).
    ///   - locale: The locale used to format the grouping and decimal separators.
    /// - Returns: Abbreviated version of the `value`.
    func string(
        from value: Number,
        threshold: Number?,
        thresholdAbs: Bool,
        locale: Locale?
    ) -> String {
        // Adopted from: http://stackoverflow.com/a/35504720
        let abbreviation: Abbreviation = {
            let startValue = thresholdAbs ? abs(value) : value

            if let threshold = threshold, startValue <= threshold {
                return abbreviations[0]
            }

            var prevAbbreviation = abbreviations[0]

            for tmpAbbreviation in abbreviations {
                if startValue < tmpAbbreviation.threshold {
                    break
                }
                prevAbbreviation = tmpAbbreviation
            }
            return prevAbbreviation
        }()

        let abbreviatedValue = value / abbreviation.divisor
        formatter.positiveSuffix = abbreviation.suffix
        formatter.negativeSuffix = abbreviation.suffix
        formatter.maximumFractionDigits = value == abbreviatedValue ? .maxFractionDigits : 1
        formatter.locale = locale ?? .current
        return formatter.string(from: abbreviatedValue.nsNumber) ?? "\(abbreviatedValue)"
    }
}

// MARK: - Convenience

extension Decimal {
    private static let abbreviatedNumberFormatter = AbbreviatedNumberFormatter<Self>()

    /// Returns a string representation of the abbreviation of the given value.
    ///
    /// Abbreviates `value` to compact format:
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
    ///   - threshold: An optional property to only abbreviate if `value` is
    ///     greater then this value.
    ///   - thresholdAbs: A boolean property indicating whether threshold is of
    ///     absolute value (e.g., `"abs(value)"`).
    ///   - locale: The locale used to format the grouping and decimal separators.
    /// - Returns: Abbreviated version of the `value`.
    public func abbreviate(
        threshold: Decimal? = nil,
        thresholdAbs: Bool = true,
        locale: Locale? = nil
    ) -> String {
        Self.abbreviatedNumberFormatter.string(
            from: self,
            threshold: threshold,
            thresholdAbs: thresholdAbs,
            locale: locale
        )
    }
}

extension Double {
    private static let abbreviatedNumberFormatter = AbbreviatedNumberFormatter<Self>()

    /// Returns a string representation of the abbreviation of the given value.
    ///
    /// Abbreviates `value` to compact format:
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
    ///   - threshold: An optional property to only abbreviate if `value` is
    ///     greater then this value.
    ///   - thresholdAbs: A boolean property indicating whether threshold is of
    ///     absolute value (e.g., `"abs(value)"`).
    ///   - locale: The locale used to format the grouping and decimal separators.
    /// - Returns: Abbreviated version of the `value`.
    public func abbreviate(
        threshold: Double? = nil,
        thresholdAbs: Bool = true,
        locale: Locale? = nil
    ) -> String {
        Self.abbreviatedNumberFormatter.string(
            from: self,
            threshold: threshold,
            thresholdAbs: thresholdAbs,
            locale: locale
        )
    }
}

// MARK: - Helpers

private protocol DoubleDecimal: SignedNumeric, Comparable {
    var nsNumber: NSNumber { get }
    static func / (lhs: Self, rhs: Self) -> Self
}

extension Double: DoubleDecimal {
    fileprivate var nsNumber: NSNumber {
        NSNumber(value: self)
    }
}

extension Decimal: DoubleDecimal {
    fileprivate var nsNumber: NSNumber {
        NSDecimalNumber(decimal: self)
    }
}
