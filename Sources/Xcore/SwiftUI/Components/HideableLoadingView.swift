//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

/// A view that hides content when loading and shows progress view.
///
/// It's useful when you want to hide the content and display spinner while some
/// async task is taking place.
public struct HideableLoadingView<Content: View>: View {
    @Environment(\.isLoading) private var isLoading
    private let axis: Axis
    private let content: Content

    public init(axis: Axis = .vertical, @ViewBuilder content: () -> Content) {
        self.axis = axis
        self.content = content()
    }

    public var body: some View {
        ZStack {
            ProgressView()
                .hidden(!isLoading)

            let layout = axis == .horizontal
                ? AnyLayout(HStackLayout(spacing: .defaultSpacing))
                : AnyLayout(VStackLayout(spacing: .defaultSpacing))

            layout {
                content
                    // We don't want buttons to have loading state as the entire container will be
                    // hidden.
                    .isLoading(false)
            }
            .hidden(isLoading)
        }
        .animation(.default, value: isLoading)
    }
}

// MARK: - Preview

#Preview {
    @Previewable @State var isLoading = false
    let L = Samples.Strings.deleteMessageAlert

    PopupAlertContent {
        Text(L.title)
            .font(.headline)
        Text(L.message)
            .foregroundStyle(.secondary)

        Spacer(height: .defaultSpacing)

        HideableLoadingView {
            HStack {
                Button.cancel {
                    print("Cancel Tapped")
                }
                .buttonStyle(.secondary)

                Button.delete {
                    print("Delete Tapped")

                    isLoading = true

                    withDelay(.seconds(5)) { @MainActor in
                        isLoading = false
                    }
                }
                .buttonStyle(.primary)
            }
        }
        .isLoading(isLoading)
    }
}
