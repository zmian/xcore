//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

// MARK: - Keys

extension EnvironmentValues {
    private struct PopupCornerRadiusKey: EnvironmentKey {
        static var defaultValue: CGFloat = 16
    }

    private struct PopupPreferredWidthKey: EnvironmentKey {
        static var defaultValue: CGFloat = AppConstants.popupPreferredWidth
    }

    private struct PopupTextAlignmentKey: EnvironmentKey {
        static var defaultValue: TextAlignment = .center
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
}
