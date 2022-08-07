//
// Xcore
// Copyright © 2022 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

/// A type that represents either a `Double` or a `Decimal` floating-point value
/// type.
public protocol DoubleOrDecimalProtocol: SignedNumeric, Comparable, Hashable, Codable {
    var nsNumber: NSNumber { get }

    /// A boolean value indicating whether the fractional part of the decimal is
    /// `0`.
    ///
    /// ```swift
    /// print(Decimal(120.30).isFractionalPartZero)
    /// // Prints "false"
    ///
    /// print(Decimal(120.00).isFractionalPartZero)
    /// // Prints "true"
    /// ```
    var isFractionalPartZero: Bool { get }

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
    func calculatePrecision() -> ClosedRange<Int>

    static func / (lhs: Self, rhs: Self) -> Self
}

// MARK: - Conformance

extension Double: DoubleOrDecimalProtocol {
    public var nsNumber: NSNumber {
        NSNumber(value: self)
    }
}

extension Decimal: DoubleOrDecimalProtocol {
    public var nsNumber: NSNumber {
        NSDecimalNumber(decimal: self)
    }
}
