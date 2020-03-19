//
// Xcore
// Copyright © 2019 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

// credit: https://nshipster.com/propertywrapper/
//
/// Clamps wrapped value to given range.
///
/// ```swift
/// struct Color {
///     @Clamping(0...255) var red: Int = 127
///     @Clamping(0...255) var green: Int = 127
///     @Clamping(0...255) var blue: Int = 127
///     @Clamping(0...255) var alpha: Int = 255
/// }
/// ```
@propertyWrapper
public struct Clamping<Value: Comparable> {
    private var value: Value
    private let range: ClosedRange<Value>

    public init(wrappedValue: Value, _ range: ClosedRange<Value>) {
        precondition(range.contains(wrappedValue))
        self.value = wrappedValue
        self.range = range
    }

    public var wrappedValue: Value {
        get { value }
        set { value = min(max(range.lowerBound, newValue), range.upperBound) }
    }
}
