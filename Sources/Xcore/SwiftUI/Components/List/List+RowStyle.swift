//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

extension View {
    public func listRowStyle(insets: EdgeInsets? = nil) -> some View {
        modifier(ListRowModifier())
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
    func body(content: Content) -> some View {
        InternalBody(content: content)
    }

    private struct InternalBody: View {
        @Environment(\.theme) private var theme
        @Environment(\.defaultMinListRowHeight) private var minHeight
        @Environment(\.customListRowInsets) private var rowInsets
        let content: Content

        var body: some View {
            content
                .padding(rowInsets)
                .frame(maxWidth: .infinity, minHeight: minHeight, alignment: .leading)
                .listRowInsets(.zero)
                .listRowBackground(Color.clear)
        }
    }
}
