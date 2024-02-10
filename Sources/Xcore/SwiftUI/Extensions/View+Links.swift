//
// Xcore
// Copyright © 2024 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

extension View {
    /// Observes the `openURL` environment and handles incoming links in-app instead
    /// of using the external web browser.
    ///
    /// Usage:
    ///
    /// ```swift
    /// List {
    ///     Text("Lear more at [apple.com](https://www.apple.com)")
    /// }
    /// .openUrlInApp()
    /// ```
    public func openUrlInApp() -> some View {
        modifier(OpenURLInAppViewModifier())
    }
}

private struct OpenURLInAppViewModifier: ViewModifier {
    @Dependency(\.openUrl) private var openUrl

    func body(content: Content) -> some View {
        if AppInfo.isWidgetExtension || AppInfo.isAppExtension {
            content
        } else {
            content
                .environment(\.openURL, .init { url in
                    openUrl(url)
                    return .handled
                })
        }
    }
}
