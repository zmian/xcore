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
/// @LazyReset(.random(in: 1...100))
/// var x: Int
///
/// _x.reset()
/// ```
@propertyWrapper
public struct LazyReset<Value> {
    private let get: () -> Value
    private var value: Value?

    public init(_ get: @autoclosure @escaping () -> Value) {
        self.get = get
    }

    public var wrappedValue: Value {
        mutating get {
            value = value ?? get()
            return value!
        }
        set { value = newValue }
    }

    /// "Reset" the wrapper so it can be initialized again.
    public mutating func reset() {
        value = nil
    }
}
