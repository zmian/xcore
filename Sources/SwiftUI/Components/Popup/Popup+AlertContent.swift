//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

extension Popup {
    /// A representation of an alert presentation.
    struct AlertContent<A>: View where A: View {
        @Environment(\.theme) private var theme
        @Environment(\.popupAlertAttributes) private var attributes
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
            ZStack(alignment: .topTrailing) {
                VStack(spacing: .s4) {
                    VStack(alignment: alignment, spacing: .s2) {
                        title
                            .fontWeight(.medium)
                            .foregroundColor(theme.textColor)

                        if let message = message {
                            message
                                .foregroundColor(theme.textSecondaryColor)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .init(horizontal: alignment, vertical: .center))
                    .fixedSize(horizontal: false, vertical: true)
                    .multilineTextAlignment(attributes.textAlignment)

                    actions
                }
                .padding(.s4)
                .padding(.top, .s4)
                .frame(width: attributes.width)
                .background(Color(theme.backgroundColor))
                .cornerRadius(attributes.cornerRadius, style: .continuous)
                .floatingShadow()

                if dismissMethods.contains(.xmark) {
                    Button {
                        isPresented = false
                    } label: {
                        Image(system: .xMark)
                            .imageScale(.small)
                    }
                    .padding(.s4)
                }
            }
        }

        private var alignment: HorizontalAlignment {
            attributes.textAlignment.horizontal
        }
    }
}

// MARK: - Previews

struct PopupAlertContent_Previews: PreviewProvider {
    static var previews: some View {
        let L = Samples.Strings.deleteMessageAlert

        return Group {
            Popup.AlertContent(
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

            Popup.AlertContent(
                isPresented: .constant(false),
                title: Text(L.title),
                message: Text(L.message),
                dismissMethods: .xmark
            ) {
                EmptyView()
            }
        }
        .padding(.s6)
        .backgroundColor(.secondary)
        .previewLayout(.sizeThatFits)
    }
}
