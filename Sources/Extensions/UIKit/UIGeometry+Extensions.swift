//
// UIKit+Extensions.swift
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

import UIKit

extension UIEdgeInsets {
    public init(_ value: CGFloat) {
        self = UIEdgeInsets(top: value, left: value, bottom: value, right: value)
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

/// The value of `π` as a `CGFloat`.
public let π = CGFloat.pi

extension CGFloat {
    /// A convenience method to convert an angle from degrees to radians.
    ///
    /// - returns: `self` value in radians.
    public func degreesToRadians() -> CGFloat {
        return π * self / 180
    }

    /// A convenience method to convert an angle from radians to degrees.
    ///
    /// - returns: `self` value in degrees.
    public func radiansToDegrees() -> CGFloat {
        return self * 180 / π
    }
}

extension CGSize {
    public init(_ value: CGFloat) {
        self = CGSize(width: value, height: value)
    }

    public static func +=(lhs: inout CGSize, rhs: CGSize) {
        lhs.width  += rhs.width
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
        lhs.width  -= rhs.width
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

#if swift(>=4)
extension UILayoutPriority {
    public static func +(lhs: UILayoutPriority, rhs: Float) -> UILayoutPriority {
        return UILayoutPriority(lhs.rawValue + rhs)
    }

    public static func -(lhs: UILayoutPriority, rhs: Float) -> UILayoutPriority {
        return UILayoutPriority(lhs.rawValue - rhs)
    }
}
#endif
