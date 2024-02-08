//
// Xcore
// Copyright © 2020 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

extension View {
    public func readOffsetY(_ offset: Binding<CGFloat>) -> some View {
        readGeometry {
            let currentValue = offset.wrappedValue
            let newValue = $0.frame(in: .global).minY

            // Avoid excessively writing the same value to the binding.
            if currentValue != newValue {
                offset.wrappedValue = newValue
            }
        }
    }
}

extension View {
    /// Adds a modifier for this view that fires an action with geometry proxy.
    public func readGeometry(perform action: @escaping (GeometryProxy) -> Void) -> some View {
        background(
            GeometryReader { geometry -> Color in
                // Fixes a crash in AG Graph where "value is changing during update."
                DispatchQueue.main.async {
                    action(geometry)
                }
                return Color.clear
            }
        )
    }

    /// Adds a modifier for this view that fires an action when view's geometry changes.
    public func readGeometryChange(perform action: @escaping (GeometryProxy) -> Void) -> some View {
        background(
            GeometryReader { geometry in
                Color.clear
                    .preference(key: GeometryPreferenceKey.self, value: .init(base: geometry))
            }
        )
        .onPreferenceChange(GeometryPreferenceKey.self) {
            guard let proxy = $0?.base else {
                return
            }

            action(proxy)
        }
    }
}

// MARK: - PreferenceKey

private struct GeometryPreferenceKey: PreferenceKey {
    static var defaultValue: GeometryProxyWrapper?
    static func reduce(value: inout Value, nextValue: () -> Value) {}
}

// MARK: - Wrapper

private struct GeometryProxyWrapper: Equatable {
    let base: GeometryProxy

    static func ==(lhs: GeometryProxyWrapper, rhs: GeometryProxyWrapper) -> Bool {
        lhs.base.size == rhs.base.size &&
            lhs.base.safeAreaInsets == rhs.base.safeAreaInsets &&
            lhs.base.frame(in: .global) == rhs.base.frame(in: .global) &&
            lhs.base.frame(in: .local) == rhs.base.frame(in: .local)
    }
}
