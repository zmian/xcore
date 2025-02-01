//
// Xcore
// Copyright © 2025 Xcore
// MIT license, see LICENSE file for details
//

import Testing
@testable import Xcore

struct ClampingTests {
    @Test
    func basics() {
        struct Color {
            @Clamping(0...255) var red: Int = 127
            @Clamping(0...255) var green: Int = 127
            @Clamping(0...255) var blue: Int = 127
            @Clamping(0...1) var alpha: Double = 1
        }

        var color = Color()

        color.alpha = 255
        #expect(color.alpha == 1)

        color.alpha = -255
        #expect(color.alpha == 0)

        color.alpha = 0.5
        #expect(color.alpha == 0.5)
    }
}
