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

// MARK: - Default Style

struct DefaultXStackStyle: XStackStyle {
    @Environment(\.theme) private var theme
    var dim: XStackDimContent = .none
    var alignment: VerticalAlignment = .center
    var spacing: CGFloat? = .s5

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
        }
    }

    private var titleForegroundColor: Color? {
        dim == .title ? Color(theme.textSecondaryColor) : nil
    }

    private var valueForegroundColor: Color? {
        dim == .value ? Color(theme.textSecondaryColor) : nil
    }
}
