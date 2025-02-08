//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

// MARK: - List Row Insets Environment

extension EnvironmentValues {
    @Entry var customListRowInsets: EdgeInsets = .listRow
}

// MARK: - View Helpers

extension View {
    /// Applies an inset to the rows in a list.
    public func customListRowInsets(_ insets: EdgeInsets) -> some View {
        environment(\.customListRowInsets, insets)
    }

    /// Applies an inset to the rows in a list.
    public func customListRowInsets(_ edges: HorizontalEdge.Set, _ length: CGFloat) -> some View {
        customListRowInsets(.init(.init(edges), length))
    }
}
