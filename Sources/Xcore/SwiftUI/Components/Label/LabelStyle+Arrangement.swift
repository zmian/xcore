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
        switch axis {
            case .horizontal:
                HStack {
                    configuration.title
                    configuration.icon
                }
            case .vertical:
                VStack {
                    configuration.title
                    configuration.icon
                }
        }
    }
}

// MARK: - Icon Before

public struct IconBeforeLabelStyle: LabelStyle {
    var axis: Axis = .horizontal

    public func makeBody(configuration: Configuration) -> some View {
        switch axis {
            case .horizontal:
                HStack {
                    configuration.icon
                    configuration.title
                }
            case .vertical:
                VStack {
                    configuration.icon
                    configuration.title
                }
        }
    }
}

// MARK: - Dot Syntax Support

extension LabelStyle where Self == IconBeforeLabelStyle {
    public static var iconBefore: Self { .init() }

    public static func iconBefore(axis: Axis) -> Self {
        .init(axis: axis)
    }
}

extension LabelStyle where Self == IconAfterLabelStyle {
    public static var iconAfter: Self { .init() }

    public static func iconAfter(axis: Axis) -> Self {
        .init(axis: axis)
    }
}
