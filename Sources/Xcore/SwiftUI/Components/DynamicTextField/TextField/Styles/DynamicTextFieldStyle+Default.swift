//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

/// The default dynamic text field style.
///
/// This style is provided as the default appearance for dynamic text fields in
/// the application. It adapts its layout based on the current text field
/// configuration, such as inline or floating placeholder placement.
struct DefaultDynamicTextFieldStyle: DynamicTextFieldStyle {
    func makeBody(configuration: Configuration) -> some View {
        InternalBody(configuration: configuration)
    }
}

// MARK: - Internal

extension DefaultDynamicTextFieldStyle {
    private struct InternalBody: View {
        @Environment(\.isEnabled) private var isEnabled
        @Environment(\.isLoading) private var isLoading
        @Environment(\.textFieldAttributes) private var attributes
        let configuration: Configuration

        private var text: String {
            configuration.text
        }

        var body: some View {
            HStack(spacing: .s2) {
                switch attributes.placeholderPlacement {
                    case .inline:
                        inlineContent
                    case .floating:
                        floatingContent
                }

                ProgressView()
                    .hidden(!isLoading, remove: true)
            }
            .foregroundStyle {
                isEnabled ? nil : attributes.disabledColor
            }
        }

        private var inlineContent: some View {
            ZStack(alignment: .leading) {
                placeholderView
                    .hidden(!text.isEmpty)

                configuration.textField
            }
        }

        private var floatingContent: some View {
            FloatingLabelTextFieldLayout(isFloating: !text.isEmpty, labelScale: 0.8) {
                placeholderView
                    .scaleEffect(text.isEmpty ? 1.0 : 0.8, anchor: .topLeading)
                    .animation(.smooth, value: text.isEmpty)
                configuration.textField
            }
        }

        private var placeholderView: some View {
            configuration.label
                .foregroundStyle {
                    if text.isEmpty {
                        return attributes.placeholderColor
                    }

                    return configuration.isValid
                        ? attributes.placeholderSuccessColor
                        : attributes.placeholderErrorColor
                }
        }
    }
}

// MARK: - Dot Syntax Support

extension DynamicTextFieldStyle where Self == DefaultDynamicTextFieldStyle {
    /// The default dynamic text field style.
    ///
    /// This style is provided as the default appearance for dynamic text fields in
    /// the application. It adapts its layout based on the current text field
    /// configuration, such as inline or floating placeholder placement.
    static var `default`: Self { .init() }
}

// MARK: - FloatingLabelTextFieldLayout

/// A custom layout for a floating label text field.
///
/// This layout arranges exactly two subviews—a label and a text field—so that
/// they share the same leading alignment, ensuring smooth animations. When the
/// text field is empty (non-floating), the label is centered vertically within
/// the text field as a placeholder. When the text field is active or contains
/// text (floating), the label shifts upward with a scale transformation, and
/// the overall height increases to display both the label and the text field.
///
/// **Usage**
///
/// ```swift
/// FloatingLabelTextFieldLayout(
///     isFloating: !text.isEmpty,
///     spacing: 2,
///     labelScale: 0.8
/// ) {
///     // Label
///     Text("Username")
///         .scaleEffect(text.isEmpty ? 1.0 : 0.8, anchor: .topLeading)
///         .animation(.smooth, value: text.isEmpty)
///
///     // Text field
///     TextField("", text: $text)
///         .textFieldStyle(.roundedBorder)
/// }
/// ```
private struct FloatingLabelTextFieldLayout: Layout {
    /// A Boolean property indicating whether the label should float above
    /// the text field.
    private let isFloating: Bool
    /// The vertical spacing between the floating label and the text field.
    private let spacing: CGFloat
    /// The scale factor applied to the label when in the floating state.
    private let labelScale: CGFloat

    /// Creates a new `FloatingLabelTextFieldLayout`.
    ///
    /// - Parameters:
    ///   - isFloating: A Boolean value indicating whether the label should float.
    ///   - spacing: The vertical spacing between the label and text field when
    ///     floating.
    ///   - labelScale: The scale factor for the label when floating.
    init(isFloating: Bool, spacing: CGFloat = 2, labelScale: CGFloat) {
        self.isFloating = isFloating
        self.spacing = spacing
        self.labelScale = labelScale
    }

    /// Calculates the size that best fits the combined label and text field.
    ///
    /// In floating mode, the overall height is the sum of the scaled label height,
    /// the spacing, and the text field's height. In non-floating mode, the height
    /// is determined by the text field.
    ///
    /// - Parameters:
    ///   - proposal: The size proposed by the parent.
    ///   - subviews: The two subviews: label (index 0) and text field (index 1).
    ///   - cache: A cache for computed values (unused).
    /// - Returns: The size that best fits the combined content.
    func sizeThatFits(
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout Void
    ) -> CGSize {
        guard subviews.count == 2 else {
            return .zero
        }

        let labelSize = subviews[0].sizeThatFits(proposal)
        let textFieldSize = subviews[1].sizeThatFits(proposal)

        return CGSize(
            width: max(textFieldSize.width, labelSize.width),
            height: labelSize.height * labelScale + spacing + textFieldSize.height
        )
    }

    /// Positions the label and text field within the given bounds.
    ///
    /// In floating mode, the label is placed at the top and the text field is
    /// positioned below the label with the given spacing.
    /// In non-floating mode, both subviews are aligned to the same leading edge,
    /// with the label vertically centered within the text field's area.
    ///
    /// - Parameters:
    ///   - bounds: The rectangle in which to arrange the subviews.
    ///   - proposal: The size proposed by the parent.
    ///   - subviews: The two subviews: label (index 0) and text field (index 1).
    ///   - cache: A cache for computed values (unused).
    func placeSubviews(
        in bounds: CGRect,
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout Void
    ) {
        guard subviews.count == 2 else {
            return
        }

        let labelSize = subviews[0].sizeThatFits(proposal)
        let textFieldSize = subviews[1].sizeThatFits(proposal)

        let labelOrigin: CGPoint
        let textFieldOrigin: CGPoint

        if isFloating {
            // In floating mode, position the label at the top-left.
            labelOrigin = CGPoint(
                x: bounds.minX,
                y: bounds.minY
            )

            // Place the text field below the label with the specified spacing.
            textFieldOrigin = CGPoint(
                x: bounds.minX,
                y: bounds.minY + labelSize.height * labelScale + spacing
            )
        } else {
            // Center the label vertically within the text field.
            labelOrigin = CGPoint(
                x: bounds.minX,
                y: bounds.midY - labelSize.height / 2
            )

            // In non-floating mode, place the text field to fill the bounds.
            textFieldOrigin = CGPoint(
                x: bounds.minX,
                y: bounds.midY - textFieldSize.height / 2
            )
        }

        subviews[0].place(
            at: labelOrigin,
            proposal: ProposedViewSize(labelSize)
        )

        subviews[1].place(
            at: textFieldOrigin,
            proposal: ProposedViewSize(textFieldSize)
        )
    }
}
