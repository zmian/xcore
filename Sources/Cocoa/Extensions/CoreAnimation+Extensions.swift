//
// CoreAnimation+Extensions.swift
//
// Copyright © 2016 Xcore
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
import QuartzCore

extension CATransaction {
    /// A helper function to group animation transactions and call completion handler when animations for this transaction group are completed.
    ///
    /// - Parameters:
    ///   - animateBlock: The block that have animations that must be completed before completion handler is called.
    ///   - completionHandler: A block object called when animations for this transaction group are completed.
    public static func animationTransaction(_ animateBlock: () -> Void, completionHandler: (() -> Void)?) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completionHandler)
        animateBlock()
        CATransaction.commit()
    }

    /// Disables transition animation.
    ///
    /// - Parameter actionsWithoutAnimation: The transition code that you want to perform without animation.
    public static func performWithoutAnimation(_ actionsWithoutAnimation: () -> Void) {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        actionsWithoutAnimation()
        CATransaction.commit()
    }
}

extension CATransitionType {
    public static let none = CATransitionType(rawValue: "")
}

extension CAMediaTimingFunction {
    public static let `default` = CAMediaTimingFunction(name: .default)
    public static let linear = CAMediaTimingFunction(name: .linear)
    public static let easeIn = CAMediaTimingFunction(name: .easeIn)
    public static let easeOut = CAMediaTimingFunction(name: .easeOut)
    public static let easeInEaseOut = CAMediaTimingFunction(name: .easeInEaseOut)
}

extension CALayer {
    /// A convenience method to return the color at given point in `self`.
    ///
    /// - Parameter point: The point to use to detect color.
    /// - Returns: `UIColor` at the specified point.
    public func color(at point: CGPoint) -> UIColor {
        let width = 1
        let height = 1
        let bitsPerComponent = 8
        let bytesPerRow = 4 * height
        var pixel: [UInt8] = [0, 0, 0, 0]
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        let context = CGContext(data: UnsafeMutablePointer(mutating: pixel), width: width, height: height, bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)!
        context.translateBy(x: -point.x, y: -point.y)
        render(in: context)
        return UIColor(red: CGFloat(pixel[0])/255, green: CGFloat(pixel[1])/255, blue: CGFloat(pixel[2])/255, alpha: CGFloat(pixel[3])/255)
    }
}

extension CGColor {
    public var uiColor: UIColor {
        return UIColor(cgColor: self)
    }
}
