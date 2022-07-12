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
    private let content: () -> Content

    public init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }

    public var body: some View {
        VStack(spacing: 0) {
            content()
                .frame(maxWidth: .infinity, minHeight: rowHeight)
        }
        .fixedSize(horizontal: false, vertical: true)
        .background(background)
    }

    /// Creates background that ensures it's always pinned to the bottom when spring
    /// animation is used to display the sheet.
    private var background: some View {
        RoundedRectangleCorner(radius: cornerRadius, corners: .top)
            .fill(Color(theme.backgroundColor))
            .background(
                RoundedRectangleCorner(radius: cornerRadius, corners: .top)
                    .fill(Color(theme.backgroundColor))
                    .offset(y: AppConstants.homeIndicatorHeightIfPresent * 2)
            )
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
