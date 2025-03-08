//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

// MARK: - Values

extension EnvironmentValues {
    @Entry var popupCornerRadius: CGFloat = 16
    @Entry var popupTextAlignment: TextAlignment = .center
    @Entry var popupDismissAction: PopupDismissAction?
    @Entry var popupPreferredWidth = AppConstants.popupPreferredWidth
}

// MARK: - View Modifiers

extension View {
    /// Clips popups within the environment to its bounding frame, with the
    /// specified corner radius.
    public func popupCornerRadius(_ cornerRadius: CGFloat) -> some View {
        environment(\.popupCornerRadius, cornerRadius)
    }

    /// Sets popups width within the environment to the specified value.
    public func popupPreferredWidth(_ width: CGFloat) -> some View {
        environment(\.popupPreferredWidth, width)
    }

    /// Sets the alignment of popups text within the environment to the specified
    /// value.
    public func popupTextAlignment(_ textAlignment: TextAlignment) -> some View {
        environment(\.popupTextAlignment, textAlignment)
    }

    /// Sets the dismiss action of popups within the environment to the specified
    /// value.
    func popupDismissAction(_ action: PopupDismissAction?) -> some View {
        environment(\.popupDismissAction, action)
    }
}

/// Provides functionality for dismissing a popup.
struct PopupDismissAction {
    private let dismiss: () -> Void

    init(dismiss: @escaping () -> Void) {
        self.dismiss = dismiss
    }

    func callAsFunction() {
        dismiss()
    }
}
