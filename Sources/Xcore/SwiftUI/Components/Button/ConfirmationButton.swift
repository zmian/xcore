//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

extension ConfirmationButton {
    public enum Confirm {
        case title(String)
        case yesOrNo
    }
}

/// A button that displays confirmation before invoking the provided action.
public struct ConfirmationButton: View {
    @State private var isConfirming = false
    private let label: String
    private let popupTitle: String
    private let popupMessage: String
    private let popupConfirm: Confirm
    private let action: () -> Void

    public init(
        _ label: String,
        popupTitle: String,
        popupMessage: String,
        popupConfirm: Confirm? = nil,
        action: @escaping () -> Void
    ) {
        self.label = label
        self.popupTitle = popupTitle
        self.popupMessage = popupMessage
        self.popupConfirm = popupConfirm ?? .title(label)
        self.action = action
    }

    public var body: some View {
        Button(label) {
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

                Button(title) {
                    isConfirming = false
                    action()
                }
                .accessibilityIdentifier("\(title.snakecased())Button")
                .buttonStyle(.primary)
            case .yesOrNo:
                Button.no {
                    isConfirming = false
                }
                .buttonStyle(.secondary)

                Button.yes {
                    isConfirming = false
                    action()
                }
                .buttonStyle(.primary)
        }
    }
}
