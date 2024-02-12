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
    @Environment(\.popupDismissAction) private var dismiss
    private let content: () -> Content

    public init(@ViewBuilder content: @escaping () -> Content) {
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
            .background(theme.backgroundColor)
            .cornerRadius(cornerRadius, style: .continuous)
            .floatingShadow()

            // Add dismiss button if the environment dismiss action is set.
            if let dismiss {
                Button {
                    dismiss()
                } label: {
                    Image(system: .xMark)
                        .imageScale(.small)
                }
                .padding(.defaultSpacing)
            }
        }
    }
}

// MARK: - Preview

#Preview {
    Group {
        let L = Samples.Strings.deleteMessageAlert

        PopupAlert {
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

        PopupAlert {
            Text(L.title)
            Text(L.message)
        }
    }
    .padding(.defaultSpacing)
    .background(.secondary.opacity(0.15))
    .previewLayout(.sizeThatFits)
}
