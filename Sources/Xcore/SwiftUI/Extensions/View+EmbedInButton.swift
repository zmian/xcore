//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

extension View {
    /// Embed this view in button if action isn't `nil`.
    public func embedInButton(
        if action: (() -> Void)?,
        embeddedInList: Bool = true
    ) -> some View {
        modifier(EmbedInButtonViewModifier(
            action: action,
            embeddedInList: embeddedInList
        ))
    }
}

// MARK: - ViewModifier

private struct EmbedInButtonViewModifier: ViewModifier {
    @Environment(\.isLoading) private var isLoading
    let action: (() -> Void)?
    let embeddedInList: Bool

    func body(content: Content) -> some View {
        Group {
            if let action {
                Button(action: action) {
                    content
                }
                .disabled(isLoading)
            } else {
                content
            }
        }
        .applyIf(embeddedInList) {
            $0.listRowStyle()
        }
    }
}
