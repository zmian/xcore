//
// Xcore
// Copyright © 2019 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

/// A property wrapper that combines `lazy` keyword attributes with the option
/// to reset the wrapped value to be computed on the next access.
///
/// ```swift
/// @LazyReset
/// var x = Int.random(in: 1...100)
///
/// _x.reset()
/// ```
@propertyWrapper
public struct LazyReset<Value> {
    private var closure: () -> Value
    private var value: Value?

    public init(wrappedValue: @autoclosure @escaping () -> Value) {
        self.closure = wrappedValue
    }

    public var wrappedValue: Value {
        mutating get { value ?? reset() }
        set { value = newValue }
    }

    /// Reset the state back to uninitialized with a new, possibly-different initial
    /// value to be computed on the next access.
    @discardableResult
    public mutating func reset() -> Value {
        let newValue = closure()
        value = newValue
        return newValue
    }
}
