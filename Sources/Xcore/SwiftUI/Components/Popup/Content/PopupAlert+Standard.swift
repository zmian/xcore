//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

/// A standard representation of an alert presentation with title, message and
/// actions.
public struct StandardPopupAlert<Header, Footer>: View where Header: View, Footer: View {
    @Environment(\.theme) private var theme
    @Environment(\.popupTextAlignment) private var textAlignment
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
        PopupAlert {
            VStack(spacing: .defaultSpacing) {
                if Header.self != Never.self {
                    header()
                }

                VStack(alignment: textAlignment.horizontal, spacing: .s2) {
                    title
                        .fontWeight(.semibold)
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
        }
    }
}

// MARK: - Inits

extension StandardPopupAlert where Header == Never {
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

        StandardPopupAlert(L.title, message: L.message) {
            HStack {
                Button("Cancel") {
                    print("Cancel Tapped")
                }
                .buttonStyle(.outline)

                Button("Delete") {
                    print("Delete Tapped")
                }
                .buttonStyle(.fill)
            }
        }

        StandardPopupAlert(L.title, message: L.message) {
            EmptyView()
        }
    }
    .padding(.defaultSpacing)
    .frame(max: .infinity)
    .background(.secondary.opacity(0.15))
    .previewLayout(.sizeThatFits)
}
