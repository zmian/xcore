//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

extension View {
    /// Layers a loader in front of this view when the given data status is
    /// `.loading`.
    public func overlayLoader(
        _ data: DataStatus<some Hashable, Error>,
        alignment: Alignment = .center
    ) -> some View {
        overlayLoader(data.isLoading, alignment: alignment)
    }

    /// Layers a loader in front of this view when the given flag is `true`.
    public func overlayLoader(
        _ show: Bool,
        tint: Color? = nil,
        alignment: Alignment = .center
    ) -> some View {
        overlay(
            ProgressView()
                .unwrap(tint) { content, tint in
                    content.tint(tint)
                }
                .hidden(!show),
            alignment: alignment
        )
    }

    /// Sets the transparency of this view to `0` when the given flag is `true` and
    /// layers a loader in front of this view.
    public func maskWithLoader(
        _ mask: Bool,
        tint: Color? = nil,
        alignment: Alignment = .center
    ) -> some View {
        opacity(mask ? 0 : 1)
            .overlayLoader(mask, tint: tint, alignment: alignment)
    }
}

// MARK: - Preview

#Preview {
    Label("Swift", systemImage: .swift)
        .labelStyle(.settingsIcon(tint: .orange))
        .font(.largeTitle)
        .overlayLoader(true)
        .background(.secondary)

    Label("Swift", systemImage: .swift)
        .labelStyle(.settingsIcon(tint: .orange))
        .font(.largeTitle)
        .maskWithLoader(true)
        .background(.secondary)
}
