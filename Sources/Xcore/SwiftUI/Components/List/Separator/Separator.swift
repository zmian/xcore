//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

/// A visual element that can be used to separate other content.
///
/// Similar to `Divider` but allows the user to change style.
public struct Separator: View {
    @Environment(\.theme) private var theme
    @Environment(\.listRowSeparatorStyle) private var separatorStyle
    private let height: CGFloat

    public init(height: CGFloat? = nil) {
        self.height = height ?? .onePixel
    }

    public var body: some View {
        theme.separatorColor
            .frame(height: height)
            .padding(separatorStyle.insets)
            .hidden(separatorStyle == .hidden, remove: true)
    }
}

extension View {
    public func separator(hidden: Bool = false, alignment: Alignment = .bottom) -> some View {
        overlay(Separator().hidden(hidden), alignment: alignment)
    }
}
