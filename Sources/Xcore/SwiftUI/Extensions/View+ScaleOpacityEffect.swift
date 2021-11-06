//
// Xcore
// Copyright © 2018 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

public enum PressedAnimationEffect: Hashable {
    case opacity
    case scale(anchor: UnitPoint)

    public static var scale: Self {
        .scale(anchor: .center)
    }

    fileprivate var anchor: UnitPoint {
        switch self {
            case .opacity:
                return .center
            case let .scale(anchor):
                return anchor
        }
    }

    fileprivate var isScale: Bool {
        if case .scale = self {
            return true
        }

        return false
    }
}

extension View {
    /// Scales and sets the transparency of this view based on the given effects
    /// when `isPressed` is `true`
    public func scaleOpacityEffect(
        _ isPressed: Bool,
        effects: [PressedAnimationEffect] = [.opacity, .scale]
    ) -> some View {
        let opacity = effects.contains(.opacity) ? (isPressed ? 0.8 : 1) : 1

        // Scale
        let scaleOption = effects.first(where: \.isScale)
        let scale = scaleOption.isNotNil ? (isPressed ? 0.95 : 1) : 1
        let anchor = scaleOption?.anchor ?? .center

        return self
            .opacity(opacity)
            .scaleEffect(scale, anchor: anchor)
            .animation(.spring(), value: isPressed)
    }
}
