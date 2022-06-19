//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

/// An enumeration that defines dimming behavior of title and value of the
/// stack.
public enum XStackDimContent {
    /// No changes to the title nor value text foreground color.
    case none

    /// Changes title's foreground color to secondary.
    case title

    /// Changes value's foreground color to secondary.
    case value
}

/// An option set that defines content traits of the stack.
public struct XStackContentTraits: OptionSet {
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

struct DefaultXStackStyle: XStackStyle {
    @Environment(\.theme) private var theme
    var traits: XStackContentTraits = .none
    var dim: XStackDimContent = .none
    var alignment: VerticalAlignment = .center
    var spacing: CGFloat? = .interItemHSpacing

    func makeBody(configuration: Self.Configuration) -> some View {
        HStack(alignment: alignment, spacing: configuration.isSingleChild ? 0 : spacing) {
            configuration.title
                .unwrap(titleForegroundColor) {
                    $0.foregroundColor($1)
                }

            Spacer(minLength: 0)

            configuration.value
                .multilineTextAlignment(.trailing)
                .unwrap(valueForegroundColor) {
                    $0.foregroundColor($1)
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
        dim == .title ? Color(theme.textSecondaryColor) : nil
    }

    private var valueForegroundColor: Color? {
        dim == .value ? Color(theme.textSecondaryColor) : nil
    }
}
