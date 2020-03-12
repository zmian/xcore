//
// Xcore
// Copyright © 2019 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

/// ```swift
/// @LazyReset var x: Int {
///     .random(in: 1...100)
/// }
///
/// x.reset()
/// ```
@propertyWrapper
public struct LazyReset<Value> {
    private var closure: () -> Value
    private var _value: Value?

    public init(_ wrappedValue: @autoclosure @escaping () -> Value) {
        self.closure = wrappedValue
    }

    public var wrappedValue: Value {
        mutating get { _value ?? reset() }
        set { _value = newValue }
    }

    @discardableResult
    public mutating func reset() -> Value {
        let newValue = closure()
        _value = newValue
        return newValue
    }
}
