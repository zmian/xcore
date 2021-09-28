//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

public struct ScaleEffectButtonStyle: ButtonStyle {
    public init() {}

    public func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .scaleOpacityEffect(configuration.isPressed)
    }
}

// MARK: - Dot Syntax Support

extension ButtonStyle where Self == ScaleEffectButtonStyle {
    public static var scaleEffect: Self { .init() }
}
