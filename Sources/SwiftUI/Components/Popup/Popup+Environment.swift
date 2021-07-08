//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

// MARK: - Environment Support

extension EnvironmentValues {
    // MARK: - TextAlignment

    private struct PopupTextAlignmentKey: EnvironmentKey {
        static var defaultValue: TextAlignment = .center
    }

    var popupTextAlignment: TextAlignment {
        get { self[PopupTextAlignmentKey.self] }
        set { self[PopupTextAlignmentKey.self] = newValue }
    }

    // MARK: - Alert Width

    private struct PopupAlertWidthKey: EnvironmentKey {
        static var defaultValue: CGFloat = 300
    }

    var popupAlertWidth: CGFloat {
        get { self[PopupAlertWidthKey.self] }
        set { self[PopupAlertWidthKey.self] = newValue }
    }

    // MARK: - Alert Corner Radius

    private struct PopupAlertCornerRadiusKey: EnvironmentKey {
        static var defaultValue: CGFloat = 16
    }

    var popupAlertCornerRadius: CGFloat {
        get { self[PopupAlertCornerRadiusKey.self] }
        set { self[PopupAlertCornerRadiusKey.self] = newValue }
    }
}

// MARK: - View Helpers

extension View {
    public func popupTextAlignment(_ alignment: TextAlignment) -> some View {
        environment(\.popupTextAlignment, alignment)
    }

    public func popupAlertWidth(_ value: CGFloat) -> some View {
        environment(\.popupAlertWidth, value)
    }

    public func popupAlertCornerRadius(_ value: CGFloat) -> some View {
        environment(\.popupAlertCornerRadius, value)
    }
}
