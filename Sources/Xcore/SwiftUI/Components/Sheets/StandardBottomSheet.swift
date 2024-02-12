//
// Xcore
// Copyright © 2024 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

/// A standard representation of a bottom sheet presentation with title, message
/// and actions.
public struct StandardBottomSheet<Header, Footer>: View where Header: View, Footer: View {
    @Environment(\.theme) private var theme
    @Environment(\.multilineTextAlignment) private var multilineTextAlignment
    @Environment(\.horizontalSizeClass) private var sizeClass
    private let title: Text
    private let message: Text?
    private let header: () -> Header
    private let footer: () -> Footer

    public init(
        _ title: Text,
        message: Text? = nil,
        @ViewBuilder header: @escaping () -> Header,
        @ViewBuilder footer: @escaping () -> Footer
    ) {
        self.title = title
        self.message = message
        self.header = header
        self.footer = footer
    }

    public var body: some View {
        VStack(spacing: .defaultSpacing) {
            if Header.self != Never.self {
                header()
            }

            VStack(alignment: textAlignment.horizontal, spacing: .s2) {
                title
                    .font(.app(isPopup ? .body : .title2, weight: .medium))
                    .foregroundStyle(theme.textColor)
                    .accessibilityAddTraits(.isHeader)

                if let message {
                    message
                        .foregroundStyle(theme.textSecondaryColor)
                }
            }
            .frame(maxWidth: .infinity, alignment: textAlignment.alignment)

            if Footer.self != Never.self {
                footer()
            }
        }
        .multilineTextAlignment(textAlignment)
        .presentationDetents(.contentHeight)
    }

    private var textAlignment: TextAlignment {
        isPopup ? .center : multilineTextAlignment
    }

    /// On iPad, the bottom sheet is displayed as a popup.
    private var isPopup: Bool {
        sizeClass == .regular
    }
}

// MARK: - Inits

extension StandardBottomSheet where Header == Never {
    public init(
        _ title: Text,
        message: Text? = nil,
        @ViewBuilder footer: @escaping () -> Footer
    ) {
        self.init(
            title,
            message: message,
            header: { fatalError() },
            footer: footer
        )
    }

    public init(
        _ title: String,
        message: String? = nil,
        @ViewBuilder footer: @escaping () -> Footer
    ) {
        self.init(
            Text(title),
            message: message.map(Text.init),
            footer: footer
        )
    }
}

// MARK: - Preview

#Preview {
    Group {
        let L = Samples.Strings.deleteMessageAlert

        StandardBottomSheet(L.title, message: L.message) {
            HStack {
                Button("Cancel") {
                    print("Cancel Tapped")
                }
                .buttonStyle(.secondary)

                Button("Delete") {
                    print("Delete Tapped")
                }
                .buttonStyle(.primary)
            }
        }

        StandardBottomSheet(L.title, message: L.message) {
            EmptyView()
        }
    }
    .padding(.defaultSpacing)
    .frame(max: .infinity)
    .background(.secondary.opacity(0.15))
    .previewLayout(.sizeThatFits)
}
