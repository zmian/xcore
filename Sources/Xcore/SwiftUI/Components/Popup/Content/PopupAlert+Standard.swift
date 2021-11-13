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
    @Binding private var isPresented: Bool
    private let dismissMethods: Popup.DismissMethods
    private let title: Text
    private let message: Text?
    private let actions: A

    init(
        isPresented: Binding<Bool>,
        title: Text,
        message: Text?,
        dismissMethods: Popup.DismissMethods,
        actions: () -> A
    ) {
        self._isPresented = isPresented
        self.title = title
        self.message = message
        self.dismissMethods = dismissMethods
        self.actions = actions()
    }

    var body: some View {
        PopupAlert(isPresented: $isPresented, dismissMethods: dismissMethods) {
            VStack(spacing: .spacing) {
                VStack(alignment: textAlignment.horizontal, spacing: .s2) {
                    title
                        .fontWeight(.medium)
                        .foregroundColor(theme.textColor)

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
                isPresented: .constant(false),
                title: Text(L.title),
                message: Text(L.message),
                dismissMethods: .xmark
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
                isPresented: .constant(false),
                title: Text(L.title),
                message: Text(L.message),
                dismissMethods: .xmark
            ) {
                EmptyView()
            }
        }
        .padding(.spacing)
        .frame(max: .infinity)
        .backgroundColor(.secondary.opacity(0.15))
        .previewLayout(.sizeThatFits)
    }
}
