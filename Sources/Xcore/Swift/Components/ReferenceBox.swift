//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

// MARK: - Reference Box

/// A generic reference-based container that provides **read-only** value
/// access.
///
/// `ReferenceBox` is useful when you need to wrap value types inside a
/// reference type without allowing external mutation.
///
/// - Important: If you need **mutable** references, use `MutableReferenceBox`.
///
/// **Usage**
///
/// ```swift
/// struct User {
///     let name: String
/// }
///
/// let user = ReferenceBox(User(name: "Sam"))
/// print(user.name) // "Sam"
/// ```
@dynamicMemberLookup
public class ReferenceBox<Value>: CustomStringConvertible, CustomDebugStringConvertible {
    /// The underlying value stored within the box.
    public fileprivate(set) var value: Value

    /// Creates a reference box with a given value.
    ///
    /// - Parameter value: The initial value to store.
    public init(_ value: Value) {
        self.value = value
    }

    /// Allows **read-only** access to properties of the wrapped value.
    public subscript<T>(dynamicMember keyPath: KeyPath<Value, T>) -> T {
        value[keyPath: keyPath]
    }

    // MARK: - Conformances

    public var description: String {
        String(describing: value)
    }

    public var debugDescription: String {
        "ReferenceBox(\(String(reflecting: value)))"
    }
}

// MARK: - Mutable Reference Box

/// A generic reference-based container that allows **mutable** value access.
///
/// `MutableReferenceBox` enables shared **mutable state** across multiple
/// references.
///
/// **Usage**
///
/// ```swift
/// struct Counter {
///     var count: Int
/// }
///
/// let counter = MutableReferenceBox(Counter(count: 0))
/// counter.count += 1
/// print(counter.count) // "1"
/// ```
@dynamicMemberLookup
public final class MutableReferenceBox<Value>: ReferenceBox<Value> {
    /// The underlying value stored within the box.
    public override var value: Value {
        get { super.value }
        set { super.value = newValue }
    }

    /// Allows **read and write** access to properties of the wrapped value.
    public subscript<T>(dynamicMember keyPath: WritableKeyPath<Value, T>) -> T {
        get { value[keyPath: keyPath] }
        set { value[keyPath: keyPath] = newValue }
    }

    // MARK: - Conformances

    public override var debugDescription: String {
        "MutableReferenceBox(\(String(reflecting: value)))"
    }
}

// MARK: - Conditional Conformances

extension ReferenceBox: Equatable where Value: Equatable {
    public static func == (lhs: ReferenceBox<Value>, rhs: ReferenceBox<Value>) -> Bool {
        lhs.value == rhs.value
    }
}

extension ReferenceBox: Hashable where Value: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(value)
    }
}

extension ReferenceBox: Identifiable where Value: Identifiable {
    public var id: Value.ID {
        value.id
    }
}

extension ReferenceBox: Comparable where Value: Comparable {
    public static func <(lhs: ReferenceBox, rhs: ReferenceBox) -> Bool {
        lhs.value < rhs.value
    }
}

extension ReferenceBox: Encodable where Value: Encodable {
    public func encode(to encoder: any Encoder) throws {
        try value.encode(to: encoder)
    }
}

extension ReferenceBox: Observable where Value: Observable {}

// MARK: - Thread Safety

extension ReferenceBox: @unchecked Sendable where Value: Sendable {}
extension MutableReferenceBox: @unchecked Sendable where Value: Sendable {}
