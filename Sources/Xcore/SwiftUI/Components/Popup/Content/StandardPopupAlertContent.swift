//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

/// A standard representation of an alert presentation with title, message and
/// actions.
public struct StandardPopupAlertContent<Header: View, Footer: View>: View {
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
        PopupAlertContent {
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

extension StandardPopupAlertContent where Header == Never {
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

        StandardPopupAlertContent(L.title, message: L.message) {
            HStack {
                Button.cancel {
                    print("Cancel Tapped")
                }
                .buttonStyle(.secondary)

                Button.delete {
                    print("Delete Tapped")
                }
                .buttonStyle(.primary)
            }
        }

        StandardPopupAlertContent(L.title, message: L.message) {
            EmptyView()
        }

        StandardPopupAlertContent(Text(L.title), message: Text(L.message)) {
            Image(system: .trashCircleFill)
                .foregroundStyle(.red)
                .font(.largeTitle)
        } footer: {
            HStack {
                Button.cancel {
                    print("Cancel Tapped")
                }
                .buttonStyle(.secondary)

                Button.delete {
                    print("Delete Tapped")
                }
                .buttonStyle(.primary)
            }
        }
    }
    .padding(.defaultSpacing)
    .frame(max: .infinity)
    .background(.secondary.opacity(0.15))
}
