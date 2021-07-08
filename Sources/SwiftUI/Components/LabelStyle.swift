//
// Xcore
// Copyright © 2020 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

// MARK: - Icon After

public struct IconAfterLabelStyle: LabelStyle {
    private let axis: Axis

    init(axis: Axis = .horizontal) {
        self.axis = axis
    }

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

// MARK: - Icon Before

public struct IconBeforeLabelStyle: LabelStyle {
    private let axis: Axis

    init(axis: Axis = .horizontal) {
        self.axis = axis
    }

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

// MARK: - Settings Icon

public struct SettingsIconLabelStyle: LabelStyle {
    var tint: Color

    public func makeBody(configuration: Self.Configuration) -> some View {
        Label {
            configuration.title
        } icon: {
            configuration.icon
                .imageScale(.small)
                .foregroundColor(.white)
                .background(
                    RoundedRectangle(cornerRadius: 6, style: .continuous)
                        .fill(tint)
                        .frame(28)
                )
        }
    }
}

// MARK: - Convenience

extension LabelStyle where Self == IconBeforeLabelStyle {
    public static var iconBefore: Self { Self() }

    public static func iconBefore(axis: Axis) -> Self {
        Self(axis: axis)
    }
}

extension LabelStyle where Self == IconAfterLabelStyle {
    public static var iconAfter: Self { Self() }

    public static func iconAfter(axis: Axis) -> Self {
        Self(axis: axis)
    }
}

extension LabelStyle where Self == SettingsIconLabelStyle {
    public static func settingsIcon(tint: Color) -> Self {
        Self(tint: tint)
    }
}
