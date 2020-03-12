//
// Xcore
// Copyright © 2018 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

public struct HighlightedAnimationOptions: OptionSet {
    public let rawValue: Int

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

    public static let scale = HighlightedAnimationOptions(rawValue: 1 << 0)
    public static let alpha = HighlightedAnimationOptions(rawValue: 1 << 1)
    public static let all: HighlightedAnimationOptions = [scale, alpha]
    public static let none: HighlightedAnimationOptions = []

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
