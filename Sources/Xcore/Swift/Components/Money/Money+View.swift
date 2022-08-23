//
// Xcore
// Copyright © 2022 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

extension Money: View {
    public var body: some View {
        if #available(iOS 15, *) {
            Text(attributedString())
        } else {
            iOS14Money
        }
    }

    @ViewBuilder
    @available(iOS, introduced: 14, deprecated: 15, message: "Use attributedString directly.")
    private var iOS14Money: some View {
        if amount == 0, let zeroString = zeroString {
            Text(zeroString)
        } else {
            Text(formatted())
                .unwrap(font?.majorUnit) { view, font in
                    view.font(.init(font))
                }
                .unwrap(foregroundColor) { view, color in
                    view.foregroundColor(color)
                }
        }
    }

    @available(iOS, introduced: 14, deprecated: 15, message: "Use attributedString directly.")
    private var foregroundColor: SwiftUI.Color? {
        guard let color else {
            return nil
        }

        if amount == 0 {
            return color.zero
        }

        return amount > 0 ? color.positive : color.negative
    }
}
