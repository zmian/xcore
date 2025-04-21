//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

// MARK: - View Modifiers

extension View {
    /// Sets the tint for the story progress indicator.
    ///
    /// **Usage**
    ///
    /// ```swift
    /// StoryView(data: [Color.red, .white, .blue]) { color in
    ///     color
    /// }
    /// .storyProgressIndicatorTint(.indigo.gradient)
    /// ```
    ///
    /// - Parameter tint: A shape style that determines the tint of the progress
    ///   indicator.
    /// - Returns: A view modified with the custom story progress indicator tint.
    public func storyProgressIndicatorTint(_ tint: some ShapeStyle) -> some View {
        environment(\.storyProgressIndicatorTint, AnyShapeStyle(tint))
    }

    /// Sets the insets for the story progress indicator.
    ///
    /// **Usage**
    ///
    /// ```swift
    /// StoryView(data: [Color.red, .white, .blue]) { color in
    ///     color
    /// }
    /// .storyProgressIndicatorInsets(EdgeInsets(.horizontal, 16))
    /// ```
    ///
    /// - Parameter insets: An `EdgeInsets` value that defines the spacing around
    ///   the progress indicator.
    /// - Returns: A view modified with the custom story progress indicator insets.
    public func storyProgressIndicatorInsets(_ insets: EdgeInsets) -> some View {
        environment(\.storyProgressIndicatorInsets, insets)
    }
}

// MARK: - Environment

extension EnvironmentValues {
    /// A value that represents the tint style for the story progress indicator.
    ///
    /// The default value is `.tint`.
    @Entry var storyProgressIndicatorTint = AnyShapeStyle(.tint)

    /// A value that represents the insets for the story progress indicator.
    ///
    /// The default value is configured with horizontal spacing set to the system
    /// default spacing.
    @Entry var storyProgressIndicatorInsets = EdgeInsets(.horizontal, .defaultSpacing)
}
