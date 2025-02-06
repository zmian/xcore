//
// Xcore
// Copyright © 2022 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

/// A generic enumeration representing either a direct value or a binding to a
/// value.
///
/// This type provides a unified interface for accessing a value whether it is
/// provided directly or via a mutable binding. Use the `value` computed
/// property to retrieve the underlying value.
public enum SelectionType<Value> {
    /// A case that holds a direct value of type `Value`.
    case value(Value)

    /// A case that holds a binding to a value of type `Value`.
    case binding(Binding<Value>)

    /// A Boolean property indicating whether the stored binding or value is
    /// accessible.
    ///
    /// When the case is `.binding`, the current wrapped value is returned; when the
    /// case is `.value`, the stored value is returned directly.
    public var value: Value {
        switch self {
            case let .binding(binding): binding.wrappedValue
            case let .value(value): value
        }
    }
}

// MARK: - Equatable

extension SelectionType: Equatable where Value: Equatable {
    public static func ==(lhs: Self, rhs: Self) -> Bool {
        lhs.value == rhs.value
    }
}

// MARK: - Hashable

extension SelectionType: Hashable where Value: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(value)
    }
}

// MARK: - ExpressibleByBooleanLiteral

extension SelectionType: ExpressibleByBooleanLiteral where Value == Bool {
    /// Creates an instance of SelectionType using a Boolean literal.
    ///
    /// **Usage**
    ///
    /// ```swift
    /// let flag: SelectionType<Bool> = true
    /// print(flag) // Outputs: true
    /// ```
    public init(booleanLiteral value: Bool) {
        self = .value(value)
    }
}

// MARK: - CustomStringConvertible

extension SelectionType: CustomStringConvertible where Value: CustomStringConvertible {
    /// A textual representation of the selection, derived from its underlying
    /// value's description.
    public var description: String {
        value.description
    }
}
