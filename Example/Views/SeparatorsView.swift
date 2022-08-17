//
// Xcore
// Copyright © 2022 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

struct SeparatorsView: View {
    @Environment(\.theme) private var theme

    var body: some View {
        VStack(spacing: .defaultSpacing) {
            HStack {
                separators
            }

            VStack {
                separators
            }
        }
        .padding(.defaultSpacing)
    }

    @ViewBuilder
    private var separators: some View {
        Group {
            Separator()
            Spacer(minLength: 0)
            Separator(style: .dotted)
            Spacer(minLength: 0)
            Separator(color: .blue)
            Spacer(minLength: 0)
            Separator(color: .blue, style: .dotted)
            Spacer(minLength: 0)
            Separator(color: .primary, lineWidth: 4)
        }
        Group {
            Spacer(minLength: 0)
            Separator(color: .blue, lineWidth: 10)
            Spacer(minLength: 0)
            Separator(color: .primary, style: .init(
                lineWidth: 2,
                lineCap: .square,
                dash: [2, 4]
            ))
            Spacer(minLength: 0)
            Separator(color: .primary, style: .init(
                lineWidth: 10,
                lineCap: .square,
                dash: [1, 15, 10, 20]
            ))
            Spacer(minLength: 0)
            Separator(style: .dotted(lineWidth: 10))
            Spacer(minLength: 0)
            Separator(color: .blue, style: .dotted(lineWidth: 10))
                .opacity(0.2)
        }
    }
}
