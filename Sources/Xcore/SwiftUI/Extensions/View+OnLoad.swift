//
// Xcore
// Copyright © 2022 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI
import Combine

extension View {
    /// Adds an action to perform when this view loads.
    ///
    /// - Parameter action: The action to perform. If `action` is `nil`, the call
    ///   has no effect.
    ///
    /// - Returns: A view that triggers `action` when this view loads.
    public func onLoad(perform action: (() -> Void)? = nil) -> some View {
        modifier(OnLoadActionModifier(action: action))
    }
}

// MARK: - ViewModifier

private struct OnLoadActionModifier: ViewModifier {
    @State private var didLoad = false
    var action: (() -> Void)?

    func body(content: Content) -> some View {
        content
            .onReceive(Just(true)) { _ in
                // We are not using "onAppear" as it won't be called if content is "EmptyView"
                // whereas "onReceive" is executed.
                if !didLoad {
                    didLoad = true
                    action?()
                }
            }
    }
}
