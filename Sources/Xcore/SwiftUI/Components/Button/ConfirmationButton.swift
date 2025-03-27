//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

extension ConfirmationButton {
    /// An enumeration representing the available confirmation button styles shown
    /// in the confirmation popup.
    public enum ConfirmLabel {
        /// A custom confirm button with a cancel and an action labeled with the
        /// provided string.
        ///
        /// Example: `.title("Delete")` will show "Cancel" and "Delete" buttons.
        case title(LocalizedStringKey)

        /// A preset confirmation option showing "Yes" and "No" buttons.
        case yesOrNo
    }
}

/// A button that displays confirmation before invoking the provided action.
///
/// **Usage**
///
/// ```swift
/// ConfirmationButton(
///     "Sign Out",
///     popupTitle: "Sign Out",
///     popupMessage: "Are you sure you would like to sign out?",
///     popupConfirm: .yesOrNo,
///     role: .destructive,
///     action: {
///         print("Handle sign out")
///     }
/// )
/// ```
public struct ConfirmationButton: View {
    @State private var isConfirming = false
    private let label: String
    private let popupTitle: String
    private let popupMessage: String
    private let popupConfirm: ConfirmLabel
    private let role: ButtonRole?
    private let action: () -> Void

    /// Creates a confirmation button that shows a popup before performing the
    /// action.
    ///
    /// This initializer displays a button labeled with the given string. When
    /// tapped, a popup appears asking the user to confirm the action before it is
    /// executed.
    ///
    /// - Parameters:
    ///   - label: The button label text.
    ///   - popupTitle: The title displayed in the confirmation popup.
    ///   - popupMessage: The message displayed in the confirmation popup.
    ///   - popupConfirm: The style of confirmation buttons shown in the popup.
    ///     layout using the button label as the confirm title.
    ///   - role: The role applied to the confirm button.
    ///   - action: The closure to execute when the user confirms the action.
    public init(
        _ label: String,
        popupTitle: String,
        popupMessage: String,
        popupConfirm: ConfirmLabel? = nil,
        role: ButtonRole? = nil,
        action: @escaping () -> Void
    ) {
        self.label = label
        self.popupTitle = popupTitle
        self.popupMessage = popupMessage
        self.popupConfirm = popupConfirm ?? .title(.init(label))
        self.role = role
        self.action = action
    }

    public var body: some View {
        Button(label, role: role) {
            isConfirming = true
        }
        .accessibilityIdentifier("\(label.snakecased())Button")
        .popup(
            popupTitle,
            message: popupMessage,
            isPresented: $isConfirming,
            footer: {
                HStack(spacing: .s2) {
                    actions(action)
                }
            }
        )
    }

    @ViewBuilder
    private func actions(_ action: @escaping () -> Void) -> some View {
        switch popupConfirm {
            case let .title(title):
                Button.cancel {
                    isConfirming = false
                }
                .buttonStyle(.secondary)

                Button(title, role: role) {
                    isConfirming = false
                    action()
                }
                .buttonStyle(.primary)
            case .yesOrNo:
                Button.no {
                    isConfirming = false
                }
                .buttonStyle(.secondary)

                Button.yes(role: role) {
                    isConfirming = false
                    action()
                }
                .buttonStyle(.primary)
        }
    }
}

// MARK: - Preview

#Preview {
    ConfirmationButton(
        "Sign Out",
        popupTitle: "Sign Out",
        popupMessage: "Are you sure you would like to sign out?",
        popupConfirm: .yesOrNo) {
            print("Handle sign out")
        }
}
