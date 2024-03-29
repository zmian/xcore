//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

extension View {
    public func listRowStyle() -> some View {
        modifier(ListRowModifier())
    }

    public func listRowStyle(insets: EdgeInsets? = nil, separator separatorStyle: ListRowSeparatorStyle) -> some View {
        self
            .listRowStyle()
            .listRowSeparatorStyle(separatorStyle)
            .unwrap(insets) { content, insets in
                content
                    .customListRowInsets(insets)
            }
    }
}

// MARK: - ListRowModifier

/// A structure to modify the row to add row insets and custom separator with
/// full control over the separator insets as well.
private struct ListRowModifier: ViewModifier {
    @Environment(\.theme) private var theme
    @Environment(\.defaultMinListRowHeight) private var minHeight
    @Environment(\.customListRowInsets) private var rowInsets
    @Environment(\.listRowSeparatorStyle) private var separatorStyle

    func body(content: Content) -> some View {
        content
            .padding(rowInsets)
            .frame(maxWidth: .infinity, minHeight: minHeight, alignment: .leading)
            .listRowInsets(.zero)
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)
            .overlay(alignment: .bottom) {
                if separatorStyle != .hidden {
                    Separator()
                        .padding(separatorStyle.insets)
                }
            }
            .contentShape(.rect)
    }
}
