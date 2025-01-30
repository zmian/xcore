//
// Xcore
// Copyright © 2020 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

// MARK: - Icon After

public struct IconAfterLabelStyle: LabelStyle {
    var axis: Axis = .horizontal

    public func makeBody(configuration: Configuration) -> some View {
        let layout = axis == .horizontal ? AnyLayout(HStackLayout()) : AnyLayout(VStackLayout())

        layout {
            configuration.title
            configuration.icon
        }
    }
}

// MARK: - Icon Before

public struct IconBeforeLabelStyle: LabelStyle {
    var axis: Axis = .horizontal

    public func makeBody(configuration: Configuration) -> some View {
        let layout = axis == .horizontal ? AnyLayout(HStackLayout()) : AnyLayout(VStackLayout())

        layout {
            configuration.icon
            configuration.title
        }
    }
}

// MARK: - Dot Syntax Support

extension LabelStyle where Self == IconBeforeLabelStyle {
    nonisolated public static var iconBefore: Self { .init() }

    nonisolated public static func iconBefore(axis: Axis) -> Self {
        .init(axis: axis)
    }
}

extension LabelStyle where Self == IconAfterLabelStyle {
    nonisolated public static var iconAfter: Self { .init() }

    nonisolated public static func iconAfter(axis: Axis) -> Self {
        .init(axis: axis)
    }
}

// MARK: - Preview

#Preview {
    List {
        Section("Horizontal Axis") {
            Label("Swift", systemImage: .swift)
                .labelStyle(.iconBefore)

            Label("Swift", systemImage: .swift)
                .labelStyle(.iconAfter)
        }

        Section("Vertical Axis") {
            Label("Swift", systemImage: .swift)
                .labelStyle(.iconBefore(axis: .vertical))

            Label("Swift", systemImage: .swift)
                .labelStyle(.iconAfter(axis: .vertical))
        }
    }
}
