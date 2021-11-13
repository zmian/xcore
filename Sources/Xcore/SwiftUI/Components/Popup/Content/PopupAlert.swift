//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

/// A representation of an alert presentation.
public struct PopupAlert<Content>: View where Content: View {
    @Environment(\.theme) private var theme
    @Environment(\.popupPreferredWidth) private var preferredWidth
    @Environment(\.popupCornerRadius) private var cornerRadius
    @Environment(\.popupTextAlignment) private var textAlignment
    @Binding private var isPresented: Bool
    private let dismissMethods: Popup.DismissMethods
    private let content: () -> Content

    public init(
        isPresented: Binding<Bool>,
        dismissMethods: Popup.DismissMethods,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self._isPresented = isPresented
        self.dismissMethods = dismissMethods
        self.content = content
    }

    public var body: some View {
        ZStack(alignment: .topTrailing) {
            VStack(spacing: 0) {
                content()
                    .multilineTextAlignment(textAlignment)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(.defaultSpacing)
            .padding(.top, .defaultSpacing)
            .frame(width: preferredWidth)
            .background(Color(theme.backgroundColor))
            .cornerRadius(cornerRadius, style: .continuous)
            .floatingShadow()

            if dismissMethods.contains(.xmark) {
                Button {
                    isPresented = false
                } label: {
                    Image(system: .xMark)
                        .imageScale(.small)
                }
                .padding(.defaultSpacing)
            }
        }
    }
}

// MARK: - Previews

struct PopupAlert_Previews: PreviewProvider {
    private static let L = Samples.Strings.deleteMessageAlert

    static var previews: some View {
        Group {
            PopupAlert(
                isPresented: .constant(false),
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

            PopupAlert(
                isPresented: .constant(false),
                dismissMethods: .xmark
            ) {
                Text(L.title)
                Text(L.message)
            }
        }
        .padding(.defaultSpacing)
        .backgroundColor(.secondary.opacity(0.15))
        .previewLayout(.sizeThatFits)
    }
}
