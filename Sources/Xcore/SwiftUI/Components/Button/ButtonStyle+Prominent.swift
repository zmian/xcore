//
// Xcore
// Copyright © 2020 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

/// A configurable, theme-aware button style that renders a filled or outlined
/// appearance based on the specified prominence and environment.
///
/// `ProminentButtonStyle` derives its colors from the current theme and button
/// role, and scales its height using the `defaultMinButtonHeight` and
/// `controlSize` environment values.
///
/// Set ``prominence`` to choose between a filled background (``ButtonProminence/fill``)
/// and an outlined border (``ButtonProminence/outline``). Provide any
/// `InsettableShape` to control the button's silhouette (for example,
/// `RoundedRectangle` or `Capsule`).
///
/// The style adapts to the button's state and environment:
/// - Disabled state adjusts colors.
/// - Pressed state applies a subtle scale and opacity effect.
/// - Loading state (via `Environment(\.isLoading)`) displays a loader and disables
///   interactions while preserving layout.
///
/// - Parameter S: The shape used to render the button's background or border.
///
/// - Note: You can use the provided convenience styles like
///   ``ButtonStyle/rectFill`` and ``ButtonStyle/capsuleOutline`` for common
///   configurations.
///
/// - SeeAlso: ``ButtonStyle/fill(shape:)``, ``ButtonStyle/outline(shape:)``,
///   ``ButtonStyle/rectFill``, ``ButtonStyle/rectOutline``,
///   ``ButtonStyle/capsuleFill``, ``ButtonStyle/capsuleOutline``
///
/// ### Example
/// ```swift
/// Button("Continue") { }
///     .buttonStyle(.rectFill)
/// ```
public struct ProminentButtonStyle<S: InsettableShape>: ButtonStyle {
    /// Internal identifier used to select theme colors and defaults for this style.
    private let id: ButtonIdentifier
    /// Determines whether the style renders as a filled or outlined button.
    private let prominence: ButtonProminence
    /// The shape used for the button's fill or stroked border.
    private let shape: S

    /// Create a prominent button style.
    ///
    /// - Parameters:
    ///   - id: A semantic identifier the theme uses to derive colors and behavior
    ///     (for example, `.fill` or `.outline`).
    ///   - prominence: The visual treatment to apply. Use `.fill` for a solid
    ///     background or `.outline` for a stroked border.
    ///   - shape: The shape used to render the button background or border.
    public init(
        id: ButtonIdentifier,
        prominence: ButtonProminence,
        shape: S
    ) {
        self.id = id
        self.prominence = prominence
        self.shape = shape
    }

    /// Make the styled button body for the given configuration.
    ///
    /// The view expands to the available width, applies theme-derived foreground
    /// and background (or border) based on `prominence`, and adapts its height to
    /// the current `controlSize`.
    ///
    /// - Parameter configuration: The current button configuration provided by SwiftUI.
    /// - Returns: A view that renders the button's label with the prominent style.
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
    /// Return a filled prominent button style using the given shape.
    ///
    /// The style uses a solid background color derived from the current theme and
    /// environment.
    ///
    /// - Parameter shape: The shape used to render the button background.
    /// - Returns: A filled prominent button style for the specified shape.
    ///
    /// ### Example
    /// ```swift
    /// Button("Continue") { }
    ///     .buttonStyle(.fill(shape: .capsule))
    /// ```
    public static func fill<S: InsettableShape>(shape: S) -> Self where Self == ProminentButtonStyle<S> {
        .init(
            id: .fill,
            prominence: .fill,
            shape: shape
        )
    }

    /// Return an outlined prominent button style using the given shape.
    ///
    /// The style uses a stroked border whose color is derived from the current
    /// theme and environment.
    ///
    /// - Parameter shape: The shape used to render the button's stroked border.
    /// - Returns: An outlined prominent button style for the specified shape.
    ///
    /// ### Example
    /// ```swift
    /// Button("Learn More") { }
    ///     .buttonStyle(.outline(shape: .rect(cornerRadius: 12)))
    /// ```
    public static func outline<S: InsettableShape>(shape: S) -> Self where Self == ProminentButtonStyle<S> {
        .init(
            id: .outline,
            prominence: .outline,
            shape: shape
        )
    }
}

extension ButtonStyle where Self == ProminentButtonStyle<RoundedRectangle> {
    /// Return a filled prominent style with a rounded rectangle shape.
    ///
    /// Uses the app's standard corner radius from ``AppConstants/cornerRadius``.
    ///
    /// - Returns: A rounded-rectangle filled prominent button style.
    public static var rectFill: Self {
        .fill(shape: .rect(cornerRadius: AppConstants.cornerRadius))
    }

    /// Return an outlined prominent style with a rounded rectangle shape.
    ///
    /// Uses the app's standard corner radius from ``AppConstants/cornerRadius``.
    ///
    /// - Returns: A rounded-rectangle outlined prominent button style.
    public static var rectOutline: Self {
        .outline(shape: .rect(cornerRadius: AppConstants.cornerRadius))
    }
}

extension ButtonStyle where Self == ProminentButtonStyle<Capsule> {
    /// Return a filled prominent style with a capsule shape.
    ///
    /// - Returns: A capsule-shaped filled prominent button style.
    public static var capsuleFill: Self {
        .fill(shape: .capsule)
    }

    /// Return an outlined prominent style with a capsule shape.
    ///
    /// - Returns: A capsule-shaped outlined prominent button style.
    public static var capsuleOutline: Self {
        .outline(shape: .capsule)
    }
}

extension ButtonStyle where Self == ProminentButtonStyle<Capsule> {
    /// The default prominent style for primary actions. Alias for ``ButtonStyle/capsuleFill``.
    public static var primary: Self {
        capsuleFill
    }

    /// The default prominent style for secondary actions. Alias for ``ButtonStyle/capsuleOutline``.
    public static var secondary: Self {
        capsuleOutline
    }
}
