//
// CoreAnimationExtensions.swift
//
// Copyright © 2016 Zeeshan Mian
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
    /// - parameter animateBlock:      The block that have animations that must be completed before completion handler is called.
    /// - parameter completionHandler: A block object called when animations for this transaction group are completed.
    public static func animationTransaction(@noescape animateBlock: () -> Void, completionHandler: (() -> Void)?) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completionHandler)
        animateBlock()
        CATransaction.commit()
    }
}

extension CALayer {
    /// A convenience method to return the color of a given point in `self`.
    ///
    /// - parameter point: The point to use to detect color.
    ///
    /// - returns: UIColor of the specified point.
    public func color(ofPoint point: CGPoint) -> UIColor {
        let width = 1
        let height = 1
        let bitsPerComponent = 8
        let bytesPerRow = 4 * height
        var pixel: [UInt8] = [0, 0, 0, 0]
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.PremultipliedLast.rawValue)
        let context = CGBitmapContextCreate(UnsafeMutablePointer(pixel), width, height, bitsPerComponent, bytesPerRow, colorSpace, bitmapInfo.rawValue)!
        CGContextTranslateCTM(context, -point.x, -point.y)
        renderInContext(context)
        return UIColor(colorLiteralRed: Float(pixel[0])/255, green: Float(pixel[1])/255, blue: Float(pixel[2])/255, alpha: Float(pixel[3])/255)
    }
}
