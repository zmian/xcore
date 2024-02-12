//
// Xcore
// Copyright © 2018 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

/// An enumeration representing the animation effect on press.
public enum PressedAnimationEffect: Hashable {
    /// Changes view opacity on press.
    case opacity

    /// Changes view scale on press with anchor point indicating the starting
    /// position for the scale operation.
    case scale(anchor: UnitPoint)

    /// Changes view scale on press with center anchor point for the scale
    /// operation.
    public static var scale: Self {
        .scale(anchor: .center)
    }

    /// The anchor point with a default of center that indicates the starting
    /// position for the scale operation.
    fileprivate var anchor: UnitPoint {
        switch self {
            case .opacity:
                return .center
            case let .scale(anchor):
                return anchor
        }
    }

    /// A Boolean property indicating whether `self` is equals to `scale`, ignoring
    /// the anchor position.
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
    ///
    /// - Parameters:
    ///   - isPressed: A Boolean value indicating whether the user is currently
    ///     pressing the view.
    ///   - effects: A list of effects to apply when `isPressed` is `true`.
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
            .animation(.spring, value: isPressed)
    }
}
