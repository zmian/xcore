//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

// MARK: - View Helpers

extension View {
    public func storyProgressIndicatorColor(_ color: Color) -> some View {
        environment(\.storyProgressIndicatorColor, color)
    }

    public func storyProgressIndicatorInsets(_ insets: EdgeInsets) -> some View {
        environment(\.storyProgressIndicatorInsets, insets)
    }
}

extension EnvironmentValues {
    @Entry var storyProgressIndicatorColor: Color = .accentColor
    @Entry var storyProgressIndicatorInsets = EdgeInsets(.horizontal, .defaultSpacing)
}
