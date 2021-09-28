//
// Xcore
// Copyright © 2015 Xcore
// MIT license, see LICENSE file for details
//

import UIKit
import SwiftUI

// MARK: - CGFloat - Extensions

/// The value of `π` as a `CGFloat`.
public let π = CGFloat.pi

extension CGFloat {
    /// A convenience method to convert an angle from degrees to radians.
    ///
    /// - Returns: `self` value in radians.
    public func degreesToRadians() -> Self {
        π * self / 180
    }

    /// A convenience method to convert an angle from radians to degrees.
    ///
    /// - Returns: `self` value in degrees.
    public func radiansToDegrees() -> Self {
        self * 180 / π
    }
}

// MARK: - UIEdgeInsets - ExpressibleByFloatLiteral

extension UIEdgeInsets: ExpressibleByFloatLiteral {
    public init(floatLiteral value: FloatLiteralType) {
        self = UIEdgeInsets(CGFloat(value))
    }
}

// MARK: - UIEdgeInsets - ExpressibleByIntegerLiteral

extension UIEdgeInsets: ExpressibleByIntegerLiteral {
    public init(integerLiteral value: IntegerLiteralType) {
        self = UIEdgeInsets(CGFloat(value))
    }
}

// MARK: - UIEdgeInsets - Extensions

extension UIEdgeInsets {
    public init(_ value: CGFloat) {
        self = .init(top: value, left: value, bottom: value, right: value)
    }

    public init(top: CGFloat) {
        self = .init(top: top, left: 0, bottom: 0, right: 0)
    }

    public init(left: CGFloat) {
        self = .init(top: 0, left: left, bottom: 0, right: 0)
    }

    public init(bottom: CGFloat) {
        self = .init(top: 0, left: 0, bottom: bottom, right: 0)
    }

    public init(right: CGFloat) {
        self = .init(top: 0, left: 0, bottom: 0, right: right)
    }

    public init(horizontal: CGFloat, vertical: CGFloat) {
        self = .init(top: vertical, left: horizontal, bottom: vertical, right: horizontal)
    }

    public init(horizontal: CGFloat) {
        self = .init(top: 0, left: horizontal, bottom: 0, right: horizontal)
    }

    public init(horizontal: CGFloat, top: CGFloat) {
        self = .init(top: top, left: horizontal, bottom: 0, right: horizontal)
    }

    public init(horizontal: CGFloat, bottom: CGFloat) {
        self = .init(top: 0, left: horizontal, bottom: bottom, right: horizontal)
    }

    public init(vertical: CGFloat) {
        self = .init(top: vertical, left: 0, bottom: vertical, right: 0)
    }

    public init(vertical: CGFloat, left: CGFloat) {
        self = .init(top: vertical, left: left, bottom: vertical, right: 0)
    }

    public init(vertical: CGFloat, right: CGFloat) {
        self = .init(top: vertical, left: 0, bottom: vertical, right: right)
    }

