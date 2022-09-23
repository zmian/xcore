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
    private let title: Text
    private let subtitle: Text?
    private let spacing: CGFloat?

    public init(title: some StringProtocol, spacing: CGFloat?) {
        self.title = Text(title)
        self.subtitle = nil
        self.spacing = spacing
    }

    public init(title: some StringProtocol, subtitle: (some StringProtocol)?, spacing: CGFloat?) {
        self.title = Text(title)
        self.subtitle = Text(subtitle)
        self.spacing = spacing
    }

    public init(title: Text, subtitle: Text?, spacing: CGFloat?) {
        self.title = title
        self.subtitle = subtitle
        self.spacing = spacing
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: spacing ?? .s1) {
            title

            if let subtitle {
                subtitle
                    .font(.app(.footnote))
                    .foregroundColor(theme.textSecondaryColor)
                    .truncationMode(.middle)
            }
        }
        .multilineTextAlignment(.leading)
    }
}
