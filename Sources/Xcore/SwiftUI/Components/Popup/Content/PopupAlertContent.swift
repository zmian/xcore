//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

/// A representation of an alert presentation.
public struct PopupAlertContent<Content: View>: View {
    @Environment(\.theme) private var theme
    @Environment(\.colorScheme) private var colorScheme
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
            .background(colorScheme == .dark ? theme.groupedBackgroundTertiaryColor : theme.backgroundColor)
            .cornerRadius(cornerRadius, style: .continuous)
            .floatingShadow()

            // Add dismiss button if the environment dismiss action is set.
            if let dismiss {
                Button.dismiss {
                    dismiss()
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

        PopupAlertContent {
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

        PopupAlertContent {
            Text(L.title)
            Text(L.message)
        }

        PopupAlertContent {
            Text(L.title)
                .font(.headline)
            Text(L.message)
                .foregroundStyle(.secondary)

            Spacer(height: .defaultSpacing)

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
    .background(.secondary.opacity(0.15))
}
