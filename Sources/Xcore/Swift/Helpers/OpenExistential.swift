//
// Xcore
// Copyright © 2022 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

extension Mirror {
    /// Returns a Boolean value indicating whether the given values types conform to
    /// `Equatable` protocol and are equal.
    ///
    /// Returns `nil` if either one of the given values do not conform to
    /// `Equatable` protocol.
    ///
    /// - Parameter value: The value to check if it is a type of a collection
    ///   and the collection is empty.
    /// - Parameters:
    ///   - lhs: The left hand side value to for equality check.
    ///   - rhs: The right hand side value to for equality check.
    public static func isEqual(_ lhs: Any, _ rhs: Any) -> Bool? {
        _isEqual(lhs, rhs)
    }

    /// Returns a Boolean value indicating whether the given value is a type of a
    /// collection and the collection is empty.
    ///
    /// Returns `nil` if the given value is not a type of a collection.
    ///
    /// - Parameter value: The value to check if it is a type of a collection
    ///   and the collection is empty.
    public static func isEmpty(_ value: Any) -> Bool? {
        _isEmpty(value)
    }
}

// MARK: - Helpers

// Credit to TCA for this Approach:
// https://github.com/pointfreeco/swift-composable-architecture/blob/108e3a536fcebb16c4f247ef92c2d7326baf9fe3/Sources/ComposableArchitecture/Effects/TaskResult.swift#L284-L305
private enum _Witness<A> {}

// MARK: - AnyCollection.isEmpty

private protocol _AnyCollection {
    static func _isEmpty(_ value: Any) -> Bool
}

extension _Witness: _AnyCollection where A: Collection {
    static func _isEmpty(_ value: Any) -> Bool {
        guard let value = value as? A else {
            return false
        }

        return value.isEmpty
    }
}

private func _isEmpty(_ value: Any) -> Bool? {
    func `do`<A>(_: A.Type) -> Bool? {
        (_Witness<A>.self as? _AnyCollection.Type)?._isEmpty(value)
    }
    return _openExistential(type(of: value), do: `do`)
}

// MARK: - AnyEquatable.isEmpty

private protocol _AnyEquatable {
    static func _isEqual(_ lhs: Any, _ rhs: Any) -> Bool
}

extension _Witness: _AnyEquatable where A: Equatable {
    static func _isEqual(_ lhs: Any, _ rhs: Any) -> Bool {
        guard
            let lhs = lhs as? A,
            let rhs = rhs as? A
        else {
            return false
        }

        return lhs == rhs
    }
}

private func _isEqual(_ a: Any, _ b: Any) -> Bool? {
    func `do`<A>(_: A.Type) -> Bool? {
        (_Witness<A>.self as? _AnyEquatable.Type)?._isEqual(a, b)
    }
    return _openExistential(type(of: a), do: `do`)
}
