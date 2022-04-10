//
// Xcore
// Copyright © 2022 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

public enum SelectionType<Value> {
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

extension SelectionType: Equatable where Value: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.value == rhs.value
    }
}

// MARK: - Hashable

extension SelectionType: Hashable where Value: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(value)
    }
}

// MARK: - Boolean

extension SelectionType: ExpressibleByBooleanLiteral where Value == Bool {
    public init(booleanLiteral value: Bool) {
        self = .value(value)
    }
}

// MARK: - CustomStringConvertible

extension SelectionType: CustomStringConvertible where Value: CustomStringConvertible {
    public var description: String {
        value.description
    }
}
