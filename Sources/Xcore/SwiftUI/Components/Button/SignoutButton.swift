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
                action: action
            )
        } else {
            Button(action: action) {
                Text(L.title)
            }
            .accessibilityIdentifier("signoutButton")
        }
    }
}
