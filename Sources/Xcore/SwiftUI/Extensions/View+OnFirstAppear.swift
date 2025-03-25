//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

extension View {
    /// Adds an action to perform when this view appears for the time.
    ///
    /// - Parameter action: The action to perform. If `action` is `nil`, the call
    ///   has no effect.
    ///
    /// - Returns: A view that triggers `action` when this view appears for the
    ///   time.
    public func onFirstAppear(perform action: (() -> Void)?) -> some View {
        modifier(FirstAppearActionModifier(action: action))
    }

    /// Adds an action to perform when this view appears for the time or when the
    /// given id value changes.
    ///
    /// - Parameters:
    ///   - id: When the value of the id changes it fires an action.
    ///   - action: The action to perform. If `action` is `nil`, the call
    ///     has no effect.
    ///
    /// - Returns: A view that triggers `action` when this view appears for the
    ///   time or when the given id value changes.
    public func onFirstAppear(
        id: some Equatable,
        perform action: (() -> Void)?
    ) -> some View {
        onFirstAppear(perform: action)
            .onChange(of: id) { _, _ in
                action?()
            }
    }

    /// Adds an action to perform when this view appears or when the given id value
    /// changes.
    ///
    /// - Parameters:
    ///   - id: When the value of the id changes it fires an action.
    ///   - action: The action to perform. If `action` is `nil`, the call
    ///     has no effect.
    ///
    /// - Returns: A view that triggers `action` when this view appears or when the
    ///   given id value changes.
    public func onAppear(
        id: some Equatable,
        perform action: (() -> Void)?
    ) -> some View {
        onAppear(perform: action)
            .onChange(of: id) { _, _ in
                action?()
            }
    }
}

// MARK: - ViewModifier

private struct FirstAppearActionModifier: ViewModifier {
    @State private var didAppear = false
    let action: (() -> Void)?

    func body(content: Content) -> some View {
        content
            .onAppear {
                if !didAppear {
                    didAppear = true
                    action?()
                }
            }
    }
}
