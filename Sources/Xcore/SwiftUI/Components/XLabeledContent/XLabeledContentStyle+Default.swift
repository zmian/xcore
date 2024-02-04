//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

/// An enumeration that defines dimming behavior for the label and content of
/// the labeled content.
public enum XLabeledContentDimContent {
    /// No changes to the label nor content text foreground style.
    case none

    /// Changes label's foreground style to secondary.
    case label

    /// Changes content's value foreground style to secondary.
    case value
}

/// An option set that defines content traits of the stack.
public struct XLabeledContentContentTraits: OptionSet {
    public let rawValue: Int

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

    /// Style the stack with header traits (e.g., accessibility and font weight).
    public static let header = Self(rawValue: 1 << 0)

    /// Style the stack with list row traits.
    public static let row = Self(rawValue: 1 << 1)

    /// Style the stack with list row and header traits.
    public static let rowHeader: Self = [.row, .header]
}

// MARK: - Default Style

struct DefaultXLabeledContentStyle: XLabeledContentStyle {
    @Environment(\.theme) private var theme
    var traits: XLabeledContentContentTraits = .none
    var dim: XLabeledContentDimContent = .none
    var alignment: VerticalAlignment = .center
    var spacing: CGFloat? = .interItemHSpacing

    func makeBody(configuration: Self.Configuration) -> some View {
        HStack(alignment: alignment, spacing: configuration.isSingleChild ? 0 : spacing) {
            configuration.label
                .unwrap(titleForegroundColor) {
                    $0.foregroundStyle($1)
                }

            Spacer(minLength: 0)

            configuration.content
                .multilineTextAlignment(.trailing)
                .unwrap(valueForegroundColor) {
                    $0.foregroundStyle($1)
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

    private var titleForegroundColor: Color? {
        dim == .label ? theme.textSecondaryColor : nil
    }

    private var valueForegroundColor: Color? {
        dim == .value ? theme.textSecondaryColor : nil
    }
}
