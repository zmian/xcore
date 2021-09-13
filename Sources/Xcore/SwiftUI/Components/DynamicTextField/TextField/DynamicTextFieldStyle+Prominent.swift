//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

public struct ProminentDynamicTextFieldStyle<S: InsettableShape>: DynamicTextFieldStyle {
    public enum Prominence: Equatable {
        case fill
        case outline(OutlineValidationColor)

        public static var outline: Self {
            outline(.automatic)
        }

        public enum OutlineValidationColor {
            /// If `disableFloatingPlaceholder` attributes is set to `true` then validation
            /// color is applied to the border; otherwise, ignored.
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

    public init(
        _ prominence: Prominence,
        shape: S,
        padding: EdgeInsets? = nil
    ) {
        self.shape = shape
        self.prominence = prominence
        self.padding = padding
    }

    public func makeBody(configuration: Self.Configuration) -> some View {
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
        let configuration: DynamicTextFieldStyleConfiguration
        let shape: S
        let prominence: Prominence
        let padding: EdgeInsets?

        var body: some View {
            configuration.label
                .padding(finalPadding)
                .applyIf(prominence == .fill) {
                    $0.backgroundColor(theme.backgroundSecondaryColor)
                }
                .clipShape(shape)
                .contentShape(shape)
                .apply {
                    if case .outline = prominence {
                        let color = outlineBorderColor
                        $0.border(shape, width: color == nil ? 0.5 : 1, color: color)
                    } else {
                        $0
                    }
                }
        }

        private var finalPadding: EdgeInsets {
            if let padding = padding {
                return padding
            } else {
                var padding: EdgeInsets = .zero

                if attributes.disableFloatingPlaceholder {
                    padding.vertical = .s4
                } else {
                    padding.vertical = .s2
                }

                if S.self == Capsule.self {
                    padding.horizontal = .s4
                } else {
                    padding.horizontal = .s3
                }

                return padding
            }
        }

        private var outlineBorderColor: Color? {
            guard case let .outline(validationColor) = prominence else {
                return nil
            }

            var color: Color? {
                configuration.isValid ? nil : attributes.errorColor
            }

            switch validationColor {
                case .automatic:
                    return attributes.disableFloatingPlaceholder ? color : nil
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
    public static var prominent: Self {
        prominent()
    }

    public static func prominent(
        _ prominence: Self.Prominence = .fill,
        cornerRadius: CGFloat = AppConstants.tileCornerRadius,
        padding: EdgeInsets? = nil
    ) -> Self {
        prominent(
            prominence,
            shape: RoundedRectangle(cornerRadius: cornerRadius, style: .continuous),
            padding: padding
        )
    }
}

extension DynamicTextFieldStyle {
    public static func prominent<S: InsettableShape>(
        _ prominence: Self.Prominence = .fill,
        shape: S,
        padding: EdgeInsets? = nil
    ) -> Self where Self == ProminentDynamicTextFieldStyle<S> {
        .init(prominence, shape: shape, padding: padding)
    }
}
