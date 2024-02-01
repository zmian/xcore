//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

// MARK: - List Row Insets Environment

extension EnvironmentValues {
    private struct CustomListRowInsetsKey: EnvironmentKey {
        static var defaultValue: EdgeInsets = .listRow
    }

    var customListRowInsets: EdgeInsets {
        get { self[CustomListRowInsetsKey.self] }
        set { self[CustomListRowInsetsKey.self] = newValue }
    }
}

// MARK: - View Helpers

extension View {
    /// Applies an inset to the rows in a list.
    public func customListRowInsets(_ insets: EdgeInsets) -> some View {
        environment(\.customListRowInsets, insets)
    }

    /// Applies an inset to the rows in a list.
    public func customListRowInsets(_ edges: Edge.Set, _ length: CGFloat) -> some View {
        customListRowInsets(.init(edges, length))
    }
}
