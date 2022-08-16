//
// Xcore
// Copyright © 2015 Xcore
// MIT license, see LICENSE file for details
//

import UIKit
import SwiftUI

// MARK: - CGFloat

extension CGFloat {
    /// A convenience method to convert an angle from degrees to radians.
    ///
    /// - Returns: `self` value in radians.
    public func degreesToRadians() -> Self {
        .pi * self / 180
    }

    /// A convenience method to convert an angle from radians to degrees.
    ///
    /// - Returns: `self` value in degrees.
    public func radiansToDegrees() -> Self {
        self * 180 / .pi
    }
}

// MARK: - CGRect

extension CGRect {
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
    public static func +(lhs: Self, rhs: Float) -> Self {
        .init(lhs.rawValue + rhs)
    }

    public static func -(lhs: Self, rhs: Float) -> Self {
        .init(lhs.rawValue - rhs)
    }
}

// MARK: - UIRectCorner

extension UIRectCorner {
    /// The top corner of the rectangle.
    public static let top: Self = [.topLeft, .topRight]

    /// The bottom corner of the rectangle.
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

// MARK: - CACornerMask

extension CACornerMask {
    /// All corners of the rectangle.
    public static let all: Self = [top, bottom]

    /// The top corner of the rectangle.
    public static let top: Self = [.layerMinXMinYCorner, .layerMaxXMinYCorner]

    /// The bottom corner of the rectangle.
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
