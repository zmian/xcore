//
// Xcore
// Copyright © 2019 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

/// A type that can be used to represent percentage with bounds check to ensure
/// the value is always between `0` and `100` and support for addition and
/// subtraction.
///
/// **Usage**
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
        self.rawValue = Self.normalize(rawValue)
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
        "\(rawValue)%"
    }
}

extension Percentage: CustomPlaygroundDisplayConvertible {
    public var playgroundDescription: Any {
        rawValue
    }
}

extension Percentage: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(rawValue)
    }
}

extension Percentage: Equatable {
    public static func ==(lhs: Self, rhs: Self) -> Bool {
        lhs.rawValue == rhs.rawValue
    }
}

extension Percentage: Comparable {
    public static func <(lhs: Self, rhs: Self) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}

extension Percentage {
    public static func +(lhs: Self, rhs: Self) -> Self {
        .init(rawValue: lhs.rawValue + rhs.rawValue)
    }

    public static func -(lhs: Self, rhs: Self) -> Self {
        .init(rawValue: lhs.rawValue - rhs.rawValue)
    }

    public static func +=(lhs: inout Self, rhs: Self) {
        let normalizedValue = normalize(lhs.rawValue + rhs.rawValue)
        lhs.rawValue = normalizedValue
    }

    public static func -=(lhs: inout Self, rhs: Self) {
        let normalizedValue = normalize(lhs.rawValue - rhs.rawValue)
        lhs.rawValue = normalizedValue
    }
}

extension Percentage: Codable {}
