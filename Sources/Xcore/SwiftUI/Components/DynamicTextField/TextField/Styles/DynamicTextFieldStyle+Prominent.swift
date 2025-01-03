//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

public struct ProminentDynamicTextFieldStyle<S: InsettableShape>: DynamicTextFieldStyle {
    public enum Prominence: Sendable, Hashable {
        case fill
        case outline(OutlineValidationColor)

        public static var outline: Self {
            outline(.automatic)
        }

        public enum OutlineValidationColor: Sendable, Hashable {
            /// If you set the `placeholderBehavior` attribute to `.floating`, the color
            /// won't be applied to the border; otherwise, the validation color is used on
            /// the border.
            case automatic
            /// Enable validation color border.
            case enable
            /// Disable validation color border.
            case disable
        }
    }

    private let shape: S
    private let prominence: Prominence
    private let padding: EdgeInsets?

    nonisolated public init(
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
    nonisolated public static var prominent: Self {
        prominent()
    }

    nonisolated public static func prominent(
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
    nonisolated public static func prominent<S: InsettableShape>(
        _ prominence: Self.Prominence = .fill,
        shape: S,
        padding: EdgeInsets? = nil
    ) -> Self where Self == ProminentDynamicTextFieldStyle<S> {
        .init(prominence, shape: shape, padding: padding)
    }
}
