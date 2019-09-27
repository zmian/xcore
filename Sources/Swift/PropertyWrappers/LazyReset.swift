//
// LazyReset.swift
//
// Copyright © 2019 Xcore
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
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
