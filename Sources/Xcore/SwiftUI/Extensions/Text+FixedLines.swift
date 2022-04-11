//
// Xcore
// Copyright © 2022 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

extension Text {
    /// A view to render multi-line text so that's height is fixed to given number
    /// of lines.
    ///
    /// It ensures that text always occupies provided number of lines regardless of
    /// the actual number of lines of the text content.
    public func fixedLines(_ lines: Int) -> some View {
        ZStack {
            self
                .lineLimit(lines)
                .minimumScaleFactor(0.2)

            // Gets the size of the lines
            Text([String](repeating: "Sphinx", count: lines).joined(separator: "\n"))
                .lineLimit(lines)
                .fixedSize(horizontal: false, vertical: true)
                .hidden()
        }
        .frame(maxWidth: .infinity)
    }
}
