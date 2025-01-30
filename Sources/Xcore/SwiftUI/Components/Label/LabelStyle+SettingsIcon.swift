//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

public struct SettingsIconLabelStyle: LabelStyle {
    @ScaledMetric private var padding = 6
    var tint: Color
    var contentMode: ContentMode

    public func makeBody(configuration: Configuration) -> some View {
        Label {
            configuration.title
        } icon: {
            configuration.icon
                .aspectRatio(contentMode: contentMode)
                .foregroundStyle(.white)
                .padding(padding)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(tint)
                        .aspectRatio(contentMode: .fill)
                )
        }
    }
}

// MARK: - Dot Syntax Support

extension LabelStyle where Self == SettingsIconLabelStyle {
    public static func settingsIcon(tint: Color, contentMode: ContentMode = .fit) -> Self {
        .init(tint: tint, contentMode: contentMode)
    }
}

// MARK: - Preview

#Preview {
    Label("Swift", systemImage: .swift)
        .labelStyle(.settingsIcon(tint: .orange))
        .font(.largeTitle)
}
