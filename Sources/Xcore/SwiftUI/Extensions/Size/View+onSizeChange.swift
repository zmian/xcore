//
// Xcore
// Copyright © 2020 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

// MARK: - onSizeChange

extension View {
    /// Writes to the given binding when view's size changes.
    nonisolated public func onSizeChange(_ size: Binding<CGSize>) -> some View {
        onSizeChange { newValue in
            let currentValue = size.wrappedValue

            // Avoid excessively writing the same value to the binding.
            if currentValue != newValue {
                size.wrappedValue = newValue
            }
        }
    }

    /// Adds an action to be performed when view's size changes.
    nonisolated public func onSizeChange(perform action: @escaping (CGSize) -> Void) -> some View {
        onGeometryChange(
            for: CGSize.self,
            of: { $0.size },
            action: action
        )
    }
}

// MARK: - readOffsetY

extension View {
    nonisolated public func readOffsetY(_ offset: Binding<CGFloat>) -> some View {
        onGeometryChange(for: CGFloat.self) { proxy in
            proxy.frame(in: .global).minY
        } action: { newValue in
            let currentValue = offset.wrappedValue

            // Avoid excessively writing the same value to the binding.
            if currentValue != newValue {
                offset.wrappedValue = newValue
            }
        }
    }
}
