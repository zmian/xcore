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
        _ content: (Self, Value) -> Content
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
        @ViewBuilder _ content: (Self) -> Content
    ) -> some View where Content: View {
        content(self)
    }
}

// MARK: - Condition

extension View {
    /// Applies modifier when given condition is satisfied.
    @ViewBuilder
    func when<Content>(
        _ condition: @autoclosure () -> Bool,
        _ modifier: @autoclosure () -> Content
    ) -> some View where Content: ViewModifier {
        if condition() {
            self.modifier(modifier())
        } else {
            self
        }
    }

    /// Applies modifier when given condition is satisfied.
    @ViewBuilder
    func when<Content>(
        _ condition: @autoclosure () -> Bool,
        @ViewBuilder _ modifier: () -> Content
    ) -> some View where Content: ViewModifier {
        if condition() {
            self.modifier(modifier())
        } else {
            self
        }
    }

    /// Add content when given condition is satisfied.
    @ViewBuilder
    func when<Content>(
        _ condition: @autoclosure () -> Bool,
        _ content: @autoclosure () -> Content
    ) -> some View where Content: View {
        if condition() {
            content()
        } else {
            self
        }
    }

    /// Add content when given condition is satisfied.
    @ViewBuilder
    func when<Content>(
        _ condition: @autoclosure () -> Bool,
        @ViewBuilder _ content: () -> Content
    ) -> some View where Content: View {
        if condition() {
            content()
        } else {
            self
        }
    }

    /// Add content when given condition is satisfied.
    @ViewBuilder
    public func when<Content>(
        _ condition: Bool,
        @ViewBuilder _ content: (Self) -> Content
    ) -> some View where Content: View {
        if condition {
            content(self)
        } else {
            self
        }
    }

    /// Add content when given condition is satisfied.
    @ViewBuilder
    public func when<Content>(
        _ condition: Binding<Bool>,
        @ViewBuilder _ content: (Self) -> Content
    ) -> some View where Content: View {
        if condition.wrappedValue {
            content(self)
        } else {
            self
        }
    }
}
