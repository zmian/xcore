//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

/// This view is an implementation detail of XStack and Toggle inits.
///
/// Don't use it.
///
/// :nodoc:
public struct _XIVTSSV<S: StringProtocol>: View {
    @Environment(\.theme) private var theme
    let title: Text
    let subtitle: S?
    let subtitleColor: UIColor?
    let spacing: CGFloat?

    init<S1: StringProtocol>(
        title: S1,
        subtitle: S?,
        subtitleColor: UIColor? = nil,
        spacing: CGFloat?
    ) {
        self.title = Text(title)
        self.subtitle = subtitle
        self.subtitleColor = subtitleColor
        self.spacing = spacing
    }

    init(
        title: Text,
        subtitle: S?,
        subtitleColor: UIColor? = nil,
        spacing: CGFloat?
    ) {
        self.title = title
        self.subtitle = subtitle
        self.subtitleColor = subtitleColor
        self.spacing = spacing
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: spacing ?? .s1) {
            title

            if let subtitle = subtitle {
                Text(subtitle)
                    .font(.app(.footnote))
                    .truncationMode(.middle)
                    .foregroundColor(subtitleColor ?? theme.textSecondaryColor)
            }
        }
        .multilineTextAlignment(.leading)
    }
}
