//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

public struct SettingsIconLabelStyle: LabelStyle {
    var tint: Color

    public func makeBody(configuration: Configuration) -> some View {
        Label {
            configuration.title
        } icon: {
            configuration.icon
                .imageScale(.small)
                .foregroundStyle(.white)
                .background(
                    RoundedRectangle(cornerRadius: 6, style: .continuous)
                        .fill(tint)
                        .frame(28)
                )
        }
    }
}

// MARK: - Dot Syntax Support

extension LabelStyle where Self == SettingsIconLabelStyle {
    public static func settingsIcon(tint: Color) -> Self {
        .init(tint: tint)
    }
}
