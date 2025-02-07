//
// Xcore
// Copyright © 2019 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

/// A value that represents either a left or a right value, including an
/// associated value in each case.
public enum Either<Left, Right> {
    case left(Left)
    case right(Right)
}

extension Either {
    public static func left(value: Left?) -> Either? {
        guard let value else {
            return nil
        }

        return .left(value)
    }

    public static func right(value: Right?) -> Either? {
        guard let value else {
            return nil
        }

        return .right(value)
    }
}

extension Either {
    public var left: Left? {
        guard case let .left(left) = self else {
            return nil
        }

        return left
    }

    public var right: Right? {
        guard case let .right(right) = self else {
            return nil
        }

        return right
    }
}

extension Either {
    /// Returns a new result, mapping any left value using the given
    /// transformation.
    ///
    /// Use this method when you need to transform the value of a `Either`
    /// instance when it represents a left value. The following example transforms
    /// the integer left value of a result into a string:
    ///
    /// ```swift
    /// func getNextInteger() -> Either<Int, String> { /* ... */ }
    ///
    /// let integerResult = getNextInteger()
    /// // integerResult == .left(5)
    /// let stringResult = integerResult.mapLeft { String($0) }
    /// // stringResult == .left("5")
    /// ```
    ///
    /// - Parameter transform: A closure that takes the left value of this
    ///   instance.
    /// - Returns: A `Either` instance with the result of evaluating `transform`
    ///   as the new left value if this instance represents a left value.
    public func mapLeft<NewLeft>(_ transform: (Left) -> NewLeft) -> Either<NewLeft, Right> {
        switch self {
            case let .left(value): .left(transform(value))
            case let .right(value): .right(value)
        }
    }

    /// Returns a new result, mapping any right value using the given
    /// transformation.
    ///
    /// Use this method when you need to transform the value of a `Either`
    /// instance when it represents a right value. The following example transforms
    /// the integer right value of a result into a string:
    ///
    /// ```swift
    /// func getNextInteger() -> Either<Int, String> { /* ... */ }
    ///
    /// let integerResult = getNextInteger()
    /// // integerResult == .right(5)
    /// let stringResult = integerResult.mapRight { String($0) }
    /// // stringResult == .right("5")
    /// ```
    ///
    /// - Parameter transform: A closure that takes the right value of this
    ///   instance.
    /// - Returns: A `Either` instance with the result of evaluating `transform`
    ///   as the new right value if this instance represents a right value.
    public func mapRight<NewRight>(_ transform: (Right) -> NewRight) -> Either<Left, NewRight> {
        switch self {
            case let .left(value): .left(value)
            case let .right(value): .right(transform(value))
        }
    }
}

// MARK: - String

extension Either: ExpressibleByStringLiteral where Left == String {
    public init(stringLiteral value: StringLiteralType) {
        self = .left(value)
    }
}

extension Either: ExpressibleByExtendedGraphemeClusterLiteral where Left == String {
    public init(extendedGraphemeClusterLiteral value: String) {
        self = .left(value)
    }
}

extension Either: ExpressibleByUnicodeScalarLiteral where Left == String {
    public init(unicodeScalarLiteral value: String) {
        self = .left(value)
    }
}

// MARK: - Float

extension Either: ExpressibleByFloatLiteral where Right == FloatLiteralType {
    public init(floatLiteral value: FloatLiteralType) {
        self = .right(value)
    }
}

// MARK: - Integer

extension Either: ExpressibleByIntegerLiteral where Right == IntegerLiteralType {
    public init(integerLiteral value: IntegerLiteralType) {
        self = .right(value)
    }
}

// MARK: - Sendable

extension Either: Sendable where Left: Sendable, Right: Sendable {}

// MARK: - Equatable

extension Either: Equatable where Left: Equatable, Right: Equatable {}

// MARK: - Hashable

extension Either: Hashable where Left: Hashable, Right: Hashable {}

// MARK: - CustomStringConvertible

extension Either: CustomStringConvertible where Left: CustomStringConvertible, Right: CustomStringConvertible {
    public var description: String {
        switch self {
            case let .left(value): String(describing: value)
            case let .right(value): String(describing: value)
        }
    }
}

// MARK: - View

extension Either: View where Left: View, Right: View {
    public var body: some View {
        switch self {
            case let .left(leftView): leftView
            case let .right(rightView): rightView
        }
    }
}
