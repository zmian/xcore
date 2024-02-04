//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

public struct SeeMoreButtonStyle: ButtonStyle {
    @Environment(\.theme) private var theme
    private let alignment: Alignment
    private let padding: CGFloat?

    public init(padding: CGFloat? = nil, alignment: Alignment = .center) {
        self.padding = padding
        self.alignment = alignment
    }

    public func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .font(.app(.subheadline))
            .frame(maxWidth: alignment == .center ? .infinity : nil)
            .padding(padding ?? .s4)
            .foregroundStyle(theme.textSecondaryColor)
            .scaleOpacityEffect(
                configuration.isPressed,
                effects: [.opacity, .scale(anchor: alignment.unitPoint ?? .center)]
            )
            .contentShape(.rect)
    }
}

// MARK: - Dot Syntax Support

extension ButtonStyle where Self == SeeMoreButtonStyle {
    public static var seeMoreCentered: Self {
        .init()
    }

    public static var seeMore: Self {
        .init(padding: 0, alignment: .leading)
    }
}
