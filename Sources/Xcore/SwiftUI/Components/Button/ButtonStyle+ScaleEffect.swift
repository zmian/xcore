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

    public func makeBody(configuration: Self.Configuration) -> some View {
        EnvironmentReader(\.defaultButtonFont) { font in
            configuration.label
                .contentShape(Rectangle())
                .scaleOpacityEffect(configuration.isPressed, effects: [.opacity, .scale(anchor: anchor)])
                .unwrap(font) { view, font in
                    view.font(font)
                }
        }
    }
}

// MARK: - Dot Syntax Support

extension ButtonStyle where Self == ScaleEffectButtonStyle {
    public static var scaleEffect: Self { .init() }

    public static func scaleEffect(anchor: UnitPoint) -> Self {
        .init(anchor: anchor)
    }
}
