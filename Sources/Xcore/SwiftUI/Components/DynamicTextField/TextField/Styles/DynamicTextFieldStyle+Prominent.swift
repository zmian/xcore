//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

/// A dynamic text field style that adds a prominent, adaptive border or fill
/// effect based on validation and placeholder behavior.
///
/// This style displays a text field with a custom shape and a visual treatment
/// determined by the provided prominence. When the prominence is set to `.fill`,
/// the background is filled with the theme’s secondary background color. When set
/// to `.outline`, an outline is drawn around the text field, optionally using a
/// validation color.
///
/// The style is generic over a shape type (conforming to InsettableShape) that
/// defines the text field’s border. It provides a unified interface to control
/// the appearance of the text field in various states, reducing the need for
/// multiple state variables in your view models.
///
/// **Usage**
///
/// ```swift
/// // Example: Using a prominent dynamic text field style with a rounded rectangle
/// // and an outline that automatically applies validation colors.
/// DynamicTextField(
///    value: $text,
///    configuration: .default
///  )
///  .dynamicTextFieldStyle(
///    .prominent(.outline(.automatic), shape: .rect(cornerRadius: 8))
///  )
/// ```
public struct ProminentDynamicTextFieldStyle<S: InsettableShape>: DynamicTextFieldStyle {
    /// An enumeration representing the visual prominence of the text field.
    public enum Prominence: Sendable, Hashable {
        /// Uses a filled background for the text field.
        case fill

        /// Uses an outline border around the text field.
        ///
        /// The associated value controls how the border color is determined:
        /// - `.automatic`: The validation color is applied only when the
        ///   placeholder is not floating.
        /// - `.enable`: Always use the validation color for the border when
        ///   appropriate.
        /// - `.disable`: Do not apply any validation color.
        case outline(OutlineValidationColor)

        /// A convenience accessor to create an outline with automatic validation.
        public static var outline: Self {
            outline(.automatic)
        }

        /// An enumeration representing how the validation color is applied to an
        /// outline border.
        public enum OutlineValidationColor: Sendable, Hashable {
            /// Automatically use the validation color based on the placeholder
            /// behavior. When the placeholder is floating, no border color is applied.
            ///
            /// If you set the `placeholderBehavior` attribute to `.floating`, the color
            /// won't be applied to the border; otherwise, the validation color is used on
            /// the border.
            case automatic

            /// Always enable the validation color on the border.
            case enable

            /// Always disable the validation color on the border.
            case disable
        }
    }

    /// The shape used for clipping and drawing the text field border.
    private let shape: S
    /// The desired prominence style (fill or outline).
    private let prominence: Prominence
    /// Optional custom padding to apply around the text field.
    private let padding: EdgeInsets?

    /// Creates a new prominent dynamic text field style.
    ///
    /// - Parameters:
    ///   - prominence: The desired prominence style for the text field.
    ///   - shape: The shape used for clipping and border rendering.
    ///   - padding: Optional custom padding. If not provided, default values
    ///     based on placeholder behavior are used.
    public init(
        _ prominence: Prominence,
        shape: S,
        padding: EdgeInsets? = nil
    ) {
        self.shape = shape
        self.prominence = prominence
        self.padding = padding
    }

    public func makeBody(configuration: Configuration) -> some View {
        InternalBody(
            configuration: configuration,
            shape: shape,
            prominence: prominence,
            padding: padding
        )
    }
}

// MARK: - Internal

extension ProminentDynamicTextFieldStyle {
    private struct InternalBody: View {
        @Environment(\.textFieldAttributes) private var attributes
        @Environment(\.theme) private var theme
        let configuration: Configuration
        let shape: S
        let prominence: Prominence
        let padding: EdgeInsets?

        var body: some View {
            DynamicTextField.default(configuration)
                .padding(finalPadding)
                .background(prominence == .fill ? theme.backgroundSecondaryColor : .clear)
                .clipShape(shape)
                .contentShape(shape)
                .apply {
                    if case .outline = prominence {
                        let color = outlineBorderColor
                        $0.border(shape, lineWidth: color == nil ? 0.5 : 1, color: color)
                    } else {
                        $0
                    }
                }
        }

        private var finalPadding: EdgeInsets {
            if let padding {
                return padding
            } else {
                var padding: EdgeInsets = .zero
                padding.vertical = attributes.placeholderBehavior == .floating ? .s2 : .s4
                padding.horizontal = S.self == Capsule.self ? .s4 : .s3
                return padding
            }
        }

        private var outlineBorderColor: Color? {
            guard case let .outline(validationColor) = prominence else {
                return nil
            }

            var color: Color? {
                if configuration.text.isEmpty {
                    return nil
                }

                return configuration.isValid ? nil : attributes.errorColor
            }

            switch validationColor {
                case .automatic:
                    return attributes.placeholderBehavior == .floating ? nil : color
                case .enable:
                    return color
                case .disable:
                    return nil
            }
        }
    }
}

// MARK: - Dot Syntax Support

extension DynamicTextFieldStyle where Self == ProminentDynamicTextFieldStyle<RoundedRectangle> {
    /// A prominent dynamic text field style with a rounded rectangle.
    public static var prominent: Self { prominent() }

    /// A prominent dynamic text field style with a rounded rectangle.
    ///
    /// - Parameters:
    ///   - prominence: The desired prominence.
    ///   - cornerRadius: The corner radius for the rounded rectangle.
    ///   - padding: Optional custom padding. If omitted, default padding is used.
    /// - Returns: A configured prominent dynamic text field style.
    public static func prominent(
        _ prominence: Self.Prominence = .fill,
        cornerRadius: CGFloat = AppConstants.tileCornerRadius,
        padding: EdgeInsets? = nil
    ) -> Self {
        prominent(
            prominence,
            shape: .rect(cornerRadius: cornerRadius),
            padding: padding
        )
    }
}

extension DynamicTextFieldStyle {
    /// A prominent dynamic text field style with a custom shape.
    ///
    /// - Parameters:
    ///   - prominence: The desired prominence.
    ///   - shape: The shape to use for clipping and border rendering.
    ///   - padding: Optional custom padding. If omitted, default padding is used.
    /// - Returns: A prominent dynamic text field style configured with the specified
    ///   parameters.
    public static func prominent<S: InsettableShape>(
        _ prominence: Self.Prominence = .fill,
        shape: S,
        padding: EdgeInsets? = nil
    ) -> Self where Self == ProminentDynamicTextFieldStyle<S> {
        .init(prominence, shape: shape, padding: padding)
    }
}
