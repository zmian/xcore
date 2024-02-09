//
// Xcore
// Copyright © 2020 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

extension Shape where Self == UnevenRoundedRectangle {
    /// A rectangular shape with rounded corners with different values, aligned
    /// inside the frame of the view containing it.
    @_disfavoredOverload
    public static func rect(
        topRadius: CGFloat = 0,
        bottomRadius: CGFloat = 0,
        style: RoundedCornerStyle = .continuous
    ) -> Self {
        rect(
            topLeadingRadius: topRadius,
            bottomLeadingRadius: bottomRadius,
            bottomTrailingRadius: bottomRadius,
            topTrailingRadius: topRadius,
            style: style
        )
    }
}

// MARK: - Preview

#Preview {
    VStack {
        Color.blue
            .clipShape(.rect(topLeadingRadius: 75, bottomTrailingRadius: 75))

        Color.orange
            .clipShape(.rect(topRadius: 75))

        Color.green
            .clipShape(.rect(bottomRadius: 75))

        Color.red
            .clipShape(.rect(cornerRadius: 75))

        Color.red
            .clipShape(.rect(topLeadingRadius: 75))

        Color.red
            .clipShape(.rect(topRadius: 75, bottomRadius: 10))
    }
    .padding(.defaultSpacing)
    .previewLayout(.sizeThatFits)
}
