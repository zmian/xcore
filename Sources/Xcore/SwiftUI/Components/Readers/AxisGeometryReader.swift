//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

/// A container view that defines its content as a function of its own size and
/// coordinate space in single axis.
public struct AxisGeometryReader<Content: View>: View {
    @State private var size: CGFloat = 0
    private let axis: Axis
    private let alignment: Alignment
    private let content: (CGFloat) -> Content

    public init(
        axis: Axis = .horizontal,
        alignment: Alignment = .center,
        @ViewBuilder content: @escaping (CGFloat) -> Content
    ) {
        self.axis = axis
        self.alignment = alignment
        self.content = content
    }

    public var body: some View {
        content(size)
            .frame(
                maxWidth: axis == .horizontal ? .infinity : nil,
                maxHeight: axis == .vertical ? .infinity : nil,
                alignment: alignment
            )
            .onSizeChange {
                size = axis == .horizontal ? $0.width : $0.height
            }
    }
}
