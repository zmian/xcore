//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

extension CustomLabeledContentStyle {
    /// An enumeration that defines dimming behavior for the label and content of
    /// the labeled content.
    public enum Dim: Sendable, Hashable {
        /// No changes to the label nor content text foreground style.
        case none

        /// Changes label's foreground style to secondary.
        case label

        /// Changes content's value foreground style to secondary.
        case value
    }

    /// An option set that defines content traits of the labeled content.
    public struct Traits: OptionSet, Sendable {
        public let rawValue: Int

        public init(rawValue: Int) {
            self.rawValue = rawValue
        }

        /// Style the labeled content with header traits (e.g., accessibility and font
        /// weight).
        public static let header = Self(rawValue: 1 << 0)

        /// Style the labeled content with list row traits.
        public static let row = Self(rawValue: 1 << 1)

        /// Style the labeled content with list row and header traits.
        public static let rowHeader: Self = [.row, .header]
    }
}

// MARK: - Custom Style

public struct CustomLabeledContentStyle: LabeledContentStyle {
    @Environment(\.theme) private var theme
    var traits: Traits = .none
    var dim: Dim = .none
    var alignment: VerticalAlignment = .center
    var spacing: CGFloat? = .interItemHSpacing

    public func makeBody(configuration: Configuration) -> some View {
        HStack(alignment: alignment, spacing: spacing) {
            configuration.label
                .foregroundStyle {
                    dim == .label ? theme.textSecondaryColor : nil
                }

            Spacer(minLength: 0)

            configuration.content
                .multilineTextAlignment(.trailing)
                .foregroundStyle {
                    dim == .value ? theme.textSecondaryColor : nil
                }
                .applyIf(traits.contains(.header)) {
                    $0.font(.app(.body))
                }
        }
        .applyIf(traits.contains(.row)) {
            $0.listRowStyle()
        }
        .applyIf(traits.contains(.header)) {
            $0.accessibilityAddTraits(.isHeader)
                .font(.app(.headline))
        }
    }
}

// MARK: - View Helper

extension View {
    /// Sets the style for `LabeledContent` within this view to a style with a
    /// custom appearance and standard interaction behavior.
    public func labeledContentStyle(
        _ traits: CustomLabeledContentStyle.Traits = .none,
        dim: CustomLabeledContentStyle.Dim = .none,
        alignment: VerticalAlignment = .center,
        spacing: CGFloat? = .interItemHSpacing,
        separator separatorStyle: ListRowSeparatorStyle? = nil
    ) -> some View {
        labeledContentStyle(CustomLabeledContentStyle(
            traits: traits,
            dim: dim,
            alignment: alignment,
            spacing: spacing
        ))
        .unwrap(separatorStyle) {
            $0.listRowSeparatorStyle($1)
        }
    }
}
