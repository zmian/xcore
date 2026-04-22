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
    ///     Text("Learn more at [apple.com](https://www.apple.com)")
    /// }
    /// .openURLInApp()
    /// ```
    public func openURLInApp() -> some View {
        modifier(OpenURLInAppViewModifier())
    }
}

private struct OpenURLInAppViewModifier: ViewModifier {
    @Dependency(\.openURL) private var openURL

    func body(content: Content) -> some View {
        switch AppInfo.executionTarget {
            case .app:
                content
                    .environment(\.openURL, .init { url in
                        openURL(url)
                        return .handled
                    })
            case .widget, .appExtension:
                content
        }
    }
}

// MARK: - Preview

#Preview {
    List {
        Text("Learn more at [apple.com](https://www.apple.com)")
    }
    .openURLInApp()
}
