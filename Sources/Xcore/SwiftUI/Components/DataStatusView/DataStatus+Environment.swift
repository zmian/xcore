//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

extension EnvironmentValues {
    /// A Boolean value that determines whether the loading state of a `DataStatus`
    /// is visible.
    ///
    /// When this value is `true`, views can display the loading state associated
    /// with `DataStatus`.
    @Entry public var dataStatusLoadingStateEnabled = true
}

// MARK: - View Modifiers

extension View {
    /// Sets whether the loading state of a `DataStatus` should be visible within
    /// this view.
    ///
    /// Use this modifier to enable or disable the display of the loading state for
    /// `DataStatus` on a per-view basis. When set to `true`, loading indicators
    /// associated with data fetching operations will be shown; otherwise, they will
    /// be hidden.
    ///
    /// - Parameter enable: A Boolean value that determines whether the loading
    ///   state is visible.
    /// - Returns: A view modified to reflect the specified loading state
    ///   visibility.
    public func dataStatusLoadingStateEnabled(_ enable: Bool) -> some View {
        environment(\.dataStatusLoadingStateEnabled, enable)
    }
}
