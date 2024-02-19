//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

// MARK: - Keys

extension EnvironmentValues {
    private enum PopupCornerRadiusKey: EnvironmentKey {
        static let defaultValue: CGFloat = 16
    }

    private enum PopupPreferredWidthKey: EnvironmentKey {
        static let defaultValue: CGFloat = AppConstants.popupPreferredWidth
    }

    private enum PopupTextAlignmentKey: EnvironmentKey {
        static let defaultValue: TextAlignment = .center
    }

    private enum PopupDismissActionKey: EnvironmentKey {
        static let defaultValue: PopupDismissAction? = nil
    }
}

// MARK: - Values

extension EnvironmentValues {
    var popupCornerRadius: CGFloat {
        get { self[PopupCornerRadiusKey.self] }
        set { self[PopupCornerRadiusKey.self] = newValue }
    }

    var popupPreferredWidth: CGFloat {
        get { self[PopupPreferredWidthKey.self] }
        set { self[PopupPreferredWidthKey.self] = newValue }
    }

    var popupTextAlignment: TextAlignment {
        get { self[PopupTextAlignmentKey.self] }
        set { self[PopupTextAlignmentKey.self] = newValue }
    }

    var popupDismissAction: PopupDismissAction? {
        get { self[PopupDismissActionKey.self] }
        set { self[PopupDismissActionKey.self] = newValue }
    }
}

// MARK: - View Helpers

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
