//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

// MARK: - Box

@dynamicMemberLookup
public class Box<Value> {
    public fileprivate(set) var value: Value

    public init(_ value: Value) {
        self.value = value
    }

    public subscript<T>(dynamicMember keyPath: KeyPath<Value, T>) -> T {
        value[keyPath: keyPath]
    }
}

// MARK: - Mutable Box

public class MutableBox<Value>: Box<Value> {
    public override var value: Value {
        get { super.value }
        set { super.value = newValue }
    }

    public subscript<T>(dynamicMember keyPath: WritableKeyPath<Value, T>) -> T {
        get { value[keyPath: keyPath] }
        set { value[keyPath: keyPath] = newValue }
    }
}

// MARK: - Conditional Conformances

extension Box: CustomStringConvertible where Value: CustomStringConvertible {
    public var description: String {
        value.description
    }
}

extension Box: Hashable where Value: Hashable {
    public func hash(into hasher: inout Hasher) {
        value.hash(into: &hasher)
    }
}

extension Box: Equatable where Value: Equatable {
    public static func ==(lhs: Box<Value>, rhs: Box<Value>) -> Bool {
        lhs.value == rhs.value
    }
}

extension Box: Identifiable where Value: Identifiable {
    public var id: Value.ID {
        value.id
    }
}
