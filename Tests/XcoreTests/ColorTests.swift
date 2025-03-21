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
        let env = EnvironmentValues()
        let blue = Color(Color.blue.resolve(in: env))
        let orange = Color(Color.orange.resolve(in: env))

        let baseColor = Color(light: blue, dark: orange)

        let lightColor = baseColor.resolve(for: .light)
        let darkColor = baseColor.resolve(for: .dark)

        #expect(lightColor == blue)
        #expect(darkColor == orange)
    }
}
