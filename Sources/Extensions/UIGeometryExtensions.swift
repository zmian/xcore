//
// UIKitExtensions.swift
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

public extension UIEdgeInsets {
    public init(all: CGFloat) {
        self = UIEdgeInsets(top: all, left: all, bottom: all, right: all)
    }

    public init(horizontal: CGFloat, vertical: CGFloat) {
        self = UIEdgeInsets(top: vertical, left: horizontal, bottom: vertical, right: horizontal)
    }
}

/// The value of `π` as a `CGFloat`.
public let π = CGFloat(M_PI)

public extension CGFloat {
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

public func +=(lhs: inout CGSize, rhs: CGSize) {
    lhs.width  += rhs.width
    lhs.height += rhs.height
}

public func +(lhs: CGSize, rhs: CGSize) -> CGSize {
    return CGSize(width: lhs.width + rhs.width, height: lhs.height + rhs.height)
}

public func +(lhs: CGSize, rhs: CGFloat) -> CGSize {
    return CGSize(width: lhs.width + rhs, height: lhs.height + rhs)
}

public func +=(lhs: inout CGSize, rhs: CGFloat) {
    lhs = lhs + rhs
}
