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
        @Environment(\.popupTextAlignment) private var textAlignment
        @Environment(\.popupAlertWidth) private var width
        @Environment(\.popupAlertCornerRadius) private var cornerRadius

        @Binding private var isPresented: Bool
        private let dismissMethods: Popup.DismissMethods
        private let title: String
        private let message: String?
        private let actions: A

        init(
            isPresented: Binding<Bool>,
            title: String,
            message: String,
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
                    VStack(alignment: textAlignment.horizontal, spacing: .s2) {
                        Text(title)
                            .fontWeight(.medium)
                            .foregroundColor(theme.textColor)

                        if let message = message {
                            Text(message)
                                .foregroundColor(theme.textSecondaryColor)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .init(horizontal: textAlignment.horizontal, vertical: .center))
                    .fixedSize(horizontal: false, vertical: true)
                    .multilineTextAlignment(textAlignment)

                    actions
                }
                .padding(.s4)
                .padding(.top, .s4)
                .frame(width: width)
                .background(Color(theme.backgroundColor))
                .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
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
    }
}

// MARK: - Previews

struct PopupAlertContent_Previews: PreviewProvider {
    static var previews: some View {
        let L = SampleStrings.deleteMessageAlert

        return Group {
            Popup.AlertContent(
                isPresented: .constant(false),
                title: L.title,
                message: L.message,
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
                title: L.title,
                message: L.message,
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
