//
// Xcore
// Copyright © 2019 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

/// A property wrapper that models "delayed" initialization. This can avoid the
/// need for implicitly-unwrapped optionals in multi-phase initialization.
///
/// ```swift
/// class Foo {
///     @DelayedMutable var x: Int
///
///     init() {
///         // We don't know "x" yet, and we don't have to set it
///     }
///
///     func initializeX(x: Int) {
///         self.x = x
///     }
///
///     func getX() -> Int {
///         return x // Will crash if 'self.x' wasn't initialized
///     }
/// }
/// ```
@propertyWrapper
public struct DelayedMutable<Value> {
    private var value: Value?

    public init() {}

    public var wrappedValue: Value {
        get {
            guard let value = value else {
                fatalError("Property accessed before being initialized.")
            }
            return value
        }
        set { value = newValue }
    }

    /// "Reset" the wrapper so it can be initialized again.
    public mutating func reset() {
        value = nil
    }
}
