//
// Xcore
// Copyright © 2017 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

/// A generic class to hold a weak reference to a type `T`.
///
/// This is useful for holding a reference to nullable object.
///
/// ```swift
/// let views = [Weak<UIView>]()
/// ```
public final class Weak<Value: AnyObject> {
    public weak var value: Value?

    public init(_ value: Value) {
        self.value = value
    }
}

// MARK: - Equatable

extension Weak: Equatable {
    public static func ==(lhs: Weak, rhs: Weak) -> Bool {
        lhs.value === rhs.value
    }

    public static func ==(lhs: Weak, rhs: Value) -> Bool {
        lhs.value === rhs
    }
}

// MARK: - Hashable

extension Weak: Hashable where Value: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(value)
    }
}

// MARK: - Comparable

extension Weak: Comparable where Value: Comparable {
    public static func <(lhs: Weak, rhs: Weak) -> Bool {
        guard let lhs = lhs.value else { return false }
        guard let rhs = rhs.value else { return false }
        return lhs < rhs
    }

    public static func >(lhs: Weak, rhs: Weak) -> Bool {
        guard let lhs = lhs.value else { return false }
        guard let rhs = rhs.value else { return false }
        return lhs > rhs
    }
}

// MARK: - Flatten

extension RangeReplaceableCollection where Index == Int {
    /// Removes all elements where the `value` is deallocated.
    public mutating func flatten<T>() where Element == Weak<T>, T: AnyObject {
        for (index, element) in enumerated() where element.value == nil {
            remove(at: index)
        }
    }
}
