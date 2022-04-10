//
// Xcore
// Copyright © 2022 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

public enum SelectionValue<Value> {
    case value(Value)
    case binding(Binding<Value>)

    public var value: Value {
        switch self {
            case let .binding(binding):
                return binding.wrappedValue
            case let .value(value):
                return value
        }
    }
}

// MARK: - Equatable

extension SelectionValue: Equatable where Value: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.value == rhs.value
    }
}

// MARK: - Hashable

extension SelectionValue: Hashable where Value: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(value)
    }
}

// MARK: - Boolean

extension SelectionValue: ExpressibleByBooleanLiteral where Value == Bool {
    public init(booleanLiteral value: Bool) {
        self = .value(value)
    }
}

// MARK: - CustomStringConvertible

extension SelectionValue: CustomStringConvertible where Value: CustomStringConvertible {
    public var description: String {
        value.description
    }
}
