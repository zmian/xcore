//
// Xcore
// Copyright © 2022 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

/// A type that represents either a `Double` or a `Decimal` floating-point value
/// type.
public protocol DoubleOrDecimalProtocol: SignedNumeric, Comparable {
    var nsNumber: NSNumber { get }

    /// A boolean value indicating whether the fraction part of the decimal is `0`.
    ///
    /// ```swift
    /// print(Decimal(120.30).isFractionZero)
    /// // Prints "false"
    ///
    /// print(Decimal(120.00).isFractionZero)
    /// // Prints "true"
    /// ```
    var isFractionZero: Bool { get }

    static func / (lhs: Self, rhs: Self) -> Self
}

extension Double: DoubleOrDecimalProtocol {
    public var nsNumber: NSNumber {
        NSNumber(value: self)
    }

    public var isFractionZero: Bool {
        truncatingRemainder(dividingBy: 1) == 0
    }
}

extension Decimal: DoubleOrDecimalProtocol {
    public var nsNumber: NSNumber {
        NSDecimalNumber(decimal: self)
    }
}
