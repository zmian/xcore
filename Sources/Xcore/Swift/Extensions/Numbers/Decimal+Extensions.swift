//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

extension Decimal {
    /// Rounds the value to an integral value using the specified rounding rule.
    ///
    /// The following example rounds a value using four different rounding rules:
    ///
    ///     // Equivalent to the C 'round' function:
    ///     var w = Decimal(6.5)
    ///     w.round(.toNearestOrAwayFromZero)
    ///     // w == 7.0
    ///
    ///     // Equivalent to the C 'trunc' function:
    ///     var x = Decimal(6.5)
    ///     x.round(.towardZero)
    ///     // x == 6.0
    ///
    ///     // Equivalent to the C 'ceil' function:
    ///     var y = Decimal(6.5)
    ///     y.round(.up)
    ///     // y == 7.0
    ///
    ///     // Equivalent to the C 'floor' function:
    ///     var z = Decimal(6.5)
    ///     z.round(.down)
    ///     // z == 6.0
    ///
    /// For more information about the available rounding rules, see the
    /// `FloatingPointRoundingRule` enumeration. To round a value using the default
    /// "schoolbook rounding", you can use the shorter `round()` method instead.
    ///
    /// ```swift
    /// var w1 = 6.5
    /// w1.round()
    /// // w1 == 7.0
    /// ```
    ///
    /// Use the fraction digits parameter to customize the output:
    ///
    /// ```swift
    /// var w2 = Decimal(6.5)
    /// w2.round(fractionDigits: 2)
    /// // w2 == 6.50
    /// ```
    ///
    /// - Parameters:
    ///   - rule: The rounding rule to use.
    ///   - fractionDigits: The number of digits result can have after its decimal
    ///     point.
    public mutating func round(
        _ rule: FloatingPointRoundingRule = .toNearestOrAwayFromZero,
        fractionDigits: Int = 0
    ) {
        var original = self
        NSDecimalRound(&self, &original, fractionDigits, .init(rule, for: self))
    }

    /// Returns this value rounded to an integral value using the specified rounding
    /// rule.
    ///
    /// The following example rounds a value using four different rounding rules:
    ///
    /// ```swift
    /// let x = Decimal(6.5)
    ///
    /// // Equivalent to the C 'round' function:
    /// print(x.rounded(.toNearestOrAwayFromZero))
    /// // Prints "7.0"
    ///
    /// // Equivalent to the C 'trunc' function:
    /// print(x.rounded(.towardZero))
    /// // Prints "6.0"
    ///
    /// // Equivalent to the C 'ceil' function:
    /// print(x.rounded(.up))
    /// // Prints "7.0"
    ///
    /// // Equivalent to the C 'floor' function:
    /// print(x.rounded(.down))
    /// // Prints "6.0"
    /// ```
    ///
    /// For more information about the available rounding rules, see the
    /// `FloatingPointRoundingRule` enumeration. To round a value using the default
    /// "schoolbook rounding", you can use the shorter `rounded()` method instead.
    ///
    /// ```swift
    /// print(x.rounded())
    /// // Prints "7.0"
    /// ```
    ///
    /// Use the fraction digits parameter to customize the output:
    ///
    /// ```swift
    /// print(x.rounded(2))
    /// // Prints "6.50"
    /// ```
    ///
    /// - Parameters:
    ///   - rule: The rounding rule to use.
    ///   - fractionDigits: The number of digits result can have after its decimal
    ///     point.
    /// - Returns: The integral value found by rounding using `rule`.
    public func rounded(
        _ rule: FloatingPointRoundingRule = .toNearestOrAwayFromZero,
        fractionDigits: Int = 0
    ) -> Self {
        var copy = self
        copy.round(rule, fractionDigits: fractionDigits)
        return copy
    }
}

// MARK: - Helpers

extension Decimal.RoundingMode {
    /// - SeeAlso: https://gist.github.com/natecook1000/27d31d73315ffc2c80a7b4efc5788bd0
    fileprivate init(_ rule: FloatingPointRoundingRule, for value: Decimal) {
        switch rule {
            case .down:
                self = .down
            case .up:
                self = .up
            case .awayFromZero:
                self = value < 0 ? .down : .up
            case .towardZero:
                self = value < 0 ? .up : .down
            case .toNearestOrAwayFromZero:
                self = .plain
            case .toNearestOrEven:
                self = .bankers
            @unknown default:
                warnUnknown(rule)
                self = .plain
        }
    }
}

// MARK: - Precision

extension Decimal {
    /// Returns precision to be used consering the for the current value
    ///
    /// Minimum precision is always set to 2
    /// For longer precisions, for amounts lower than $0.01, we want to show
    /// the first two significant digits after the decimal point.
    ///
    /// $1.234 -> $1.23
    /// $1.000031 -> $1.00
    /// $0.00001 -> $0.0001
    /// $0.000000138 -> $0.00000014
    ///
    internal func calculatePrecision() -> ClosedRange<Int> {
        let absAmount = abs(self)

        if absAmount > 0 && absAmount < 0.01 {
            // 1. Count the number of digits after the decimal point
            let significantFractionalDecimalDigits = Int(absAmount.significantFractionalDecimalDigits)
            // 2. Count the number of significant difigts after the decimal point
            let significandCount = Int((absAmount.significand as NSDecimalNumber).uint64Value.digitsCount)
            // 3. Precision will be the # of zeros plus the default precision of 2
            let numberOfZeros = significantFractionalDecimalDigits - significandCount

            return 2...(numberOfZeros + 2)
        }

        return 2...2
    }
}

// MARK: - Fractional

extension Decimal {
    /// Calculate the number of digits after the decimal point
    fileprivate var significantFractionalDecimalDigits: Int {
        return max(-exponent, 0)
    }
}
