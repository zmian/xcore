//
// Xcore
// Copyright © 2020 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

extension View {
    /// Conditionally wraps `self` in a button that will perform the given `action`
    /// when `self` is triggered. If condition is false it returns the unmodified
    /// `self` without being wrapped in the button.
    ///
    /// - Parameters:
    ///   - condition: The condition that must be `true` in order to wrap `self` in
    ///     a button and perform the given action.
    ///   - action: The action to perform when the user triggers the button.
    public func onTap(
        if condition: Bool = true,
        scaleAnchor: UnitPoint = .center,
        action: @escaping () -> Void
    ) -> some View {
        onTap(
            if: condition,
            style: .scaleEffect(anchor: scaleAnchor),
            action: action
        )
    }

    /// Returns a version of `self` that will perform `action` when `self` is
    /// triggered.
    public func onRowTap(action: @escaping () -> Void) -> some View {
        onTap(style: .scaleEffect, action: action)
            .listRowStyle()
    }

    /// Conditionally wraps `self` in a button that will perform the given `action`
    /// when `self` is triggered. If condition is false it returns the unmodified
    /// `self` without being wrapped in the button.
    ///
    /// - Parameters:
    ///   - condition: The condition that must be `true` in order to wrap `self` in
    ///     a button and perform the given action.
    ///   - style: Sets the button style.
    ///   - action: The action to perform when the user triggers the button.
    public func onTap(
        if condition: Bool = true,
        style: some ButtonStyle,
        action: @escaping () -> Void
    ) -> some View {
        applyIf(condition) { label in
            Button(action: action) {
                label
            }
            .buttonStyle(style)
        }
    }
}
