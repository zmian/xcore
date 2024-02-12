//
// Xcore
// Copyright © 2024 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

extension View {
    /// Replaces `self` with content unavailable message when `DataStatus` value
    /// collection is empty.
    ///
    /// **Usage**
    ///
    /// ```swift
    /// struct ContentView: View {
    ///     let landmarks: DataStatus<[String]>
    ///
    ///     var body: some View {
    ///         List(landmarks) { landmark in
    ///             Text(landmark)
    ///         }
    ///         .contentUnavailable(landmarks, message: "No Landmarks")
    ///     }
    /// }
    /// ```
    ///
    /// - Parameters:
    ///   - data: A `DataStatus` where the value is collection indicating whether to
    ///     present the content unavailable view when the value is empty.
    ///   - message: A string to display when content is unavailable.
    @ViewBuilder
    public func contentUnavailable(_ data: DataStatus<some Collection>, message: String) -> some View {
        contentUnavailable(data.value?.isEmpty == true, message: message)
    }

    /// Replaces `self` with content unavailable message when `unavailable` is
    /// `true`.
    ///
    /// **Usage**
    ///
    /// ```swift
    /// struct ContentView: View {
    ///     let landmarks: [String]
    ///
    ///     var body: some View {
    ///         List(landmarks) { landmark in
    ///             Text(landmark)
    ///         }
    ///         .contentUnavailable(landmarks.isEmpty, message: "No Landmarks")
    ///     }
    /// }
    /// ```
    ///
    /// - Parameters:
    ///   - unavailable: A Boolean value indicating whether to present content
    ///     unavailable view.
    ///   - message: A string to display when content is unavailable.
    @ViewBuilder
    public func contentUnavailable(_ unavailable: Bool, message: String) -> some View {
        contentUnavailable(unavailable) {
            CustomContentUnavailableView(message: message)
        }
    }

    /// Replaces `self` with content unavailable view when `unavailable` is `true`.
    ///
    /// **Usage**
    ///
    /// ```swift
    /// struct ContentView: View {
    ///     let landmarks: [String]
    ///
    ///     var body: some View {
    ///         List(landmarks) { landmark in
    ///             Text(landmark)
    ///         }
    ///         .contentUnavailable(landmarks.isEmpty) {
    ///             Text("No Landmarks")
    ///         }
    ///     }
    /// }
    /// ```
    ///
    /// - Parameters:
    ///   - unavailable: A Boolean value indicating whether to present content
    ///     unavailable view.
    ///   - content: A closure returning the view when content is unavailable.
    @ViewBuilder
    public func contentUnavailable(_ unavailable: Bool, @ViewBuilder content: () -> some View) -> some View {
        ZStack {
            content()
                .hidden(!unavailable)

            self
                .hidden(unavailable)
        }
        .animation(.default, value: unavailable)
    }
}

// MARK: - Helpers

private struct CustomContentUnavailableView: View {
    @Environment(\.theme) private var theme
    let message: String

    var body: some View {
        if #available(iOS 17.0, *) {
            ContentUnavailableView {
                Text(message)
                    .font(.app(.body))
                    .foregroundStyle(theme.textSecondaryColor)
                    .multilineTextAlignment(.center)
            }
        } else {
            Text(message)
                .foregroundStyle(theme.textSecondaryColor)
                .multilineTextAlignment(.center)
                .padding(.defaultSpacing)
        }
    }
}
