//
// UIKit+Extensions.swift
//
// Copyright © 2015 Xcore
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

import UIKit

// MARK: - CGFloat - Extensions

/// The value of `π` as a `CGFloat`.
public let π = CGFloat.pi

extension CGFloat {
    /// A convenience method to convert an angle from degrees to radians.
    ///
    /// - Returns: `self` value in radians.
    public func degreesToRadians() -> CGFloat {
        return π * self / 180
    }

    /// A convenience method to convert an angle from radians to degrees.
    ///
    /// - Returns: `self` value in degrees.
    public func radiansToDegrees() -> CGFloat {
        return self * 180 / π
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
        self = UIEdgeInsets(top: value, left: value, bottom: value, right: value)
    }

    public init(top: CGFloat) {
        self = UIEdgeInsets(top: top, left: 0, bottom: 0, right: 0)
    }

    public init(left: CGFloat) {
        self = UIEdgeInsets(top: 0, left: left, bottom: 0, right: 0)
    }

    public init(bottom: CGFloat) {
        self = UIEdgeInsets(top: 0, left: 0, bottom: bottom, right: 0)
    }

    public init(right: CGFloat) {
        self = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: right)
    }

    public init(horizontal: CGFloat, vertical: CGFloat) {
        self = UIEdgeInsets(top: vertical, left: horizontal, bottom: vertical, right: horizontal)
    }

    public init(horizontal: CGFloat) {
        self = UIEdgeInsets(top: 0, left: horizontal, bottom: 0, right: horizontal)
    }

    public init(horizontal: CGFloat, top: CGFloat) {
        self = UIEdgeInsets(top: top, left: horizontal, bottom: 0, right: horizontal)
    }

    public init(horizontal: CGFloat, bottom: CGFloat) {
        self = UIEdgeInsets(top: 0, left: horizontal, bottom: bottom, right: horizontal)
    }

    public init(vertical: CGFloat) {
        self = UIEdgeInsets(top: vertical, left: 0, bottom: vertical, right: 0)
    }

    public init(vertical: CGFloat, left: CGFloat) {
        self = UIEdgeInsets(top: vertical, left: left, bottom: vertical, right: 0)
    }

    public init(vertical: CGFloat, right: CGFloat) {
        self = UIEdgeInsets(top: vertical, left: 0, bottom: vertical, right: right)
    }

    public var horizontal: CGFloat {
        get { return left + right }
        set {
            left = newValue
            right = newValue
        }
    }

    public var vertical: CGFloat {
        get { return top + bottom }
        set {
            top = newValue
            bottom = newValue
        }
    }
}

extension UIEdgeInsets {
    public static func +=(lhs: inout UIEdgeInsets, rhs: UIEdgeInsets) {
        lhs.top    += rhs.top
        lhs.left   += rhs.left
        lhs.bottom += rhs.bottom
        lhs.right  += rhs.right
    }

    public static func +=(lhs: inout UIEdgeInsets, rhs: CGFloat) {
        lhs.horizontal = rhs
        lhs.vertical = rhs
    }

    public static func +(lhs: UIEdgeInsets, rhs: UIEdgeInsets) -> UIEdgeInsets {
        return UIEdgeInsets(
            top: lhs.top + rhs.top,
            left: lhs.left + rhs.left,
            bottom: lhs.bottom + rhs.bottom,
            right: lhs.right + rhs.right
        )
    }

    public static func +(lhs: UIEdgeInsets, rhs: CGFloat) -> UIEdgeInsets {
        return UIEdgeInsets(
            top: lhs.top + rhs,
            left: lhs.left + rhs,
            bottom: lhs.bottom + rhs,
            right: lhs.right + rhs
        )
    }
}

extension UIEdgeInsets {
    public static func -=(lhs: inout UIEdgeInsets, rhs: UIEdgeInsets) {
        lhs.top    -= rhs.top
        lhs.left   -= rhs.left
        lhs.bottom -= rhs.bottom
        lhs.right  -= rhs.right
    }

    public static func -=(lhs: inout UIEdgeInsets, rhs: CGFloat) {
        lhs.top    -= rhs
        lhs.left   -= rhs
        lhs.bottom -= rhs
        lhs.right  -= rhs
    }

