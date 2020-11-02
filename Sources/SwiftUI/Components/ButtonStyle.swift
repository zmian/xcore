//
// Xcore
// Copyright © 2020 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

// MARK: - Fill

public struct FillButtonStyle: ButtonStyle {
    public init() { }

    public func makeBody(configuration: Self.Configuration) -> some View {
        StyleBody(configuration: configuration)
    }

    private struct StyleBody: View {
        let configuration: ButtonStyleConfiguration
        @Environment(\.defaultMinButtonHeight) private var minHeight
        @Environment(\.defaultButtonCornerRadius) private var cornerRadius
        @Environment(\.theme) private var theme
        @Environment(\.isEnabled) private var isEnabled: Bool

        var body: some View {
            configuration.label
                .frame(minHeight: minHeight)
                .padding(.horizontal)
                .foregroundColor(
                    Color(
                        isEnabled ?
                            .white :
                            UIColor.black.alpha(0.2)
                    )
                )
                .background(
                    Color(
                        isEnabled ?
                            self.theme.buttonBackgroundColor :
                            (self.theme.isDark ? UIColor.white.alpha(0.1) : .appBackgroundDisabled)
                    )
                )
                .cornerRadius(cornerRadius)
                .scaleEffect(CGFloat(configuration.isPressed ? 0.95 : 1))
                .opacity(configuration.isPressed ? 0.8 : 1)
                .animation(.default)
        }
    }
}

// MARK: - Outline

public struct OutlineButtonStyle: ButtonStyle {
    public init() { }

    public func makeBody(configuration: Self.Configuration) -> some View {
        StyleBody(configuration: configuration)
    }

    private struct StyleBody: View {
        let configuration: ButtonStyleConfiguration
        @Environment(\.defaultMinButtonHeight) private var minHeight
        @Environment(\.defaultButtonCornerRadius) private var cornerRadius
        @Environment(\.theme) private var theme
        @Environment(\.isEnabled) private var isEnabled: Bool

        var body: some View {
            configuration.label
                .frame(minHeight: minHeight)
                .padding(.horizontal)
                .foregroundColor(color)
                .background(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(color)
                )
                .scaleEffect(CGFloat(configuration.isPressed ? 0.95 : 1))
                .opacity(configuration.isPressed ? 0.8 : 1)
                .animation(.default)
        }

        private var color: Color {
            Color(
                isEnabled ?
                    self.theme.buttonTextColor :
                    self.theme.isDark ? UIColor.white.alpha(0.1) : UIColor.black.alpha(0.2)
            )
        }
    }
}

// MARK: - Pill

public struct PillButtonStyle: ButtonStyle {
    public init() { }

    public func makeBody(configuration: Self.Configuration) -> some View {
        StyleBody(configuration: configuration)
    }

    private struct StyleBody: View {
        let configuration: ButtonStyleConfiguration
        @Environment(\.defaultMinButtonHeight) private var minHeight
        @Environment(\.theme) private var theme
        @Environment(\.isEnabled) private var isEnabled: Bool

        var body: some View {
            configuration.label
                .frame(minHeight: minHeight)
                .padding(.horizontal)
                .foregroundColor(
                    Color(
                        isEnabled ?
                            .white :
                            UIColor.black.alpha(0.2)
                    )
                )
                .background(
                    Capsule()
                        .fill(Color(
                            isEnabled ?
                                self.theme.buttonBackgroundColor :
                                (self.theme.isDark ? UIColor.white.alpha(0.1) : .appBackgroundDisabled)
                        ))
                )
                .scaleEffect(CGFloat(configuration.isPressed ? 0.95 : 1))
                .opacity(configuration.isPressed ? 0.8 : 1)
                .animation(.default)
        }
    }
}
