//
// Either.swift
//
// Copyright © 2019 Xcore
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

import Foundation

/// A value that represents either a left or a right value, including an
/// associated value in each case.
public enum Either<Left, Right> {
    case left(Left)
    case right(Right)
}

extension Either {
    public static func left(value: Left?) -> Either? {
        guard let value = value else {
            return nil
        }

        return .left(value)
    }

    public static func right(value: Right?) -> Either? {
        guard let value = value else {
            return nil
        }

        return .right(value)
    }
}

extension Either {
    public var left: Left? {
        guard case .left(let left) = self else {
            return nil
        }

        return left
    }

    public var right: Right? {
        guard case .right(let right) = self else {
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
            case let .left(value):
                return .left(transform(value))
            case let .right(value):
                return .right(value)
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
            case let .left(value):
                return .left(value)
            case let .right(value):
                return .right(transform(value))
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

// MARK: - Hashable

extension Either: Hashable where Left: Hashable, Right: Hashable { }

// MARK: - Equatable

extension Either: Equatable where Left: Equatable, Right: Equatable { }

// MARK: - CustomStringConvertible

extension Either: CustomStringConvertible where Left: CustomStringConvertible, Right: CustomStringConvertible {
    public var description: String {
        switch self {
            case let .left(value):
                return String(describing: value)
            case let .right(value):
                return String(describing: value)
        }
    }
}
