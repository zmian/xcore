//
// Xcore
// Copyright © 2019 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

/// A type that represents a finite or infinite count.
///
/// The `Count` type allows tracking finite values or an infinite state.
///
/// **Usage**
///
/// ```swift
/// var count: Count = .infinite
/// print(count) // "infinite"
///
/// var count: Count = 1
/// print(count) // "1"
///
/// count -= 1
/// print(count) // "0"
///
/// if count == 0 {
///     print("Remaining count is 0.")
/// }
/// ```
public enum Count: Sendable, Hashable {
    /// Represents an infinite count.
    case infinite

    /// Represents a finite count.
    case finite(Int)

    /// A count of zero.
    public static let zero: Self = 0

    /// A count of one.
    public static let once: Self = 1

    /// The minimum possible finite count.
    public static let min: Self = .finite(Int.min)

    /// The maximum possible finite count.
    public static let max: Self = .finite(Int.max)

    /// Returns `true` if the count is infinite.
    public var isInfinite: Bool {
        switch self {
            case .infinite: true
            default: false
        }
    }

    /// Returns `true` if the count is finite.
    public var isFinite: Bool {
        !isInfinite
    }

    /// The underlying integer value for finite counts.
    ///
    /// - Returns: The integer value if finite; `nil` if infinite.
    public var value: Int? {
        switch self {
            case .infinite: nil
            case let .finite(count): count
        }
    }
}

// MARK: - Expressible Conformances

extension Count: ExpressibleByIntegerLiteral {
    /// Creates a `Count` instance from an integer literal.
    ///
    /// - Parameter value: The integer value.
    public init(integerLiteral value: IntegerLiteralType) {
        self = .finite(value)
    }
}

// MARK: - Arithmetic Operations

extension Count: AdditiveArithmetic {
    public static func + (lhs: Self, rhs: Self) -> Self {
        switch (lhs, rhs) {
            case (.infinite, _), (_, .infinite):
                .infinite
            case let (.finite(l), .finite(r)):
                .finite(l + r)
        }
    }

    public static func - (lhs: Self, rhs: Self) -> Self {
        switch (lhs, rhs) {
            case (.infinite, _), (_, .infinite):
                .infinite
            case let (.finite(l), .finite(r)):
                .finite(l - r)
        }
    }
}

// MARK: - String Representations

extension Count: CustomStringConvertible {
    public var description: String {
        switch self {
            case .infinite: "infinite"
            case let .finite(count): "\(count)"
        }
    }

    /// A localized string representation of the count.
    public var localizedDescription: String {
        switch self {
            case .infinite:
                NSLocalizedString("∞", comment: "Infinite count")
            case let .finite(count):
                count.formatted(.number)
        }
    }
}