    public static func -(lhs: UIEdgeInsets, rhs: UIEdgeInsets) -> UIEdgeInsets {
        return UIEdgeInsets(
            top: lhs.top - rhs.top,
            left: lhs.left - rhs.left,
            bottom: lhs.bottom - rhs.bottom,
            right: lhs.right - rhs.right
        )
    }

    public static func -(lhs: UIEdgeInsets, rhs: CGFloat) -> UIEdgeInsets {
        return UIEdgeInsets(
            top: lhs.top - rhs,
            left: lhs.left - rhs,
            bottom: lhs.bottom - rhs,
            right: lhs.right - rhs
        )
    }
}

// MARK: - CGSize - ExpressibleByFloatLiteral

extension CGSize: ExpressibleByFloatLiteral {
    public init(floatLiteral value: FloatLiteralType) {
        let value = CGFloat(value)
        self = CGSize(width: value, height: value)
    }
}

// MARK: - CGSize - ExpressibleByIntegerLiteral

extension CGSize: ExpressibleByIntegerLiteral {
    public init(integerLiteral value: IntegerLiteralType) {
        let value = CGFloat(value)
        self = CGSize(width: value, height: value)
    }
}

// MARK: - CGSize - Extensions

extension CGSize {
    /// Returns the lesser of width and height.
    public var min: CGFloat {
        return Swift.min(width, height)
    }

    /// Returns the greater of width and height.
    public var max: CGFloat {
        return Swift.max(width, height)
    }
}

extension CGSize {
    public init(_ value: CGFloat) {
        self = CGSize(width: value, height: value)
    }

    public static func +=(lhs: inout CGSize, rhs: CGSize) {
        lhs.width += rhs.width
        lhs.height += rhs.height
    }

    public static func +=(lhs: inout CGSize, rhs: CGFloat) {
        lhs = lhs + rhs
    }

    public static func +(lhs: CGSize, rhs: CGSize) -> CGSize {
        return CGSize(width: lhs.width + rhs.width, height: lhs.height + rhs.height)
    }

    public static func +(lhs: CGSize, rhs: CGFloat) -> CGSize {
        return CGSize(width: lhs.width + rhs, height: lhs.height + rhs)
    }
}

extension CGSize {
    public static func -=(lhs: inout CGSize, rhs: CGSize) {
        lhs.width -= rhs.width
        lhs.height -= rhs.height
    }

    public static func -=(lhs: inout CGSize, rhs: CGFloat) {
        lhs = lhs - rhs
    }

    public static func -(lhs: CGSize, rhs: CGSize) -> CGSize {
        return CGSize(width: lhs.width - rhs.width, height: lhs.height - rhs.height)
    }

    public static func -(lhs: CGSize, rhs: CGFloat) -> CGSize {
        return CGSize(width: lhs.width - rhs, height: lhs.height - rhs)
    }
}

extension CGSize {
    public static func *=(lhs: inout CGSize, rhs: CGSize) {
        lhs.width *= rhs.width
        lhs.height *= rhs.height
    }

    public static func *=(lhs: inout CGSize, rhs: CGFloat) {
        lhs = lhs * rhs
    }

    public static func *(lhs: CGSize, rhs: CGSize) -> CGSize {
        return CGSize(width: lhs.width * rhs.width, height: lhs.height * rhs.height)
    }

    public static func *(lhs: CGSize, rhs: CGFloat) -> CGSize {
        return CGSize(width: lhs.width * rhs, height: lhs.height * rhs)
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
    public static func +(lhs: UILayoutPriority, rhs: Float) -> UILayoutPriority {
        return UILayoutPriority(lhs.rawValue + rhs)
    }

    public static func -(lhs: UILayoutPriority, rhs: Float) -> UILayoutPriority {
        return UILayoutPriority(lhs.rawValue - rhs)
    }
}

// MARK: - UIRectCorner - Extensions

extension UIRectCorner {
    public static let none: UIRectCorner = []
    public static let top: UIRectCorner = [.topLeft, .topRight]
    public static let bottom: UIRectCorner = [.bottomLeft, .bottomRight]
}
