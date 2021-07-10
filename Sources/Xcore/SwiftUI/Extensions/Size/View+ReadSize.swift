//
// Xcore
// Copyright © 2020 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

private struct SizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {}
}

extension View {
    /// Adds a modifier for this view that binds view size to specified binding.
    public func readSize(_ size: Binding<CGSize>) -> some View {
        readSize {
            size.wrappedValue = $0
        }
    }

    /// Adds a modifier for this view that fires an action when view's size changes.
    ///
    /// - SeeAlso: https://fivestars.blog/swiftui/swiftui-share-layout-information.html
    public func readSize(perform action: @escaping (CGSize) -> Void) -> some View {
        background(
            GeometryReader { geometry in
                Color.clear
                    .preference(key: SizePreferenceKey.self, value: geometry.size)
            }
        )
        .onPreferenceChange(SizePreferenceKey.self, perform: action)
    }
}
