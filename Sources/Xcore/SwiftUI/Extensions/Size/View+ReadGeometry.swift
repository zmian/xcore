//
// Xcore
// Copyright © 2020 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

extension View {
    /// Adds a modifier for this view that fires an action when view's geometry
    /// changes.
    public func readGeometry(perform action: @escaping (GeometryProxy) -> Void) -> some View {
        background(
            GeometryReader { geometry -> Color in
                action(geometry)
                return Color.clear
            }
        )
    }
}

extension View {
    public func readOffsetY(_ offset: Binding<CGFloat>) -> some View {
        readGeometry {
            offset.wrappedValue = $0.frame(in: .global).minY
        }
    }
}
