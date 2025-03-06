//
// Xcore
// Copyright © 2025 Xcore
// MIT license, see LICENSE file for details
//

import Testing
import SwiftUI
@testable import Xcore

struct ColorTests {
    @Test
    func resolveForColorScheme() {
        let blue = UIColor.blue
        let orange = UIColor.orange

        let baseColor = Color(uiColor: UIColor {
            switch $0.userInterfaceStyle {
                case .dark: orange
                default: blue
            }
        })

        let lightColor = baseColor.resolve(for: .light)
        let darkColor = baseColor.resolve(for: .dark)

        #expect(lightColor.uiColor.hex == blue.hex)
        #expect(darkColor.uiColor.hex == orange.hex)
    }
}
