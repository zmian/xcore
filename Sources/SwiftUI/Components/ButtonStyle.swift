//
// Xcore
// Copyright © 2020 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

// MARK: - Scale and Opacity

public struct ScaleEffectButtonStyle: ButtonStyle {
    public init() { }

    public func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .scaleOpacityEffect(configuration.isPressed)
    }
}

// MARK: - Fill

public struct FillButtonStyle: ButtonStyle {
    public init() { }

    public func makeBody(configuration: Self.Configuration) -> some View {
        FillStyleBody(id: .fill, configuration: configuration) {
            RoundedRectangle(cornerRadius: $0.cornerRadius, style: .continuous)
        }
    }
}

// MARK: - Pill

public struct PillButtonStyle: ButtonStyle {
    public init() { }

    public func makeBody(configuration: Self.Configuration) -> some View {
        FillStyleBody(id: .pill, configuration: configuration) { _ in
            Capsule()
        }
    }
}

// MARK: - Outline

public struct OutlineButtonStyle: ButtonStyle {
    public init() { }

    public func makeBody(configuration: Self.Configuration) -> some View {
        InternalBody(configuration: configuration)
    }

    private struct InternalBody: View {
        let configuration: ButtonStyleConfiguration
        @Environment(\.defaultMinButtonHeight) private var minHeight
        @Environment(\.defaultButtonCornerRadius) private var cornerRadius
        @Environment(\.defaultOutlineButtonBorderColor) private var _borderColor
        @Environment(\.theme) private var theme
        @Environment(\.isEnabled) private var isEnabled

        var body: some View {
            configuration.label
                .frame(maxWidth: .infinity, minHeight: minHeight)
                .padding(.horizontal)
                .foregroundColor(foregroundColor)
                .background(
                    RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                        .strokeBorder(borderColor, lineWidth: .onePixel)
                )
                .contentShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
                .scaleOpacityEffect(configuration.isPressed)
        }

        private var foregroundColor: Color {
            Color(isEnabled ? theme.textColor : theme.textSecondaryColor)
        }

        private var borderColor: Color {
            if isEnabled, let color = _borderColor {
                return color
            }

            return foregroundColor
        }
    }
}

// MARK: - Helper

private struct FillStyleBody<S: Shape>: View {
    @Environment(\.defaultMinButtonHeight) private var minHeight
    @Environment(\.defaultButtonCornerRadius) var cornerRadius
    @Environment(\.theme) private var theme
    @Environment(\.isEnabled) private var isEnabled

    let id: ButtonIdentifier
    let configuration: ButtonStyleConfiguration
    let shape: (Self) -> S

    var body: some View {
        configuration.label
            .frame(maxWidth: .infinity, minHeight: minHeight)
            .padding(.horizontal)
            .foregroundColor(Color(
                isEnabled ? theme.backgroundColor : UIColor.black.alpha(0.2)
            ))
            .background(shape(self).fill(backgroundColor))
            .contentShape(shape(self))
            .scaleOpacityEffect(configuration.isPressed, options: .scale)
    }

    private var backgroundColor: Color {
        Color(isEnabled ?
            (configuration.isPressed ? theme.buttonPressedBackgroundColor(id) : theme.buttonBackgroundColor(id)) :
            theme.buttonDisabledBackgroundColor(id)
        )
    }
}
