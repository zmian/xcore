//
// Xcore
// Copyright © 2019 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

/// A type representing a percentage value, clamped between `0.0` and `1.0`.
///
/// The `Percentage` type ensures its value is always within valid bounds (`0.0`
/// to `1.0`), supports arithmetic operations, and provides a user-friendly
/// string representation.
///
/// **Usage**
///
/// ```swift
/// let progress: Percentage = 0.5
/// print(progress) // "50%"
///
/// var score: Percentage = 500
/// print(score) // "100%" (clamped)
///
/// score -= 0.01
/// print(score) // "99%"
/// ```
public struct Percentage: Sendable, Hashable, Codable {
    /// The minimum allowed percentage value (`0.0`).
    public static let min: Percentage = 0

    /// The maximum allowed percentage value (`1.0`).
    public static let max: Percentage = 1

    /// The underlying decimal representation of the percentage, clamped between
    /// `0.0` and `1.0`.
    private let decimalValue: Decimal

    /// The percentage value as a `Double`, always clamped between `0.0` and `1.0`.
    public var value: Double {
        decimalValue.double
    }

    /// Creates a new `Percentage` instance with a given value, clamped within `0.0`
    /// to `1.0`.
    ///
    /// - Parameter value: The initial percentage value.
    public init(_ value: Decimal) {
        self.decimalValue = value.clamped(to: 0...1)
    }
}

// MARK: - Expressible Conformances

extension Percentage: ExpressibleByIntegerLiteral {
    public init(integerLiteral value: IntegerLiteralType) {
        self.init(Decimal(value))
    }
}

extension Percentage: ExpressibleByFloatLiteral {
    public init(floatLiteral value: FloatLiteralType) {
        self.init(Decimal(value))
    }
}

// MARK: - Comparable & Strideable

extension Percentage: Comparable {
    public static func <(lhs: Self, rhs: Self) -> Bool {
        lhs.decimalValue < rhs.decimalValue
    }
}

extension Percentage: Strideable {
    public func advanced(by n: Decimal) -> Self {
        Percentage(decimalValue + n)
    }

    public func distance(to other: Self) -> Decimal {
        other.decimalValue - decimalValue
    }
}

// MARK: - Arithmetic Operations

extension Percentage: AdditiveArithmetic {
    public static func +(lhs: Self, rhs: Self) -> Self {
        .init(lhs.decimalValue + rhs.decimalValue)
    }

    public static func -(lhs: Self, rhs: Self) -> Self {
        .init(lhs.decimalValue - rhs.decimalValue)
    }
}

// MARK: - String Representations

extension Percentage: CustomStringConvertible {
    public var description: String {
        let percentage = decimalValue * 100
        return decimalValue.formatted(
            .percent
            .precision(.fractionLength(percentage.isInteger ? 0 : 2))
        )
    }
}

extension Percentage: CustomPlaygroundDisplayConvertible {
    public var playgroundDescription: Any {
        value
    }
}
