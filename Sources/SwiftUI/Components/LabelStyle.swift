//
// Xcore
// Copyright © 2020 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

public struct IconAfterLabelStyle: LabelStyle {
    private let axis: Axis

    public init(axis: Axis = .horizontal) {
        self.axis = axis
    }

    @ViewBuilder
    public func makeBody(configuration: Self.Configuration) -> some View {
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

public struct IconBeforeLabelStyle: LabelStyle {
    private let axis: Axis

    public init(axis: Axis = .horizontal) {
        self.axis = axis
    }

    @ViewBuilder
    public func makeBody(configuration: Self.Configuration) -> some View {
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
