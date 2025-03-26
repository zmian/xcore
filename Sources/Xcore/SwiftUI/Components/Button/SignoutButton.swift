//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

/// A button that displays sign out button and upon confirmation it invokes the
/// provided action.
public struct SignoutButton: View {
    private typealias L = Localized.Signout
    private let requiresConfirmation: Bool
    private let action: () -> Void

    /// Creates a `SignoutButton` button instance.
    ///
    /// - Parameters:
    ///   - requiresConfirmation: A Boolean value indicating whether to present a
    ///     confirmation dialog before executing the given action.
    ///   - action: The closure to execute when the sign-out is confirmed or
    ///     immediately triggered.
    public init(confirmation requiresConfirmation: Bool = true, action: @escaping () -> Void) {
        self.requiresConfirmation = requiresConfirmation
        self.action = action
    }

    public var body: some View {
        if requiresConfirmation {
            ConfirmationButton(
                L.title,
                popupTitle: L.ConfirmPopup.title,
                popupMessage: L.ConfirmPopup.message,
                popupConfirm: .yesOrNo,
                role: .destructive,
                action: action
            )
            .accessibilityIdentifier("signoutButton")
        } else {
            Button(L.title, role: .destructive, action: action)
                .accessibilityIdentifier("signoutButton")
        }
    }
}

// MARK: - Preview

#Preview {
    SignoutButton {
        print("Handle log out")
    }
}
