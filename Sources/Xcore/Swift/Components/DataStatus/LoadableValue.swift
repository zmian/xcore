//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

public enum LoadableValue<Value: Hashable>: Hashable {
    case loading
    case value(Value)
}

// MARK: - Helpers

extension LoadableValue {
    /// A Boolean property indicating whether current status case is `.loading`.
    public var isLoading: Bool {
        self == .loading
    }

    /// Returns the value associated with `.value` case.
    public var value: Value? {
        switch self {
            case let .value(value):
                return value
            default:
                return nil
        }
    }
}

extension LoadableValue where Value == Xcore.Empty {
    /// A value, storing an `Empty` value.
    public static var value: Self {
        .value(Empty())
    }
}

extension LoadableValue where Value == Bool {
    /// Returns the value associated with `.value` case or `false` when it's
    /// loading.
    public var value: Bool {
        get {
            switch self {
                case let .value(value):
                    return value
                default:
                    return false
            }
        }
        set {
            self = .value(newValue)
        }
    }
}

// MARK: - Boolean

extension LoadableValue: ExpressibleByBooleanLiteral where Value == Bool {
    public init(booleanLiteral value: Bool) {
        self = .value(value)
    }
}
