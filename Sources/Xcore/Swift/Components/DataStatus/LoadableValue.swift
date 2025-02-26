//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

/// Represents the loading state of a value.
///
/// Use this enumeration to track whether a value is currently being loaded or
/// has been successfully loaded. Unlike more complex data status types, this
/// type only distinguishes between a loading state and a successfully loaded
/// value.
///
/// **Usage**
///
/// ```swift
/// // When loading is in progress:
/// var status: LoadableValue<String> = .loading
///
/// // When the value has been loaded:
/// status = .value("Loaded content")
/// ```
@frozen
public enum LoadableValue<Value> {
    /// Indicates that the value is currently being loaded.
    case loading

    /// Indicates that the value has been successfully loaded.
    case value(Value)
}

// MARK: - Conditional Conformance

extension LoadableValue: Sendable where Value: Sendable {}
extension LoadableValue: Equatable where Value: Equatable {}
extension LoadableValue: Hashable where Value: Hashable {}

// MARK: - Helpers

extension LoadableValue {
    /// A Boolean property indicating whether current status case is `.loading`.
    public var isLoading: Bool {
        switch self {
            case .loading: true
            default: false
        }
    }

    /// Returns the value associated with `.value` case.
    public var value: Value? {
        switch self {
            case let .value(value): value
            default: nil
        }
    }
}

// MARK: - Void

extension LoadableValue<Void> {
    /// A value, storing an `Void` value.
    public static var value: Self {
        .value(())
    }
}

// MARK: - Empty

extension LoadableValue<Empty> {
    /// A value, storing an `Empty` value.
    public static var value: Self {
        .value(Empty())
    }
}

// MARK: - Associated Value

extension LoadableValue<Bool> {
    /// Returns the value associated with `.value` case or `false` when it's
    /// loading.
    public var value: Bool {
        get {
            switch self {
                case let .value(value): value
                default: false
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
