//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

extension View {
    /// Adds a condition that controls whether this view is in loading state.
    ///
    /// - Parameter value: A Boolean value indicating whether this view is in
    ///   loading state.
    public func isLoading(_ loading: Bool) -> some View {
        environment(\.isLoading, loading)
    }
}

// MARK: - EnvironmentValue

extension EnvironmentValues {
    /// A Boolean property indicating whether the view associated with this
    /// environment is in loading state.
    @Entry public var isLoading: Bool = false
}
