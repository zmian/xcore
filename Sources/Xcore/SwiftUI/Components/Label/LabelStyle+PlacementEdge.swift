//
// Xcore
// Copyright © 2020 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

public struct IconPlacementEdgeLabelStyle: LabelStyle {
    let edge: Edge

    public func makeBody(configuration: Configuration) -> some View {
        let layout = edge.isHorizontal ? AnyLayout(HStackLayout()) : AnyLayout(VStackLayout())

        switch edge {
            case .leading, .top:
                layout {
                    configuration.icon
                    configuration.title
                }
            case .trailing, .bottom:
                layout {
                    configuration.title
                    configuration.icon
                }
        }
    }
}

extension LabelStyle where Self == IconPlacementEdgeLabelStyle {
    public static func iconPlacement(_ edge: Edge) -> Self {
        .init(edge: edge)
    }
}

// MARK: - Preview

#Preview {
    List {
        Section("Horizontal Placement") {
            Label("Swift", systemImage: .swift)
                .labelStyle(.iconPlacement(.leading))

            Label("Swift", systemImage: .swift)
                .labelStyle(.iconPlacement(.trailing))
        }

        Section("Vertical Placement") {
            Label("Swift", systemImage: .swift)
                .labelStyle(.iconPlacement(.top))

            Label("Swift", systemImage: .swift)
                .labelStyle(.iconPlacement(.bottom))
                .labelStyle(.titleAndIcon)
        }
    }
}
