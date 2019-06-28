//
// Percentage.swift
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

/// A type that can be used to represent percentage with bounds check to ensure
/// the value is always between `0` and `100` and support for addition and
/// subtraction.
///
/// # Example Usage
///
/// ```swift
/// let sliderValue: Percentage = 0.5
/// // print(sliderValue) // 0.5%
///
/// // Bounds check to ensure the value is between 0 & 100.
/// var sliderValue: Percentage = 500
/// // print(sliderValue) // 100.0%
///
/// sliderValue -= 1
/// // print(sliderValue) // 99.0%
/// ```
public struct Percentage: RawRepresentable {
    public static let min: Percentage = 0
    public static let max: Percentage = 100

    public private(set) var rawValue: Double

    public init(rawValue: Double) {
        self.rawValue = type(of: self).normalize(rawValue)
    }

    private static func normalize(_ value: Double) -> Double {
        switch value {
            case 0...100:
                return value
            case ..<0:
                return 0
            default:
                return 100
        }
    }
}

extension Percentage: ExpressibleByIntegerLiteral {
    public init(integerLiteral value: IntegerLiteralType) {
        self.init(rawValue: Double(value))
    }
}

extension Percentage: ExpressibleByFloatLiteral {
    public init(floatLiteral value: FloatLiteralType) {
        self.init(rawValue: Double(value))
    }
}

extension Percentage: CustomStringConvertible {
    public var description: String {
        return "\(rawValue)%"
    }
}

extension Percentage: CustomPlaygroundDisplayConvertible {
    public var playgroundDescription: Any {
        return rawValue
    }
}

extension Percentage: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(rawValue)
    }
}

extension Percentage: Comparable {
    public static func ==(lhs: Percentage, rhs: Percentage) -> Bool {
        return lhs.rawValue == rhs.rawValue
    }

    public static func <(lhs: Percentage, rhs: Percentage) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
}

extension Percentage {
    public static func +(lhs: Percentage, rhs: Percentage) -> Percentage {
        return Percentage(rawValue: lhs.rawValue + rhs.rawValue)
    }

    public static func -(lhs: Percentage, rhs: Percentage) -> Percentage {
        return Percentage(rawValue: lhs.rawValue - rhs.rawValue)
    }

    public static func +=(lhs: inout Percentage, rhs: Percentage) {
        let normalizedValue = normalize(lhs.rawValue + rhs.rawValue)
        lhs.rawValue = normalizedValue
    }

    public static func -=(lhs: inout Percentage, rhs: Percentage) {
        let normalizedValue = normalize(lhs.rawValue - rhs.rawValue)
        lhs.rawValue = normalizedValue
    }
}

extension Percentage: Codable { }
