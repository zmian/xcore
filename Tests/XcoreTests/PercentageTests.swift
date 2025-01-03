//
// Xcore
// Copyright © 2019 Xcore
// MIT license, see LICENSE file for details
//

import Testing
@testable import Xcore

struct PercentageTests {
    @Test
    func normalization() {
        let sliderValue1: Percentage = 0.5
        #expect(sliderValue1 == 0.5)

        var sliderValue2: Percentage = 500
        #expect(sliderValue2 == 100)

        sliderValue2 -= 1
        #expect(sliderValue2 == 99)

        sliderValue2 += 1
        #expect(sliderValue2 == 100)

        #expect(Percentage(rawValue: -1) == 0)
        #expect(Percentage(rawValue: 1000) == 100)

        #expect(Percentage.min + 0.7 == 0.7)
        #expect(Percentage.min + 0.7 != 0.6)

        #expect(Percentage.max - 900 == 0)
    }

    @Test
    func firstNormalizedThenEqualityCheck() {
        // NOTE: This is true as the rhs is first normalized and
        // then the equality is checked. See below:
        #expect(Percentage.max - 900 == -800) // x
        #expect(Percentage.max - 900 == 0) // y

        // x and y both yields same result. Here is why:
        #expect(Percentage.max - 900 == Percentage(rawValue: -800)) // x
        #expect(Percentage.max - 900 == Percentage(rawValue: 0)) // y

        // More details
        let a = Percentage(rawValue: -800)
        let b = Percentage.max - 900
        #expect(a == 0)
        #expect(b == 0)
        #expect(a == b)
    }
}
