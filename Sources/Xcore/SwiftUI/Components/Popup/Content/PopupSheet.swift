//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

/// A representation of a sheet presentation.
public struct PopupSheet<Content>: View where Content: View {
    @Environment(\.theme) private var theme
    @Environment(\.popupCornerRadius) private var cornerRadius
    @Environment(\.defaultMinListRowHeight) private var rowHeight
    @State private var safeAreaInsetsBottom: CGFloat = 0
    private let content: () -> Content

    public init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }

    public var body: some View {
        VStack(spacing: 0) {
            content()
                .frame(maxWidth: .infinity, minHeight: rowHeight)
            Spacer(height: safeAreaInsetsBottom)
        }
        .backgroundColor(theme.backgroundColor)
        .cornerRadius(cornerRadius, corners: .top)
        .fixedSize(horizontal: false, vertical: true)
        // Offset to ensure content is clipped and it's pinned properly.
        // Using `ignoresSafeArea` makes the `safeAreaInsetsBottom` to always return 0
        // which means then we would need to manually offset with hardcoded values for
        // devices.
        .offset(y: safeAreaInsetsBottom)
        .readGeometryChange {
            safeAreaInsetsBottom = $0.safeAreaInsets.bottom
        }
    }
}

// MARK: - Previews

struct PopupSheet_Previews: PreviewProvider {
    private static let L = Samples.Strings.deleteMessageAlert

    static var previews: some View {
        PopupSheet {
            List {
                Text("Swift")
                Text("Swift")
                Text("Swift")
            }
            .frame(height: 250)
        }
        .frame(max: .infinity, alignment: .bottom)
        .backgroundColor(.secondary)
        .ignoresSafeArea()
    }
}
