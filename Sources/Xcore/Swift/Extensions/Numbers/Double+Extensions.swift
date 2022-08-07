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
}

// MARK: - Parts

extension Double {
    /// The whole part of the floating point.
    ///
    /// ```swift
    /// let amount = 120.30
    /// // 120 - integer part
    /// // 30 - fractional part
    /// ```
    var integerPart: Double {
        rounded(sign == .minus ? .up : .down)
    }

    /// The fractional part of the floating point.
    ///
    /// ```swift
    /// let amount = 120.30
    /// // 120 - integer part
    /// // 30 - fractional part
    /// ```
    var fractionalPart: Double {
        self - integerPart
    }

    /// A boolean value indicating whether the fractional part of the floating point
    /// is `0`.
    ///
    /// ```swift
    /// print(120.30.isFractionalPartZero)
    /// // Prints "false"
    ///
    /// print(120.00.isFractionalPartZero)
    /// // Prints "true"
    /// ```
    public var isFractionalPartZero: Bool {
        truncatingRemainder(dividingBy: 1) == 0
    }
}

// MARK: - Precision

extension Double {
    /// Returns precision range to be used to ensure at least 2 significant fraction
    /// digits are shown.
    ///
    /// Minimum precision is always set to 2. For higher precisions, for amounts
    /// lower than $0.01, we want to show the first two significant digits after the
    /// decimal point.
    ///
    /// ```swift
    /// $1           → $1.00
    /// $1.234       → $1.23
    /// $1.000031    → $1.00
    /// $0.00001     → $0.00001
    /// $0.000010000 → $0.00001
    /// $0.000012    → $0.000012
    /// $0.00001243  → $0.000012
    /// $0.00001253  → $0.000013
    /// $0.00001283  → $0.000013
    /// $0.000000138 → $0.00000014
    /// ```
    public func calculatePrecision() -> ClosedRange<Int> {
        Decimal(self).calculatePrecision()
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
