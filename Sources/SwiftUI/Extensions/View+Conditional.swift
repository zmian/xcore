//
// Xcore
// Copyright © 2020 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

// MARK: - Unwrap

extension View {
    @ViewBuilder
    public func unwrap<Value, Content>(
        _ value: Value?,
        @ViewBuilder content: (Self, Value) -> Content
    ) -> some View where Content: View {
        if let value = value {
            content(self, value)
        } else {
            self
        }
    }
}

// MARK: - Apply

extension View {
    /// Returns `self` as a parameter to the given content block.
    @ViewBuilder
    public func apply<Content>(
        @ViewBuilder content: (Self) -> Content
    ) -> some View where Content: View {
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
    func applyIf<Modifier>(
        _ condition: Bool,
        @ViewBuilder modifier: () -> Modifier
    ) -> some View where Modifier: ViewModifier {
        if condition {
            self.modifier(modifier())
        } else {
            self
        }
    }

    /// Adds content if given condition is satisfied.
    ///
    /// - Parameters:
    ///   - condition: The condition that must be `true` in order to apply given
    ///     content.
    ///   - content: The content to add.
    @ViewBuilder
    public func applyIf<Content>(
        _ condition: Bool,
        @ViewBuilder content: (Self) -> Content
    ) -> some View where Content: View {
        if condition {
            content(self)
        } else {
            self
        }
    }

    /// Adds content if given condition is satisfied.
    ///
    /// - Parameters:
    ///   - condition: The binding that must be `true` in order to apply given
    ///     content.
    ///   - content: The content to add.
    @ViewBuilder
    public func applyIf<Content>(
        _ condition: Binding<Bool>,
        @ViewBuilder content: (Self) -> Content
    ) -> some View where Content: View {
        if condition.wrappedValue {
            content(self)
        } else {
            self
        }
    }
}
