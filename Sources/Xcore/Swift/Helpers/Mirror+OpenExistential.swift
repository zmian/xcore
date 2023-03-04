//
// Xcore
// Copyright © 2022 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

// MARK: - isOptional

extension Mirror {
    /// Returns a Boolean value indicating whether the given value is an optional
    /// type.
    ///
    /// - Parameter value: The value to check if it is an optional.
    public static func isOptional<T>(_ value: T) -> Bool {
        value is any OptionalProtocol
    }
}

// MARK: - isCodable

extension Mirror {
    /// Returns a Boolean value indicating whether the given value type conform to
    /// `Codable` protocol.
    ///
    /// - Parameter value: The value to check if it is codable.
    public static func isCodable<T>(_ value: T) -> Bool {
        value is any Codable
    }

    /// Returns a Boolean value indicating whether the given value type is codable.
    ///
    /// - Parameter value: The value type to check if it is a codable type.
    public static func isCodable<T>(_ value: T.Type) -> Bool {
        value is any Codable.Type
    }
}

// MARK: - isCollection

extension Mirror {
    /// Returns a Boolean value indicating whether the given value type conform to
    /// `Collection` protocol.
    ///
    /// - Parameter value: The value to check if it is a type of a collection.
    public static func isCollection<T>(_ value: T) -> Bool {
        value is any Collection
    }

    /// Returns a Boolean value indicating whether the given value type is a
    /// collection.
    ///
    /// - Parameter value: The value type to check if it is a collection type.
    public static func isCollection<T>(_ value: T.Type) -> Bool {
        value is any Collection.Type
    }
}

// MARK: - isEmpty

extension Mirror {
    /// Returns a Boolean value indicating whether the given value type conform to
    /// `Collection` protocol and the collection is empty.
    ///
    /// Returns `nil` if the given value do not conform to `Collection` protocol.
    ///
    /// - Parameter value: The value to check if it is a type of a collection
    ///   and the collection is empty.
    public static func isEmpty(_ value: Any) -> Bool? {
        (value as? any Collection)?.isEmpty
    }
}

// MARK: - isEqual

extension Mirror {
    /// Returns a Boolean value indicating whether the given values types conform to
    /// `Equatable` protocol and are equal.
    ///
    /// Returns `nil` if either one of the given values do not conform to
    /// `Equatable` protocol.
    ///
    /// - Parameters:
    ///   - lhs: The left hand side value to for equality check.
    ///   - rhs: The right hand side value to for equality check.
    public static func isEqual(_ lhs: Any, _ rhs: Any) -> Bool? {
        (lhs as? any Equatable)?._isEqual(other: rhs)
    }
}

// MARK: - Equatable.isEqual

extension Equatable {
    /// Credit to [TCA] for this Approach.
    ///
    /// [TCA]: https://github.com/pointfreeco/swift-composable-architecture/blob/108e3a536fcebb16c4f247ef92c2d7326baf9fe3/Sources/ComposableArchitecture/Effects/TaskResult.swift#L284-L305
    fileprivate func _isEqual(other: Any) -> Bool {
        self == other as? Self
    }
}
