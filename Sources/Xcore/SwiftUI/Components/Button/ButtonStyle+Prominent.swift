//
// Xcore
// Copyright © 2020 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

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

    public func makeBody(configuration: Self.Configuration) -> some View {
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
        @Environment(\.isEnabled) private var isEnabled
        @Environment(\.isLoading) private var isLoading

        let id: ButtonIdentifier
        let prominence: ButtonProminence
        let configuration: ButtonStyleConfiguration
        let shape: S

        var body: some View {
            configuration.label
                .frame(maxWidth: .infinity, minHeight: minHeight)
                .padding(.horizontal)
                .foregroundColor(foregroundColor)
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
                    shape
                        .fill(backgroundColor)
                case .outline:
                    shape
                        .strokeBorder(borderColor, lineWidth: .onePixel)
            }
        }

        private var foregroundColor: Color {
            isLoading ? .clear : foregroundContentColor
        }

        private var foregroundContentColor: Color {
            isEnabled ?
                theme.buttonTextColor(id, configuration.isPressed ? .pressed : .normal) :
                theme.buttonTextColor(id, .disabled)
        }

        private var backgroundColor: Color {
            isEnabled ?
                theme.buttonBackgroundColor(id, configuration.isPressed ? .pressed : .normal) :
                theme.buttonBackgroundColor(id, .disabled)
        }

        private var borderColor: Color {
            if isEnabled, let color = _borderColor {
                return color
            }

            return foregroundColor
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
    public static func fill(cornerRadius: CGFloat) -> Self {
        .fill(shape: RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
    }

    public static var fill: Self {
        .fill(cornerRadius: AppConstants.cornerRadius)
    }

    public static func outline(cornerRadius: CGFloat) -> Self {
        .outline(shape: RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
    }

    public static var outline: Self {
        .outline(cornerRadius: AppConstants.cornerRadius)
    }
}

extension ButtonStyle where Self == ProminentButtonStyle<Capsule> {
    public static var capsule: Self {
        .fill(shape: Capsule())
    }

    public static var capsuleOutline: Self {
        .outline(shape: Capsule())
    }

    static var primary: Self { capsule }
    static var secondary: Self { capsuleOutline }
}
