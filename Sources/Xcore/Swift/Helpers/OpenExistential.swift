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
        (value as? any Collection)?.isEmpty
    }
}

// MARK: - Equatable.isEqual

// Credit to TCA for this Approach:
// https://github.com/pointfreeco/swift-composable-architecture/blob/108e3a536fcebb16c4f247ef92c2d7326baf9fe3/Sources/ComposableArchitecture/Effects/TaskResult.swift#L284-L305

extension Equatable {
    fileprivate func _isEqual(other: Any) -> Bool {
        self == other as? Self
    }
}

private func _isEqual(_ lhs: Any, _ rhs: Any) -> Bool? {
    (lhs as? any Equatable)?._isEqual(other: rhs)
}
