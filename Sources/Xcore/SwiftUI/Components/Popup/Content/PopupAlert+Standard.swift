//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

/// A standard representation of an alert presentation with title, message and
/// actions.
struct StandardPopupAlert<A>: View where A: View {
    @Environment(\.theme) private var theme
    @Environment(\.popupTextAlignment) private var textAlignment
    private let title: Text
    private let message: Text?
    private let actions: A

    init(
        title: Text,
        message: Text?,
        actions: () -> A
    ) {
        self.title = title
        self.message = message
        self.actions = actions()
    }

    var body: some View {
        PopupAlert {
            VStack(spacing: .defaultSpacing) {
                VStack(alignment: textAlignment.horizontal, spacing: .s2) {
                    title
                        .fontWeight(.semibold)
                        .foregroundColor(theme.textColor)
                        .accessibilityAddTraits(.isHeader)

                    if let message = message {
                        message
                            .foregroundColor(theme.textSecondaryColor)
                    }
                }
                .frame(maxWidth: .infinity, alignment: textAlignment.alignment)

                actions
            }
        }
    }
}

// MARK: - Previews

struct StandardPopupAlert_Previews: PreviewProvider {
    private static let L = Samples.Strings.deleteMessageAlert

    static var previews: some View {
        Group {
            StandardPopupAlert(
                title: Text(L.title),
                message: Text(L.message)
            ) {
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

            StandardPopupAlert(
                title: Text(L.title),
                message: Text(L.message)
            ) {
                EmptyView()
            }
        }
        .padding(.defaultSpacing)
        .frame(max: .infinity)
        .backgroundColor(.secondary.opacity(0.15))
        .previewLayout(.sizeThatFits)
    }
}
