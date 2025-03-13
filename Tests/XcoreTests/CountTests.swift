//
// Xcore
// Copyright © 2025 Xcore
// MIT license, see LICENSE file for details
//

import Testing
@testable import Xcore

struct CountTests {
    @Test
    func initialization() {
        #expect(Count.finite(5).value == 5)
        #expect(Count.finite(0).value == 0)
        #expect(Count.finite(-5).value == -5)
        #expect(Count.infinite.value == nil)
    }

    @Test
    func expressibleByIntegerLiteral() {
        let count: Count = 10
        #expect(count.value == 10)
    }

    @Test
    func staticConstants() {
        #expect(Count.zero.value == 0)
        #expect(Count.once.value == 1)
        #expect(Count.min.value == Int.min)
        #expect(Count.max.value == Int.max)
        #expect(Count.infinite.isInfinite)
    }

    @Test
    func isFinite() {
        #expect(Count.finite(5).isFinite)
        #expect(Count.finite(0).isFinite)
        #expect(!Count.infinite.isFinite)
    }

    @Test
    func isInfinite() {
        #expect(Count.infinite.isInfinite)
        #expect(!Count.finite(10).isInfinite)
    }

    @Test
    func valueProperty() {
        #expect(Count.finite(7).value == 7)
        #expect(Count.infinite.value == nil)
    }

    @Test
    func addition() {
        #expect(Count.finite(3) + Count.finite(2) == Count.finite(5))
        #expect(Count.finite(-3) + Count.finite(5) == Count.finite(2))
        #expect(Count.infinite + Count.finite(5) == Count.infinite)
        #expect(Count.finite(5) + Count.infinite == Count.infinite)
        #expect(Count.infinite + Count.infinite == Count.infinite)
    }

    @Test
    func subtraction() {
        #expect(Count.finite(5) - Count.finite(3) == Count.finite(2))
        #expect(Count.finite(3) - Count.finite(5) == Count.finite(-2))
        #expect(Count.infinite - Count.finite(10) == Count.infinite)
        #expect(Count.finite(10) - Count.infinite == Count.infinite)
        #expect(Count.infinite - Count.infinite == Count.infinite)
    }

    @Test
    func description() {
        #expect(Count.finite(1000).description == "1000")
        #expect(Count.finite(42).description == "42")
        #expect(Count.finite(5).description == "5")
        #expect(Count.finite(-3).description == "-3")
        #expect(Count.infinite.description == "infinite")
    }

    @Test
    func localizedDescription() {
        #expect(Count.finite(1000).localizedDescription == "1,000")
        #expect(Count.finite(42).localizedDescription == "42")
        #expect(Count.finite(5).localizedDescription == "5")
        #expect(Count.finite(-3).localizedDescription == "-3")
        #expect(Count.infinite.localizedDescription == "∞")
    }
}
