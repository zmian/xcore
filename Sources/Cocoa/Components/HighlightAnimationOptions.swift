//
// HighlightAnimationOptions.swift
//
// Copyright © 2018 Zeeshan Mian
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

public struct HighlightAnimationOptions: OptionSet {
    public let rawValue: UInt
    public init(rawValue: UInt) {
        self.rawValue = rawValue
    }

    public static let scale = HighlightAnimationOptions(rawValue: 1 << 0)
    public static let alpha = HighlightAnimationOptions(rawValue: 1 << 1)
    public static let all: HighlightAnimationOptions = [scale, alpha]

    func animate(_ button: UIButton) {
        animate(button, isHighlighted: button.isHighlighted)
    }

    public func animate(_ transitionView: UIView, isHighlighted: Bool) {
        guard !isEmpty else { return }

        let transform: CGAffineTransform = contains(.scale) ? (isHighlighted ? .defaultScale : .identity) : transitionView.transform
        let alpha: CGFloat = contains(.alpha) ? (isHighlighted ? 0.9 : 1) : transitionView.alpha

        UIView.animateFromCurrentState {
            transitionView.transform = transform
            transitionView.alpha = alpha
        }
    }
}
