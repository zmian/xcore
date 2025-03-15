//
// Xcore
// Copyright © 2019 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

/// A type that represents a finite or infinite count.
///
/// The `Count` type allows tracking finite values or an infinite state,
/// extending the concept of infinity to types that traditionally only support
/// finite values, such as `Int`, `UInt`, and `Decimal`.
///
/// This is useful in scenarios where a countable value may conceptually be
/// **unbounded** (e.g., infinite retries, unlimited API calls, or unbounded
/// loops).
///
/// **Usage**
///
/// ### **Using `Count` with Integers**
/// ```swift
/// var count: Count<Int> = .infinite
/// print(count) // "infinite"
///
/// count = 5
/// print(count) // "5"
///
/// count -= 1
/// print(count) // "4"
///
/// if count == 0 {
///     print("Count has reached zero.")
/// }
/// ```
///
/// ### **Using `Count` with Floating-Point Values**
/// ```swift
/// var percentage: Count<Double> = .infinite
/// print(percentage) // "infinite"
///
/// percentage = 1.5
/// print(percentage) // "1.5"
/// ```
///
/// ### **Mathematical Operations with `Count`**
/// ```swift
/// let x: Count<Int> = 10
/// let y: Count<Int> = 5
/// print(x + y) // "15"
///
/// let unlimited: Count<Int> = .infinite
/// print(x + unlimited) // "infinite"
/// print(unlimited - y) // "infinite"
/// ```
///
/// `Count<Value>` can be used anywhere a numeric value is needed but might have
/// an **unbounded** state, such as **pagination limits, processing limits, or
/// retry policies**.
///
/// > Tip: Use `Count` instead of `Int` when representing an infinite concept.
/// >
/// > **Example:**
/// >
/// > ```swift
/// > var animationCycle: Count<UInt> = 1 // Runs once
/// >
/// > animationCycle = .infinite // ✅ Clearly represents infinite animation cycles.
/// >
/// > // With `Count<UInt>`, we can design our API to eliminate the need to
/// > // handle negative values for animation cycles.
/// > animationCycle = -1 // 🛑 Compile time error: UInt does not support negative values.
/// >
/// > switch animationCycle {
/// >     case .infinite:
/// >         print("Animation will run indefinitely.")
/// >     case let .finite(count):
/// >         print("Animation will run for \(count) cycles.")
/// > }
/// > ```
/// >
/// > **Avoid this approach:**
/// >
/// > ```swift
/// > var animationCycle = 1 // Runs once
/// >
/// > animationCycle = -1 // 🛑 Unclear representation; might be misused to indicate infinity.
/// >
/// > if animationCycle < 0 {
/// >     print("Animation will run indefinitely.")
/// > } else {
/// >     print("Animation will run for \(animationCycle) cycles.")
/// > }
/// > ```
/// >
/// > Using `Count` makes the intention explicit, preventing ambiguity in
/// > scenarios where infinity needs to be represented in traditionally finite
/// > types.
public enum Count<Value> {
    /// Represents an infinite count.
    case infinite

    /// Represents a finite count.
    case finite(Value)

    /// Returns `true` if the count is infinite.
    public var isInfinite: Bool {
        switch self {
            case .infinite: true
            case .finite: false
        }
    }

    /// Returns `true` if the count is finite.
    public var isFinite: Bool {
        !isInfinite
    }

    /// The underlying value for finite counts.
    ///
    /// - Returns: The value if finite; `nil` if infinite.
    public var value: Value? {
        switch self {
            case .infinite: nil
            case let .finite(count): count
        }
    }
}

extension Count: Sendable where Value: Sendable {}
extension Count: Equatable where Value: Equatable {}
extension Count: Hashable where Value: Hashable {}

// MARK: - Expressible Conformances

extension Count: ExpressibleByIntegerLiteral where Value: ExpressibleByIntegerLiteral {
    /// Creates a `Count` initialized to the specified integer value.
    ///
    /// Do not call this initializer directly. Instead, initialize a variable or
    /// constant using an integer literal. For example:
    ///
    /// ```swift
    /// let x: Count<Int> = 23
    /// ```
    ///
    /// In this example, the assignment to the `x` constant calls this integer
    /// literal initializer behind the scenes.
    ///
    /// - Parameter value: The value to create.
    public init(integerLiteral value: Value.IntegerLiteralType) {
        self = .finite(Value(integerLiteral: value))
    }
}

