//
// DelayedMutable.swift
// Copyright © 2019 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

/// ```swift
/// @DelayedMutable var x: Int
/// ```
@propertyWrapper
public struct DelayedMutable<Value> {
    private var _value: Value?

    public init() {}

    public var wrappedValue: Value {
        get {
            guard let value = _value else {
                fatalError("Property accessed before being initialized.")
            }
            return value
        }
        set { _value = newValue }
    }

    /// "Reset" the wrapper so it can be initialized again.
    public mutating func reset() {
        _value = nil
    }
}
