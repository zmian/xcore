//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

// MARK: - Progress Indicator Color

extension EnvironmentValues {
    private struct ColorKey: EnvironmentKey {
        static var defaultValue: Color?
    }

    var storyProgressIndicatorColor: Color? {
        get { self[ColorKey.self] }
        set { self[ColorKey.self] = newValue }
    }
}

// MARK: - Progress Indicator Insets

extension EnvironmentValues {
    private struct InsetsKey: EnvironmentKey {
        static var defaultValue: EdgeInsets?
    }

    var storyProgressIndicatorInsets: EdgeInsets? {
        get { self[InsetsKey.self] }
        set { self[InsetsKey.self] = newValue }
    }
}

// MARK: - View Helpers

extension View {
    public func storyProgressIndicatorColor(_ color: Color?) -> some View {
        environment(\.storyProgressIndicatorColor, color)
    }

    public func storyProgressIndicatorInsets(_ insets: EdgeInsets?) -> some View {
        environment(\.storyProgressIndicatorInsets, insets)
    }
}
