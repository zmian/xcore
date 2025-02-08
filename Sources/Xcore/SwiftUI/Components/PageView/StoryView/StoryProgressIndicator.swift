//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

/// A top progress indicator for story views that displays the remaining
/// duration of the current media content.
///
/// This view displays a horizontal progress bar using a line style. It accepts
/// a progress value between `0.0` (no progress) and `1.0` (complete) and uses
/// an environment value to tint the bar. The progress bar is animated linearly
/// as the progress value changes.
///
/// **Usage**
///
/// ```swift
/// // Display a progress indicator at 50% progress with the default tint.
/// StoryProgressIndicator(value: 0.5)
///
/// // Display a progress indicator with a custom tint color.
/// StoryProgressIndicator(value: 0.8)
///     .storyProgressIndicatorTint(.indigo.gradient)
/// ```
public struct StoryProgressIndicator: View {
    @Environment(\.storyProgressIndicatorTint) private var tint
    /// The current progress value, ranging from `0.0` to `1.0`.
    private let value: CGFloat

    /// Creates a new instance of `StoryProgressIndicator`.
    ///
    /// - Parameter value: A value between `0.0` and `1.0` indicating the completion
    ///   fraction of the progress.
    public init(value: CGFloat) {
        self.value = value
    }

    public var body: some View {
        ProgressView(value: value)
            .progressViewStyle(.line(height: 3))
            .tint(tint)
    }
}

// MARK: - Preview

#Preview {
    Group {
        StoryProgressIndicator(value: 0)
        StoryProgressIndicator(value: 1.0)
        StoryProgressIndicator(value: 0.8)
            .storyProgressIndicatorTint(.indigo.gradient)
    }
    .padding(20)
    .background(.black)
}
