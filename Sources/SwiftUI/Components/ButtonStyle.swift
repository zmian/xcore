//
// Xcore
// Copyright © 2020 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

// MARK: - Fill

public struct FillButtonStyle: ButtonStyle {
    @SwiftUI.Environment(\.defaultMinButtonHeight) var minHeight
    @SwiftUI.Environment(\.defaultButtonCornerRadius) var cornerRadius
    @SwiftUI.Environment(\.theme) var theme

    public init() { }

    public func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .frame(minHeight: minHeight)
            .padding(.horizontal)
            .foregroundColor(.white)
            .background(Color(theme.buttonTextColor))
            .cornerRadius(cornerRadius)
            .scaleEffect(CGFloat(configuration.isPressed ? 0.95 : 1))
            .opacity(configuration.isPressed ? 0.8 : 1)
            .animation(.spring())
    }
}

// MARK: - Outline

public struct OutlineButtonStyle: ButtonStyle {
    @SwiftUI.Environment(\.defaultMinButtonHeight) var minHeight
    @SwiftUI.Environment(\.defaultButtonCornerRadius) var cornerRadius
    @SwiftUI.Environment(\.theme) var theme

    public init() { }

    public func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .frame(minHeight: minHeight)
            .padding(.horizontal)
            .foregroundColor(Color(theme.buttonTextColor))
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(Color(theme.buttonTextColor))
            )
            .scaleEffect(CGFloat(configuration.isPressed ? 0.95 : 1))
            .opacity(configuration.isPressed ? 0.8 : 1)
            .animation(.spring())
    }
}

// MARK: - Pill

public struct PillButtonStyle: ButtonStyle {
    @SwiftUI.Environment(\.defaultMinButtonHeight) var minHeight
    @SwiftUI.Environment(\.theme) var theme

    public init() { }

    public func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .frame(minHeight: minHeight)
            .padding(.horizontal)
            .foregroundColor(.white)
            .background(
                Capsule()
                    .fill(Color(theme.buttonTextColor))
            )
            .scaleEffect(CGFloat(configuration.isPressed ? 0.95 : 1))
            .opacity(configuration.isPressed ? 0.8 : 1)
            .animation(.spring())
    }
}
