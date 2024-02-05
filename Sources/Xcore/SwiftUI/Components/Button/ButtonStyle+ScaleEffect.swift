//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

public struct ScaleEffectButtonStyle: ButtonStyle {
    private let anchor: UnitPoint

    public init(anchor: UnitPoint = .center) {
        self.anchor = anchor
    }

    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .contentShape(.rect)
            .scaleOpacityEffect(configuration.isPressed, effects: [.opacity, .scale(anchor: anchor)])
    }
}

// MARK: - Dot Syntax Support

extension ButtonStyle where Self == ScaleEffectButtonStyle {
    public static var scaleEffect: Self { .init() }

    public static func scaleEffect(anchor: UnitPoint) -> Self {
        .init(anchor: anchor)
    }
}
