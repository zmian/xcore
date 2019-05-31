//
// Weak.swift
//
// Copyright © 2017 Xcore
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

/// A generic class to hold a weak reference to a type `T`.
/// This is useful for holding a reference to nullable object.
///
/// ```swift
/// let views = [Weak<UIView>]()
/// ```
final public class Weak<Value: AnyObject> {
    public weak var value: Value?

    public init (_ value: Value) {
        self.value = value
    }
}

extension Weak: Equatable {
    public static func ==(lhs: Weak, rhs: Weak) -> Bool {
        return lhs.value === rhs.value
    }

    public static func ==(lhs: Weak, rhs: Value) -> Bool {
        return lhs.value === rhs
    }
}

extension Weak: Hashable where Value: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(value)
    }
}

extension RangeReplaceableCollection where Element: Weak<AnyObject>, Index == Int {
    /// Removes all elements where the `value` is deallocated.
    public mutating func flatten() {
        for (index, element) in enumerated() where element.value == nil {
            remove(at: index)
        }
    }
}
