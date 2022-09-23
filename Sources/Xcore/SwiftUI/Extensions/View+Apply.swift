//
// Xcore
// Copyright © 2020 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

// MARK: - Unwrap

extension View {
    @ViewBuilder
    public func unwrap<Value>(
        _ value: Value?,
        @ViewBuilder content: (Self, Value) -> some View
    ) -> some View {
        if let value {
            content(self, value)
        } else {
            self
        }
    }
}

// MARK: - Apply

extension View {
    /// Returns `self` as a parameter to the given content block.
    public func apply(@ViewBuilder content: (Self) -> some View) -> some View {
        content(self)
    }
}

// MARK: - Conditional Apply

extension View {
    /// Applies modifier if given condition is satisfied.
    ///
    /// - Parameters:
    ///   - condition: The condition that must be `true` in order to apply given
    ///     modifier.
    ///   - modifier: The modifier to apply.
    @ViewBuilder
    func applyIf(
        _ condition: Bool,
        @ViewBuilder modifier: () -> some ViewModifier
    ) -> some View {
        if condition {
            self.modifier(modifier())
        } else {
            self
        }
    }

    /// Applies the given transform if the given condition evaluates to `true`.
    ///
    /// - Parameters:
    ///   - condition: The condition to evaluate.
    ///   - transform: The transform to apply to the source `View`.
    /// - Returns: Either the original view or the transformed view if the condition
    ///   is `true`.
    @ViewBuilder
    public func applyIf(
        _ condition: Bool,
        @ViewBuilder transform: (Self) -> some View
    ) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }

    /// Applies the given transform if the given condition evaluates to `true`.
    ///
    /// - Parameters:
    ///   - condition: The condition to evaluate.
    ///   - transform: The transform to apply to the source `View`.
    /// - Returns: Either the original view or the transformed view if the condition
    ///   is `true`.
    @ViewBuilder
    public func applyIf(
        _ condition: Binding<Bool>,
        @ViewBuilder transform: (Self) -> some View
    ) -> some View {
        if condition.wrappedValue {
            transform(self)
        } else {
            self
        }
    }
}
