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
            @Clamping(0...255) var red = 127
            @Clamping(0...255) var green = 127
            @Clamping(0...255) var blue = 127
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
