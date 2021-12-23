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
public struct _XIVTSSV: View {
    @Environment(\.theme) private var theme
    let title: Text
    let subtitle: Text?
    let spacing: CGFloat?

    init<S1: StringProtocol, S2: StringProtocol>(title: S1, subtitle: S2?, spacing: CGFloat?) {
        self.title = Text(title)
        self.subtitle = Text(subtitle)
        self.spacing = spacing
    }

    init(title: Text, subtitle: Text?, spacing: CGFloat?) {
        self.title = title
        self.subtitle = subtitle
        self.spacing = spacing
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: spacing ?? .s1) {
            title

            if let subtitle = subtitle {
                subtitle
                    .font(.app(.footnote))
                    .truncationMode(.middle)
                    .foregroundColor(theme.textSecondaryColor)
            }
        }
        .multilineTextAlignment(.leading)
    }
}
