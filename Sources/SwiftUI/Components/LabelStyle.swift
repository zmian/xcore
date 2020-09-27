//
// Xcore
// Copyright © 2020 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

@available(iOS 14.0, *)
public struct IconAfterLabelStyle: LabelStyle {
    private let axis: Axis

    public init(axis: Axis = .horizontal) {
        self.axis = axis
    }

    public func makeBody(configuration: Self.Configuration) -> some View {
        Group {
            switch axis {
                case .horizontal:
                    HStack {
                        configuration.title
                        configuration.icon
                    }
                case .vertical:
                    VStack(alignment: .center, spacing: 8) {
                        configuration.title
                        configuration.icon
                    }
            }
        }
    }
}

@available(iOS 14.0, *)
public struct IconBeforeLabelStyle: LabelStyle {
    private let axis: Axis

    public init(axis: Axis = .horizontal) {
        self.axis = axis
    }

    public func makeBody(configuration: Self.Configuration) -> some View {
        Group {
            switch axis {
                case .horizontal:
                    HStack {
                        configuration.icon
                        configuration.title
                    }
                case .vertical:
                    VStack(alignment: .center, spacing: 8) {
                        configuration.icon
                        configuration.title
                    }
            }
        }
    }
}
