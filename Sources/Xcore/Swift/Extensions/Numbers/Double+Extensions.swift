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
        guard let value else {
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
