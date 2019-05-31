//
// AnyEquatable.swift
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

/// A type-erased equatable value.
///
/// The `AnyEquatable` type forwards equality comparisons operations
/// to an underlying equatable value, hiding its specific underlying type.
///
/// You can store mixed-type keys in dictionaries and other collections that
/// require `Equatable` conformance by wrapping mixed-type keys in
/// `AnyEquatable` instances:
///
/// ```swift
/// let descriptions: [AnyEquatable: Any] = [
///     AnyEquatable("😄"): "emoji",
///     AnyEquatable(42): "an Int",
///     AnyEquatable(Int8(43)): "an Int8",
///     AnyEquatable(Set(["a", "b"])): "a set of strings"
/// ]
///
/// print(descriptions[AnyEquatable(42)]!)      // prints "an Int"
/// print(descriptions[AnyEquatable(43)])       // prints "nil"
/// print(descriptions[AnyEquatable(Int8(43))]!) // prints "an Int8"
/// print(descriptions[AnyEquatable(Set(["a", "b"]))]!) // prints "a set of strings"
///
/// let arr = [AnyEquatable(😄), AnyEquatable("cat"), AnyEquatable(42)]
/// print(arr.contains(AnyEquatable(😄))) // -> true
/// print(arr.contains(AnyEquatable("dog"))) // -> false
/// ```
public struct AnyEquatable {
    public let base: Any
    private let equals: (Any) -> Bool

    public init<E: Equatable>(_ base: E) {
        self.base = base
        self.equals = { $0 as? E == base }
    }
}

extension AnyEquatable: Equatable {
    /// Returns a Boolean value indicating whether two type-erased equatable
    /// instances wrap the same type and value.
    ///
    /// Two instances of `AnyEquatable` compare as equal if and only if the
    /// underlying types have the same conformance to the `Equatable` protocol
    /// and the underlying values compare as equal.
    ///
    /// The following example creates two type-erased equatable values: `x` wraps
    /// an `Int` with the value 42, while `y` wraps a `UInt8` with the same
    /// numeric value. Because the underlying types of `x` and `y` are
    /// different, the two variables do not compare as equal despite having
    /// equal underlying values.
    ///
    /// ```swift
    /// let x = AnyEquatable(Int(42))
    /// let y = AnyEquatable(UInt8(42))
    ///
    /// print(x == y)
    /// // Prints "false" because `Int` and `UInt8` are different types
    ///
    /// print(x == AnyEquatable(Int(42)))
    /// // Prints "true"
    /// ```
    ///
    /// - Parameters:
    ///   - lhs: A type-erased equatable value.
    ///   - rhs: Another type-erased equatable value.
    /// - Returns: `true` if they are equal; otherwise, `false`.
    public static func ==(lhs: AnyEquatable, rhs: AnyEquatable) -> Bool {
        return lhs.equals(rhs.base)
    }
}

extension AnyEquatable: CustomStringConvertible {
    /// A textual representation of this instance.
    ///
    /// Instead of accessing this property directly, convert an instance of any
    /// type to a string by using the `String(describing:)` initializer. For
    /// example:
    ///
    /// ```swift
    /// struct Point: CustomStringConvertible {
    ///     let x: Int, y: Int
    ///
    ///     var description: String {
    ///         return "(\(x), \(y))"
    ///     }
    /// }
    ///
    /// let p = Point(x: 21, y: 30)
    /// let s = String(describing: p)
    /// print(s)
    /// // Prints "(21, 30)"
    /// ```
    ///
    /// The conversion of `p` to a string in the assignment to `s` uses the
    /// `Point` type's `description` property.
    public var description: String {
        return String(describing: base)
    }
}