    public var horizontal: CGFloat {
        get { left + right }
        set {
            left = newValue
            right = newValue
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

extension UIEdgeInsets {
    public static func +=(lhs: inout Self, rhs: Self) {
        lhs.top += rhs.top
        lhs.left += rhs.left
        lhs.bottom += rhs.bottom
        lhs.right += rhs.right
    }

    public static func +=(lhs: inout Self, rhs: CGFloat) {
        lhs.horizontal = rhs
        lhs.vertical = rhs
    }

    public static func +(lhs: Self, rhs: Self) -> Self {
        .init(
            top: lhs.top + rhs.top,
            left: lhs.left + rhs.left,
            bottom: lhs.bottom + rhs.bottom,
            right: lhs.right + rhs.right
        )
    }

    public static func +(lhs: Self, rhs: CGFloat) -> Self {
        .init(
            top: lhs.top + rhs,
            left: lhs.left + rhs,
            bottom: lhs.bottom + rhs,
            right: lhs.right + rhs
        )
    }
}

extension UIEdgeInsets {
    public static func -=(lhs: inout Self, rhs: Self) {
        lhs.top -= rhs.top
        lhs.left -= rhs.left
        lhs.bottom -= rhs.bottom
        lhs.right -= rhs.right
    }

    public static func -=(lhs: inout Self, rhs: CGFloat) {
        lhs.top -= rhs
        lhs.left -= rhs
        lhs.bottom -= rhs
        lhs.right -= rhs
    }

    public static func -(lhs: Self, rhs: Self) -> Self {
        .init(
            top: lhs.top - rhs.top,
            left: lhs.left - rhs.left,
            bottom: lhs.bottom - rhs.bottom,
            right: lhs.right - rhs.right
        )
    }

    public static func -(lhs: Self, rhs: CGFloat) -> Self {
        .init(
            top: lhs.top - rhs,
            left: lhs.left - rhs,
            bottom: lhs.bottom - rhs,
            right: lhs.right - rhs
        )
    }
}

// MARK: - CGSize - Extensions

extension CGSize {
    /// Returns the lesser of width and height.
    public var min: CGFloat {
        Swift.min(width, height)
    }

    /// Returns the greater of width and height.
    public var max: CGFloat {
        Swift.max(width, height)
    }
}

extension CGSize {
    public init(_ value: CGFloat) {
        self = CGSize(width: value, height: value)
    }

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
}

extension CGSize {
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
}

extension CGSize {
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

// MARK: - CGRect - Extensions

extension CGRect {
    public init(_ size: CGSize) {
        self = CGRect(origin: .zero, size: size)
    }
}

// MARK: - UILayoutPriority - Extensions

extension UILayoutPriority {
    public static func +(lhs: Self, rhs: Float) -> Self {
        .init(lhs.rawValue + rhs)
    }

    public static func -(lhs: Self, rhs: Float) -> Self {
        .init(lhs.rawValue - rhs)
    }
}

// MARK: - UIRectCorner - Extensions

extension UIRectCorner {
    public static let top: Self = [.topLeft, .topRight]
    public static let bottom: Self = [.bottomLeft, .bottomRight]

    public init(_ corner: CACornerMask) {
        self = .none

        if corner.contains(.layerMinXMinYCorner) {
            self.insert(.topLeft)
        }

        if corner.contains(.layerMaxXMinYCorner) {
            self.insert(.topRight)
        }

        if corner.contains(.layerMinXMaxYCorner) {
            self.insert(.bottomLeft)
        }

        if corner.contains(.layerMaxXMaxYCorner) {
            self.insert(.bottomRight)
        }
    }
}

// MARK: - CACornerMask - Extensions

extension CACornerMask {
    public static let all: Self = [top, bottom]
    public static let top: Self = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    public static let bottom: Self = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]

    public init(_ corner: UIRectCorner) {
        self = .none

        if corner.contains(.topLeft) {
            self.insert(.layerMinXMinYCorner)
        }

        if corner.contains(.topRight) {
            self.insert(.layerMaxXMinYCorner)
        }

        if corner.contains(.bottomLeft) {
            self.insert(.layerMinXMaxYCorner)
        }

        if corner.contains(.bottomRight) {
            self.insert(.layerMaxXMaxYCorner)
        }
    }
}

// MARK: - EdgeInsets - Extensions

extension EdgeInsets {
    public static let zero = Self(0)

    public init(_ value: CGFloat) {
        self = .init(top: value, leading: value, bottom: value, trailing: value)
    }

    public init(top: CGFloat) {
        self = .init(top: top, leading: 0, bottom: 0, trailing: 0)
    }

    public init(leading: CGFloat) {
        self = .init(top: 0, leading: leading, bottom: 0, trailing: 0)
    }

    public init(bottom: CGFloat) {
        self = .init(top: 0, leading: 0, bottom: bottom, trailing: 0)
    }

    public init(trailing: CGFloat) {
        self = .init(top: 0, leading: 0, bottom: 0, trailing: trailing)
    }

    public init(horizontal: CGFloat, vertical: CGFloat) {
        self = .init(top: vertical, leading: horizontal, bottom: vertical, trailing: horizontal)
    }

    public init(horizontal: CGFloat) {
        self = .init(top: 0, leading: horizontal, bottom: 0, trailing: horizontal)
    }

    public init(horizontal: CGFloat, top: CGFloat) {
        self = .init(top: top, leading: horizontal, bottom: 0, trailing: horizontal)
    }

    public init(horizontal: CGFloat, bottom: CGFloat) {
        self = .init(top: 0, leading: horizontal, bottom: bottom, trailing: horizontal)
    }

    public init(vertical: CGFloat) {
        self = .init(top: vertical, leading: 0, bottom: vertical, trailing: 0)
    }

    public init(vertical: CGFloat, leading: CGFloat) {
        self = .init(top: vertical, leading: leading, bottom: vertical, trailing: 0)
    }

    public init(vertical: CGFloat, trailing: CGFloat) {
        self = .init(top: vertical, leading: 0, bottom: vertical, trailing: trailing)
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
