//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

public struct ToolbarButtonStyle: ButtonStyle {
    public func makeBody(configuration: Self.Configuration) -> some View {
        InternalBody(configuration: configuration)
    }

    private struct InternalBody: View {
        @Environment(\.isEnabled) private var isEnabled
        let configuration: ButtonStyleConfiguration

        var body: some View {
            configuration.label
                .opacity(isEnabled ? 1 : 0.2)
                .scaleOpacityEffect(configuration.isPressed)
                .frame(min: 44, alignment: .trailing)
                .contentShape(Rectangle())
        }
    }
}

// MARK: - Dot Syntax Support

extension ButtonStyle where Self == ToolbarButtonStyle {
    public static var toolbar: Self { .init() }
}
