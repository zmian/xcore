//
// Xcore
// Copyright © 2015 Xcore
// MIT license, see LICENSE file for details
//

import UIKit
import SwiftUI

// MARK: - CGFloat

extension CGFloat {
    /// Converts an angle from degrees to radians.
    ///
    /// **Usage**
    ///
    /// ```swift
    /// let radians = 45.0.degreesToRadians()
    /// print(radians) // 0.7853981633974483
    /// ```
    ///
    /// - Returns: The angle in radians.
    public func degreesToRadians() -> Self {
        self * .pi / 180
    }

    /// Converts an angle from radians to degrees.
    ///
    /// **Usage**
    ///
    /// ```swift
    /// let degrees = (0.785).radiansToDegrees()
    /// print(degrees) // 44.999998
    /// ```
    ///
    /// - Returns: The angle in degrees.
    public func radiansToDegrees() -> Self {
        self * 180 / .pi
    }
}

// MARK: - CGRect

extension CGRect {
    /// Creates a `CGRect` with `.zero` origin and specified `size`.
    ///
    /// **Usage**
    ///
    /// ```swift
    /// let rect = CGRect(CGSize(width: 50, height: 100))
    /// ```
    ///
    /// - Parameter size: The size of the rectangle.
    public init(_ size: CGSize) {
        self = CGRect(origin: .zero, size: size)
    }
}

// MARK: - CGSize

extension CGSize {
    /// Returns the lesser of width and height.
    public var min: CGFloat {
        Swift.min(width, height)
    }

    /// Returns the greater of width and height.
    public var max: CGFloat {
        Swift.max(width, height)
    }

    /// Creates a square `CGSize` with equal width and height.
    public init(_ value: CGFloat) {
        self = CGSize(width: value, height: value)
    }

    // MARK: - Arithmetic Operators

    public static func +=(lhs: inout Self, rhs: Self) {
        lhs.width += rhs.width
        lhs.height += rhs.height
    }

    public static func +=(lhs: inout Self, rhs: CGFloat) {
        lhs = lhs + rhs
    }

    public static func +(lhs: Self, rhs: Self) -> Self {
        .init(width: lhs.width + rhs.width, height: lhs.height + rhs.height)
    }

    public static func +(lhs: Self, rhs: CGFloat) -> Self {
        .init(width: lhs.width + rhs, height: lhs.height + rhs)
    }

    public static func -=(lhs: inout Self, rhs: Self) {
        lhs.width -= rhs.width
        lhs.height -= rhs.height
    }

    public static func -=(lhs: inout Self, rhs: CGFloat) {
        lhs = lhs - rhs
    }

    public static func -(lhs: Self, rhs: Self) -> Self {
        .init(width: lhs.width - rhs.width, height: lhs.height - rhs.height)
    }

    public static func -(lhs: Self, rhs: CGFloat) -> Self {
        .init(width: lhs.width - rhs, height: lhs.height - rhs)
    }

    public static func *=(lhs: inout Self, rhs: Self) {
        lhs.width *= rhs.width
        lhs.height *= rhs.height
    }

    public static func *=(lhs: inout Self, rhs: CGFloat) {
        lhs = lhs * rhs
    }

    public static func *(lhs: Self, rhs: Self) -> Self {
        .init(width: lhs.width * rhs.width, height: lhs.height * rhs.height)
    }

    public static func *(lhs: Self, rhs: CGFloat) -> Self {
        .init(width: lhs.width * rhs, height: lhs.height * rhs)
    }
}

// MARK: - UILayoutPriority

extension UILayoutPriority {
    /// Returns a new priority by adding `rhs` to `lhs`.
    public static func +(lhs: Self, rhs: Float) -> Self {
        .init(lhs.rawValue + rhs)
    }

    /// Returns a new priority by subtracting `rhs` from `lhs`.
    public static func -(lhs: Self, rhs: Float) -> Self {
        .init(lhs.rawValue - rhs)
    }
}

// MARK: - Edge.Set

extension Edge.Set {
    /// `.leading`, `.trailing`, `.bottom`.
    public static let allButTop: Self = [.horizontal, .bottom]

    /// `.leading`, `.trailing`, `.top`.
    public static let allButBottom: Self = [.horizontal, .top]

    /// `.leading`, `.top`, `.bottom`.
    public static let allButTrailing: Self = [.leading, .vertical]

    /// `.trailing`, `.top`, `.bottom`.
    public static let allButLeading: Self = [.trailing, .vertical]
}

// MARK: - EdgeInsets

extension EdgeInsets {
    /// A zero-value `EdgeInsets` instance.
    public static let zero = Self(0)

    public init(_ edges: Edge.Set, _ length: CGFloat) {
        func value(edge: Edge.Set) -> CGFloat {
            edges.contains(edge) ? length : 0
        }

        self.init(
            top: value(edge: .top),
            leading: value(edge: .leading),
            bottom: value(edge: .bottom),
            trailing: value(edge: .trailing)
        )
    }

    public init(_ value: CGFloat) {
        self = .init(top: value, leading: value, bottom: value, trailing: value)
    }

    public var horizontal: CGFloat {
        get { leading + trailing }
        set {
            leading = newValue
            trailing = newValue
        }
    }

    public var vertical: CGFloat {
        get { top + bottom }
        set {
            top = newValue
            bottom = newValue
        }
    }
}

// MARK: - UIEdgeInsets

extension UIEdgeInsets {
    public init(_ edges: Edge.Set, _ length: CGFloat) {
        func value(edge: Edge.Set) -> CGFloat {
            edges.contains(edge) ? length : 0
        }

        self.init(
            top: value(edge: .top),
            left: value(edge: .leading),
            bottom: value(edge: .bottom),
            right: value(edge: .trailing)
        )
    }

    public init(_ value: CGFloat) {
        self = .init(top: value, left: value, bottom: value, right: value)
    }
}
