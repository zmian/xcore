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
    @ViewBuilder
    public func apply<Content>(
        @ViewBuilder content: (Self) -> Content
    ) -> some View where Content: View {
        content(self)
    }
}

// MARK: - Conditional Apply

extension View {
    /// Applies modifier when given condition is satisfied.
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

    /// Adds content when given condition is satisfied.
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

    /// Adds content when given condition is satisfied.
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
