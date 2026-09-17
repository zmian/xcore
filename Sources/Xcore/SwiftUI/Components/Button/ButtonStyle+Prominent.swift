//
// Xcore
// Copyright © 2020 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

/// A button style that applies theme filled or outlined border based on the
/// button's context.
///
/// The explicit `prominence` selects the fill treatment.
/// `defaultMinButtonHeight` defines the regular control height; other control
/// sizes scale that height.
public struct ProminentButtonStyle<S: InsettableShape>: ButtonStyle {
    private let id: ButtonIdentifier
    private let prominence: ButtonProminence
    private let shape: S

    public init(
        id: ButtonIdentifier,
        prominence: ButtonProminence,
        shape: S
    ) {
        self.id = id
        self.prominence = prominence
        self.shape = shape
    }

    public func makeBody(configuration: Configuration) -> some View {
        InternalBody(
            id: id,
            prominence: prominence,
            configuration: configuration,
            shape: shape
        )
    }
}

// MARK: - Internal

extension ProminentButtonStyle {
    private struct InternalBody: View {
        @Environment(\.defaultMinButtonHeight) private var minHeight
        @Environment(\.defaultOutlineButtonBorderColor) private var _borderColor
        @Environment(\.defaultButtonFont) private var font
        @Environment(\.theme) private var theme
        @Environment(\.controlSize) private var controlSize
        @Environment(\.oneDisplayPixel) private var oneDisplayPixel
        @Environment(\.isEnabled) private var isEnabled
        @Environment(\.isLoading) private var isLoading
        let id: ButtonIdentifier
        let prominence: ButtonProminence
        let configuration: Configuration
        let shape: S

        var body: some View {
            configuration.label
                .frame(maxWidth: .infinity, minHeight: controlHeight)
                .padding(.horizontal)
                .foregroundStyle(foregroundColor)
                .background(background)
                .contentShape(shape)
                .scaleOpacityEffect(configuration.isPressed)
                .overlayLoader(isLoading, tint: foregroundContentColor)
                .allowsHitTesting(!isLoading)
                .unwrap(font) { view, font in
                    view.font(font)
                }
        }

        @ViewBuilder
        private var background: some View {
            switch prominence {
                case .fill:
                    shape.fill(backgroundColor)
                case .outline:
                    shape.strokeBorder(borderColor, lineWidth: oneDisplayPixel)
            }
        }

        private var controlHeight: CGFloat {
            switch controlSize {
                case .mini: minHeight * 0.6
                case .small: minHeight * 0.8
                case .regular: minHeight
                case .large: minHeight * 1.2
                case .extraLarge: minHeight * 1.4
                @unknown default: minHeight
            }
        }

        private var foregroundColor: Color {
            isLoading ? .clear : foregroundContentColor
        }

        private var foregroundContentColor: Color {
            theme.buttonTextColor(id, buttonState, .primary, configuration.role)
        }

        private var backgroundColor: Color {
            theme.buttonBackgroundColor(id, buttonState, .primary, configuration.role)
        }

        private var borderColor: Color {
            if isEnabled, let color = _borderColor {
                return color
            }

            return foregroundColor
        }

        private var buttonState: ButtonState {
            !isEnabled ? .disabled : configuration.isPressed ? .pressed : .normal
        }
    }
}

// MARK: - Dot Syntax Support

extension ButtonStyle {
    public static func fill<S: InsettableShape>(shape: S) -> Self where Self == ProminentButtonStyle<S> {
        .init(
            id: .fill,
            prominence: .fill,
            shape: shape
        )
    }

    public static func outline<S: InsettableShape>(shape: S) -> Self where Self == ProminentButtonStyle<S> {
        .init(
            id: .outline,
            prominence: .outline,
            shape: shape
        )
    }
}

extension ButtonStyle where Self == ProminentButtonStyle<RoundedRectangle> {
    public static var rectFill: Self {
        .fill(shape: .rect(cornerRadius: AppConstants.cornerRadius))
    }

    public static var rectOutline: Self {
        .outline(shape: .rect(cornerRadius: AppConstants.cornerRadius))
    }
}

extension ButtonStyle where Self == ProminentButtonStyle<Capsule> {
    public static var capsuleFill: Self {
        .fill(shape: .capsule)
    }

    public static var capsuleOutline: Self {
        .outline(shape: .capsule)
    }
}

extension ButtonStyle where Self == ProminentButtonStyle<Capsule> {
    static var primary: Self {
        capsuleFill
    }

    static var secondary: Self {
        capsuleOutline
    }
}
