//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import Foundation
import CoreGraphics

// MARK: - Random

extension Double {
    /// Returns a random value within the specified range.
    public static func random(_ lower: Double = 0, _ upper: Double = Double.defaultRandomUpperBound) -> Double {
        .random(in: lower...upper)
    }
}

// MARK: - Round

extension Double {
    /// Returns this value rounded to an integral value using the specified rounding
    /// fraction digits.
    ///
    /// ```swift
    /// 1      → "1.00"
    /// 1.09   → "1.09"
    /// 1.9    → "1.90"
    /// 2.1345 → "2.13"
    /// 2.1355 → "2.14"
    /// ```
    ///
    /// - Parameters:
    ///   - rule: The rounding rule to use.
    ///   - fractionDigits: The number of digits result can have after its decimal
    ///     point.
    public func rounded(
        _ rule: FloatingPointRoundingRule = .toNearestOrAwayFromZero,
        fractionDigits: Int
    ) -> Double {
        let multiplier = pow(10.0, Double(fractionDigits))
        return (self * multiplier).rounded(rule) / multiplier
    }

    /// Returns this value rounded to an integral value using the specified rounding
    /// fraction digits.
    ///
    /// - Parameters:
    ///   - rule: The rounding rule to use.
    ///   - fractionDigits: The number of digits result can have after its decimal
    ///     point.
    public func formatted(
        _ rule: FloatingPointRoundingRule = .toNearestOrAwayFromZero,
        fractionDigits: Int
    ) -> String {
        String(
            format: "%.\(fractionDigits)f%",
            rounded(rule, fractionDigits: fractionDigits)
        )
    }
}

// MARK: - Conversion

extension Double {
    public init(truncating number: Decimal) {
        self.init(truncating: NSDecimalNumber(decimal: number))
    }

    @_disfavoredOverload
    public init?(any value: Any?) {
        guard let value = value else {
            return nil
        }

        if let value = value as? LosslessStringConvertible {
            self.init(value.description)
            return
        }

        if let cgfloat = value as? CGFloat {
            self.init(cgfloat)
            return
        }

        if let double = (value as? Decimal)?.doubleValue {
            self.init(double)
            return
        }

        return nil
    }

    /// The `locale` is always set to `usPosix` to avoid localizing string
    /// representations of numbers which are used for strictly conversion purpose
    /// only.
    var stringValue: String {
        NSNumber(value: self)
            .description(withLocale: Locale.usPosix)
    }
}

// MARK: - Formatted

extension Double {
    private static let formatter = NumberFormatter().apply {
        $0.numberStyle = .decimal
        $0.maximumFractionDigits = .maxFractionDigits
    }

    @available(iOS, introduced: 14, deprecated: 15, message: "Use .formattedString() directly.")
    public func formattedString() -> String {
        Self.formatter.string(from: self) ?? ""
    }

//    @available(iOS 15.0, *)
//    public func formattedString() -> String {
//        formatted(.number.precision(.fractionLength(0...Int.maxFractionDigits)))
//    }
}
