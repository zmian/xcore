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

            switch axis {
                case .horizontal:
                    HStack(spacing: .defaultSpacing) {
                        content
                            // We don't want buttons to have loading state as the entire container will be
                            // hidden.
                            .isLoading(false)
                    }
                    .hidden(isLoading)
                case .vertical:
                    VStack(spacing: .defaultSpacing) {
                        content
                            // We don't want buttons to have loading state as the entire container will be
                            // hidden.
                            .isLoading(false)
                    }
                    .hidden(isLoading)
            }
        }
        .animation(.default, value: isLoading)
    }
}
