//
// Xcore
// Copyright © 2016 Xcore
// MIT license, see LICENSE file for details
//

import UIKit
import QuartzCore

extension CATransaction {
    /// A function to group animation transactions and call completion handler when
    /// animations for this transaction group are completed.
    ///
    /// - Parameters:
    ///   - animations: The block that have animations that must be completed before
    ///     completion handler is called.
    ///   - completion: A closure object called when animations for this transaction
    ///     group are completed.
    public static func animation(_ animations: () -> Void, completion: (() -> Void)?) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        animations()
        CATransaction.commit()
    }

    /// Disables transition animation.
    ///
    /// - Parameter work: The transition code that you want to perform without
    ///   animation.
    public static func performWithoutAnimation(_ work: () -> Void) {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        work()
        CATransaction.commit()
    }
}

// MARK: - CATransitionType

extension CATransitionType {
    public static let none = Self(rawValue: "")
}

// MARK: - CAMediaTimingFunction

extension CAMediaTimingFunction {
    @MainActor public static let `default` = CAMediaTimingFunction(name: .default)
    @MainActor public static let linear = CAMediaTimingFunction(name: .linear)
    @MainActor public static let easeIn = CAMediaTimingFunction(name: .easeIn)
    @MainActor public static let easeOut = CAMediaTimingFunction(name: .easeOut)
    @MainActor public static let easeInEaseOut = CAMediaTimingFunction(name: .easeInEaseOut)
}

// MARK: - CATransition

extension CATransition {
    @MainActor public static var fade: CATransition {
        CATransition().apply {
            $0.duration = .default
            $0.timingFunction = .easeInEaseOut
            $0.type = .fade
        }
    }
}

// MARK: - CALayer

extension CALayer {
    /// Returns the color of a given point in `self`.
    ///
    /// - Parameter point: The point to use to detect color.
    /// - Returns: `UIColor` at the specified point.
    public func color(at point: CGPoint) -> UIColor {
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        var pixel: [UInt8] = [0, 0, 0, 0]
        let context = CGContext(
            data: &pixel,
            width: 1,
            height: 1,
            bitsPerComponent: 8,
            bytesPerRow: 4,
            space: colorSpace,
            bitmapInfo: bitmapInfo.rawValue
        )!
        context.translateBy(x: -point.x, y: -point.y)
        render(in: context)
        return UIColor(
            .default,
            red: CGFloat(pixel[0]) / 255,
            green: CGFloat(pixel[1]) / 255,
            blue: CGFloat(pixel[2]) / 255,
            alpha: CGFloat(pixel[3]) / 255
        )
    }
}
