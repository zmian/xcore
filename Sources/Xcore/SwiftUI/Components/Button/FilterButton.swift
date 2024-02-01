//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

public struct FilterButton: View {
    @Environment(\.theme) private var theme
    private let count: Int?
    private let action: () -> Void

    public init(_ count: Int? = nil, action: @escaping () -> Void) {
        self.count = count
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            HStack(spacing: .s1) {
                badge
                Image(system: .line3HorizontalDecrease)
            }
        }
    }

    @ViewBuilder
    private var badge: some View {
        if let count = count, count > 0 {
            Text("\(count)")
                .font(.app(.footnote))
                .foregroundColor(theme.backgroundColor)
                .offset(y: -1)
                .padding(.s2)
                .background(theme.tintColor)
                .clipShape(.circle)
        }
    }
}
