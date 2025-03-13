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
        #expect(sliderValue2.value == 1)

        sliderValue2 -= 1
        #expect(sliderValue2 == 0)

        sliderValue2 += 1
        #expect(sliderValue2 == 1)

        #expect(Percentage(-1) == 0)
        #expect(Percentage(1000) == 1)

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
        #expect(Percentage.max - 900 == Percentage(-800)) // x
        #expect(Percentage.max - 900 == Percentage(0)) // y

        // More details
        let a = Percentage(-800)
        let b = Percentage.max - 900
        #expect(a == 0)
        #expect(b == 0)
        #expect(a == b)
    }

    // MARK: - Initialization Tests

    @Test
    func initialization() {
        #expect(Percentage(0.5).value == 0.5)
        #expect(Percentage(1.0).value == 1.0)
        #expect(Percentage(0.0).value == 0.0)

        // Out-of-bounds values should be clamped
        #expect(Percentage(-0.5).value == 0.0)
        #expect(Percentage(1.5).value == 1.0)
    }

    @Test
    func integerLiteralInitialization() {
        let percentage: Percentage = 50
        #expect(percentage.value == 1)
    }

    @Test
    func floatLiteralInitialization() {
        let percentage: Percentage = 0.5
        #expect(percentage.value == 0.5)
    }

    @Test
    func comparison() {
        #expect(Percentage(0.2) < Percentage(0.5))
        #expect(!(Percentage(0.9) < Percentage(0.5)))
        #expect(Percentage(0.3) == Percentage(0.3))
    }

    @Test
    func addition() {
        let p1: Percentage = 0.3
        let p2: Percentage = 0.4
        #expect((p1 + p2).value == 0.7)

        let p3: Percentage = 0.8
        #expect((p3 + p2).value == 1.0) // Clamped at max
    }

    @Test
    func subtraction() {
        let p1: Percentage = 0.7
        let p2: Percentage = 0.3
        #expect((p1 - p2).value == 0.4)

        let p3: Percentage = 0.2
        #expect((p3 - p2).value == 0.0) // Clamped at min
    }

    @Test
    func inPlaceAddition() {
        var p: Percentage = 0.4
        p += 0.3
        #expect(p.value == 0.7)

        p += 0.5
        #expect(p.value == 1.0) // Clamped
    }

    @Test
    func inPlaceSubtraction() {
        var p: Percentage = 0.7
        p -= 0.2
        #expect(p.value == 0.5)

        p -= 1.0
        #expect(p.value == 0.0) // Clamped
    }

    @Test
    func strideable() {
        let p1: Percentage = 0.4
        let p2: Percentage = 0.7
        #expect(p1.distance(to: p2) == 0.3)

        let advanced = p1.advanced(by: 0.2)
        #expect(advanced.value == 0.6)

        let overflow = p1.advanced(by: 1.0)
        #expect(overflow.value == 1.0) // Clamped
    }

    @Test
    func description() {
        #expect(Percentage(0.333).description == "33.30%")
        #expect(Percentage(0.33).description == "33%")
        #expect(Percentage(0.5).description == "50%")
        #expect(Percentage(1.0).description == "100%")
        #expect(Percentage(0.0).description == "0%")

        var sliderValue: Percentage = 500
        #expect(String(describing: sliderValue) == "100%")
        sliderValue -= 0.01
        #expect(String(describing: sliderValue) == "99%")
    }

    @Test
    func playgroundDescription() {
        #expect(Percentage(0.5).playgroundDescription as? Double == 0.5)
    }

    @Test
    func edgeCases() {
        #expect(Percentage(0.00001).value == 0.00001)
        #expect(Percentage(1.00001).value == 1.0) // Clamped
        #expect(Percentage(-0.00001).value == 0.0) // Clamped
    }
}
