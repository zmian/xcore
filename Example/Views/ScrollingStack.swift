//
// Xcore
// Copyright © 2025 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

extension ScrollingStack {
    enum ScalingEdge {
        case top
        case bottom
        case both
    }
}

struct ScrollingStack: View {
    let edge: ScalingEdge

    var body: some View {
        GeometryReader { geometry in
            let scrollViewFrame = geometry.frame(in: .local)
            ScrollView {
                ForEach(0..<100) { offset in
                    RowContent(edge: edge, offset: offset, scrollViewFrame: scrollViewFrame)
                }
                .padding(.horizontal)
            }
        }
    }

    private struct RowContent: View {
        let edge: ScalingEdge
        let offset: Int
        let scrollViewFrame: CGRect
        @State var zIndex: Double = 0

        var body: some View {
            RoundedRectangle(cornerRadius: 24)
                .fill(.blue)
                .frame(height: 100.0)
                .onGeometryChange(for: CGRect.self) { $0.frame(in: .scrollView) } action: { newValue in
                    zIndex = min(newValue.minY, min(scrollViewFrame.midY - newValue.midY, 0))
                }
                .zIndex(zIndex * Double(offset))
                .visualEffect { content, proxy in
                    let frame = proxy.frame(in: .scrollView(axis: .vertical))
                    let distance1 = frame.minY
                    let distance2 = scrollViewFrame.maxY - frame.maxY
                    let distance = min(distance1, min(distance2, 0))
                    let scale = max(1 + distance / 1000, 0)
                    let content = content
                        .hueRotation(.degrees(frame.origin.y / 5))

                    switch edge {
                        case .top:
                            return content
                                .scaleEffect(distance1 < 0 ? scale : 1, anchor: .top)
                                .offset(y: distance1 < 0 ? -distance : 0)
                                .brightness(distance1 < 0 ? -distance / 500 : 0)
                        case .bottom:
                            return content
                                .scaleEffect(distance1 < 0 ? 1 : scale)
                                .offset(y: distance1 < 0 ? 0 : distance)
                                .brightness(distance1 < 0 ? 0 : -distance / 200)
                        case .both:
                            return content
                                .scaleEffect(scale)
                                .offset(y: distance1 < 0 ? -distance : distance)
                                .brightness(distance1 < 0 ? -distance / 500 : -distance / 200)
                    }
                }
        }
    }
}

#Preview("Edge") {
    ScrollingStack(edge: .both)
}
