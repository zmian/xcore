//
// Xcore
// Copyright © 2017 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

/// A generic class that holds a **weak reference** to an object of type
/// `Value`.
///
/// This is useful for keeping **non-owning references** to objects, preventing
/// **strong reference cycles** while allowing values to be deallocated.
///
/// ## Example Usage
///
/// ```swift
/// class SomeClass {}
///
/// var objects = [Weak<SomeClass>]()
///
/// let instance = SomeClass()
/// objects.append(Weak(instance))
///
/// objects = objects.compacted() // Removes deallocated references
/// ```
@dynamicMemberLookup
public final class Weak<Value: AnyObject> {
    /// The weakly referenced value.
    public weak var value: Value?

    /// Initializes the `Weak` container with the given object.
    ///
    /// - Parameter value: The object to store weakly.
    public init(_ value: Value) {
        self.value = value
    }

    /// Allows dynamic member lookup to access properties of the wrapped value.
    public subscript<T>(dynamicMember keyPath: KeyPath<Value, T>) -> T? {
        value?[keyPath: keyPath]
    }
}

// MARK: - Sendable

extension Weak: @unchecked Sendable where Value: Sendable {}

// MARK: - Equatable

extension Weak: Equatable where Value: Equatable {
    public static func ==(lhs: Weak, rhs: Weak) -> Bool {
        lhs.value == rhs.value
    }

    public static func ==(lhs: Weak, rhs: Value) -> Bool {
        lhs.value == rhs
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
        guard let lhs = lhs.value, let rhs = rhs.value else {
            return false
        }

        return lhs < rhs
    }

    public static func >(lhs: Weak, rhs: Weak) -> Bool {
        guard let lhs = lhs.value, let rhs = rhs.value else {
            return false
        }

        return lhs > rhs
    }
}

// MARK: - Compacted

extension RangeReplaceableCollection {
    /// Removes all elements where the referenced value has been deallocated.
    ///
    /// - Returns: A new collection without deallocated weak references.
    public func compacted<T>() -> Self where Element == Weak<T>, T: AnyObject {
        filter { $0.value != nil }
    }

    /// Mutates the collection by removing all elements where the referenced value
    /// has been deallocated.
    public mutating func compact<T>() where Element == Weak<T>, T: AnyObject {
        self = compacted()
    }
}
