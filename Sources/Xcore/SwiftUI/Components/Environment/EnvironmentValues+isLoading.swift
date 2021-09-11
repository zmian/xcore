//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

extension EnvironmentValues {
    private struct XcoreIsLoadingKey: EnvironmentKey {
        static var defaultValue: Bool = false
    }

    /// A Boolean value that indicates whether the view associated with this
    /// environment is in loading state.
    ///
    /// The default value is `false`.
    public var isLoading: Bool {
        get { self[XcoreIsLoadingKey.self] }
        set { self[XcoreIsLoadingKey.self] = newValue }
    }
}

// MARK: - View Helpers

extension View {
    /// Adds a condition that controls whether this view is in loading state.
    /// - Parameter value: A Boolean value that determines whether this view is in
    ///   loading state.
    public func isLoading(_ loading: Bool) -> some View {
        environment(\.isLoading, loading)
    }
}
