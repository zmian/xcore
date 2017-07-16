//
// EnumIteratable.swift
//
// Copyright © 2015 Zeeshan Mian
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

// Credit: http://stackoverflow.com/a/33598988

/// A type that makes conforming `Enum` cases iteratable.
///
/// ```swift
/// enum CompassPoint: Int, EnumIteratable {
///     case north
///     case south
///     case east
///     case west
/// }
///
/// for point in CompassPoint.allValues {
///     // point [north, south, east, west]
/// }
///
/// for point in CompassPoint.rawValues {
///     // point [0, 1, 2, 3]
/// }
/// ```
///
/// `EnumIteratable` requires conforming enums types to be `RawRepresentable`.
public protocol EnumIteratable {
    associatedtype EnumType: Hashable, RawRepresentable = Self
    static var allValues: [EnumType] { get }
    static var rawValues: [EnumType.RawValue] { get }
}

extension EnumIteratable {
    /// Return `AnyGenerator` to iterate over all cases of `self`:
    ///
    /// ```swift
    /// enum CompassPoint: Int, EnumIteratable {
    ///     case north, south, east, west
    /// }
    ///
    /// for point in CompassPoint.enumerated() {
    ///     print("\(point): '\(point.rawValue)'")
    /// }
    ///
    /// north: '0'
    /// south: '1'
    /// wast: '2'
    /// west: '3'
    /// ```
    fileprivate static func enumerated() -> AnyIterator<EnumType> {
        var i = 0
        return AnyIterator {
            let next = withUnsafePointer(to: &i) {
                $0.withMemoryRebound(to: EnumType.self, capacity: 0) {
                    $0.pointee
                }
            }

            let nextValue: EnumType? = next.hashValue == i ? next : nil
            i += 1
            return nextValue
        }
    }

    /// Return an array containing all cases of `self`.
    public static var allValues: [EnumType] {
        return enumerated().map { $0 }
    }

    /// Return an array containing all corresponding `rawValue`s of `self`.
    public static var rawValues: [EnumType.RawValue] {
        return allValues.map { $0.rawValue }
    }
}