extension Count: ExpressibleByFloatLiteral where Value: ExpressibleByFloatLiteral {
    /// Creates a `Count` initialized to the specified floating-point value.
    ///
    /// Do not call this initializer directly. Instead, initialize a variable or
    /// constant using a floating-point literal. For example:
    ///
    /// ```swift
    /// let x: Count<Double> = 21.5
    /// ```
    ///
    /// In this example, the assignment to the `x` constant calls this
    /// floating-point literal initializer behind the scenes.
    ///
    /// - Parameter value: The value to create.
    public init(floatLiteral value: Value.FloatLiteralType) {
        self = .finite(Value(floatLiteral: value))
    }
}

// MARK: - FixedWidthInteger

extension Count where Value: FixedWidthInteger {
    /// The minimum possible finite count.
    public static var min: Self { .finite(.min) }

    /// The maximum possible finite count.
    public static var max: Self { .finite(.max) }
}

// MARK: - FloatingPoint

extension Count where Value: FloatingPoint {
    /// The minimum possible finite count.
    public static var min: Self { .finite(.leastNormalMagnitude) }

    /// The maximum possible finite count.
    public static var max: Self { .finite(.greatestFiniteMagnitude) }
}

// MARK: - Decimal

extension Count where Value == Decimal {
    /// The minimum possible finite count.
    public static var min: Self { .finite(.leastFiniteMagnitude) }

    /// The maximum possible finite count.
    public static var max: Self { .finite(.greatestFiniteMagnitude) }
}

extension Count where Value: Numeric {
    /// A count of one.
    public static var once: Self { .finite(1) }
}

// MARK: - Arithmetic Operations

extension Count: AdditiveArithmetic where Value: AdditiveArithmetic {
    /// A count of zero.
    public static var zero: Self { .finite(.zero) }

    public static func +(lhs: Self, rhs: Self) -> Self {
        switch (lhs, rhs) {
            case (.infinite, _), (_, .infinite):
                .infinite
            case let (.finite(lhs), .finite(rhs)):
                .finite(lhs + rhs)
        }
    }

    public static func -(lhs: Self, rhs: Self) -> Self {
        switch (lhs, rhs) {
            case (.infinite, _), (_, .infinite):
                .infinite
            case let (.finite(lhs), .finite(rhs)):
                .finite(lhs - rhs)
        }
    }
}

// MARK: - Comparable

extension Count: Comparable where Value: Comparable {
    public static func <(lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
            case (.infinite, .infinite), (.infinite, .finite):
                false
            case (.finite, .infinite):
                true
            case let (.finite(lhs), .finite(rhs)):
                lhs < rhs
        }
    }
}

// MARK: - Numeric

extension Count: Numeric where Value: Numeric {
    public init?(exactly source: some BinaryInteger) {
        guard let value = Value(exactly: source) else {
            return nil
        }

        self = .finite(value)
    }

    public var magnitude: Count<Value.Magnitude> {
        switch self {
            case .infinite: .infinite
            case let .finite(count): .finite(count.magnitude)
        }
    }

    public static func *(lhs: Self, rhs: Self) -> Self {
        switch (lhs, rhs) {
            case (.infinite, _), (_, .infinite):
                .infinite
            case let (.finite(lhs), .finite(rhs)):
                .finite(lhs * rhs)
        }
    }

    public static func *=(lhs: inout Self, rhs: Self) {
        lhs = lhs * rhs
    }
}

// MARK: - SignedNumeric

extension Count: SignedNumeric where Value: SignedNumeric {}

// MARK: - Strideable

extension Count: Strideable where Value: SignedNumeric & Comparable {
    public func advanced(by n: Self) -> Self {
        switch (self, n) {
            case (.infinite, _), (_, .infinite):
                .infinite
            case let (.finite(value), .finite(stride)):
                .finite(value + stride)
        }
    }

    public func distance(to other: Self) -> Self {
        switch (self, other) {
            case (.infinite, _), (_, .infinite):
                .infinite
            case let (.finite(lhs), .finite(rhs)):
                .finite(rhs - lhs)
        }
    }
}

// MARK: - String Representations

extension Count: CustomStringConvertible {
    public var description: String {
        switch self {
            case .infinite: "infinite"
            case let .finite(count): String(describing: count)
        }
    }
}

extension Count where Value: BinaryInteger {
    /// A localized string representation of the count.
    public var localizedDescription: String {
        switch self {
            case .infinite:
                NSLocalizedString("∞", comment: "Infinite count")
            case let .finite(count):
                count.formatted(IntegerFormatStyle<Value>())
        }
    }
}

extension Count where Value: BinaryFloatingPoint {
    /// A localized string representation of the count.
    public var localizedDescription: String {
        switch self {
            case .infinite:
                NSLocalizedString("∞", comment: "Infinite count")
            case let .finite(count):
                count.formatted(FloatingPointFormatStyle<Value>())
        }
    }
}

extension Count<Decimal> {
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
