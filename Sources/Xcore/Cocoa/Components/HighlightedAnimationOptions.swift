//
// Xcore
// Copyright © 2018 Xcore
// MIT license, see LICENSE file for details
//

import UIKit
import SwiftUI

public struct HighlightedAnimationOptions: OptionSet {
    public let rawValue: Int

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

    public static let scale = Self(rawValue: 1 << 0)
    public static let opacity = Self(rawValue: 1 << 1)
    public static let all: Self = [scale, opacity]
}

// MARK: - UIKit

extension HighlightedAnimationOptions {
    func animate(_ button: UIButton) {
        animate(button, isHighlighted: button.isHighlighted)
    }

    public func animate(_ transitionView: UIView, isHighlighted: Bool) {
        guard !isEmpty else { return }

        let transform: CGAffineTransform = contains(.scale) ? (isHighlighted ? .defaultScale : .identity) : transitionView.transform
        let opacity: CGFloat = contains(.opacity) ? (isHighlighted ? 0.9 : 1) : transitionView.alpha

        UIView.animateFromCurrentState {
            transitionView.transform = transform
            transitionView.alpha = opacity
        }
    }
}

// MARK: - SwiftUI

extension View {
    public func scaleOpacityEffect(_ isPressed: Bool, options: HighlightedAnimationOptions = .all) -> some View {
        let opacity = options.contains(.opacity) ? (isPressed ? 0.8 : 1) : 1
        let scale: CGFloat = options.contains(.scale) ? (isPressed ? 0.95 : 1) : 1

        return withAnimation(.easeInOut) {
            self
                .scaleEffect(scale)
                .opacity(opacity)
        }
    }
}
