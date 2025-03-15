//
// Xcore
// Copyright © 2025 Xcore
// MIT license, see LICENSE file for details
//

import Testing
import Foundation
@testable import Xcore

struct CountTests {
    @Test
    func initialization() {
        #expect(Count.finite(5).value == 5)
        #expect(Count.finite(0).value == 0)
        #expect(Count.finite(-5).value == -5)
        #expect(Count<Int>.infinite.value == nil)

        let finiteInt: Count<Int> = .finite(5)
        #expect(finiteInt.value == 5)
        #expect(finiteInt.isFinite)
        #expect(!finiteInt.isInfinite)

        let infiniteDouble: Count<Double> = .infinite
        #expect(infiniteDouble.value == nil)
        #expect(infiniteDouble.isInfinite)
        #expect(!infiniteDouble.isFinite)
    }

    @Test
    func expressibleByIntegerLiteral() {
        let countInt: Count<Int> = 10
        #expect(countInt.value == 10)

        let countUInt: Count<UInt> = 10
        #expect(countInt.value == 10)

        let countDouble: Count<Double> = 10
        #expect(countDouble.value == 10)

        let countDecimal: Count<Decimal> = 10
        #expect(countDecimal.value == 10)
    }

    @Test
    func expressibleByFloatLiteral() {
        let countDouble: Count<Double> = 5.5
        #expect(countDouble.value == 5.5)

        let countDecimal: Count<Decimal> = 5.5
        #expect(countDecimal.value == 5.5)
    }

    @Test
    func staticConstants() {
        #expect(Count.zero.value == 0)
        #expect(Count.once.value == 1)
        #expect(Count.min.value == Int.min)
        #expect(Count.max.value == Int.max)
        #expect(Count<Int>.infinite.isInfinite)

        // min
        #expect(Count<Int>.min.value == Int.min)
        #expect(Count<UInt>.min.value == UInt.min)
        #expect(Count<Double>.min.value == Double.leastNormalMagnitude)
        #expect(Count<Decimal>.min.value == Decimal.leastFiniteMagnitude)

        // max
        #expect(Count<Int>.max.value == Int.max)
        #expect(Count<UInt>.max.value == UInt.max)
        #expect(Count<Double>.max.value == Double.greatestFiniteMagnitude)
        #expect(Count<Decimal>.max.value == Decimal.greatestFiniteMagnitude)

        // zero
        #expect(Count<Int>.zero.value == 0)
        #expect(Count<UInt>.zero.value == 0)
        #expect(Count<Double>.zero.value == 0)
        #expect(Count<Decimal>.zero.value == 0)

        // once
        #expect(Count<Int>.once.value == 1)
        #expect(Count<UInt>.once.value == 1)
        #expect(Count<Double>.once.value == 1)
        #expect(Count<Decimal>.once.value == 1)
    }

    @Test
    func isFinite() {
        #expect(Count.finite(5).isFinite)
        #expect(Count.finite(0).isFinite)
        #expect(!Count<Int>.infinite.isFinite)
    }

    @Test
    func isInfinite() {
        #expect(Count<Int>.infinite.isInfinite)
        #expect(!Count<Int>.finite(10).isInfinite)
    }

    @Test
    func valueProperty() {
        #expect(Count.finite(7).value == 7)
        #expect(Count<Int>.finite(0).value == .zero)
        #expect(Count<Int>.infinite.value == nil)
    }

    @Test
    func description() {
        #expect(Count.finite(42).description == "42")
        #expect(Count.finite(5).description == "5")
        #expect(Count.finite(-3).description == "-3")
        #expect(Count<Int>.infinite.description == "infinite")
        #expect(Count<Double>.infinite.description == "infinite")

        #expect(Count<Int>.finite(1000).description == "1000")
        #expect(Count<UInt>.finite(1000).description == "1000")
        #expect(Count<Double>.finite(1000).description == "1000.0")
        #expect(Count<Decimal>.finite(1000).description == "1000")
    }

    @Test
    func localizedDescription() {
        #expect(Count.finite(1000.30).localizedDescription == "1,000.3")
        #expect(Count.finite(1000).localizedDescription == "1,000")
        #expect(Count.finite(42).localizedDescription == "42")
        #expect(Count.finite(5).localizedDescription == "5")
        #expect(Count.finite(-3).localizedDescription == "-3")
        #expect(Count<Int>.infinite.localizedDescription == "∞")
        #expect(Count<Double>.infinite.localizedDescription == "∞")
        #expect(Count<Decimal>.infinite.localizedDescription == "∞")

        #expect(Count<Int>.finite(1000).localizedDescription == "1,000")
        #expect(Count<UInt>.finite(1000).localizedDescription == "1,000")
        #expect(Count<Double>.finite(1000).localizedDescription == "1,000")
        #expect(Count<Float16>.finite(1000).localizedDescription == "1,000")
        #expect(Count<Decimal>.finite(1000).localizedDescription == "1,000")
    }

    @Test
    func addition() {
        #expect(Count.finite(3) + .finite(2) == .finite(5))
        #expect(Count.finite(-3) + .finite(5) == .finite(2))
        #expect(Count.infinite + .finite(5) == .infinite)
        #expect(Count.finite(5) + .infinite == .infinite)
        #expect(Count<Int>.infinite + .infinite == .infinite)
    }

    @Test
    func subtraction() {
        #expect(Count.finite(5) - .finite(3) == .finite(2))
        #expect(Count.finite(3) - .finite(5) == .finite(-2))
        #expect(Count.infinite - .finite(10) == .infinite)
        #expect(Count.finite(10) - .infinite == .infinite)
        #expect(Count<Int>.infinite - .infinite == .infinite)
    }

    @Test
    func multiplication() {
        #expect(Count.finite(4) * Count.finite(2) == .finite(8))
        #expect(Count.finite(-3) * Count.finite(3) == .finite(-9))
        #expect(Count.infinite * Count.finite(5) == .infinite)
        #expect(Count.finite(5) * Count.infinite == .infinite)
        #expect(Count<Int>.infinite * .infinite == .infinite)
    }

    @Test
    func comparison() {
        // < less than
        #expect(Count.finite(2) < .finite(5))
        #expect(!(Count.finite(9) < .finite(5)))
        #expect(!(Count.finite(5) < .finite(5)))

        // ∞ < ∞ // false
        #expect((Count<Int>.infinite < .infinite) == false)
        // ∞ < finite // false
        #expect((Count.infinite < .finite(100)) == false)
        // finite < ∞ // true
        #expect((Count.finite(100) < .infinite) == true)

        // > greater than
        #expect(!(Count.finite(2) > .finite(5)))
        #expect(Count.finite(9) > .finite(5))
        #expect(!(Count.finite(5) > .finite(5)))

        // ∞ > ∞ // false
        #expect((Count<Int>.infinite > .infinite) == false)
        // ∞ > finite // true
        #expect((Count.infinite > .finite(100)) == true)
        // finite > ∞ // false
        #expect((Count.finite(100) > .infinite) == false)
    }

    @Test
    func strideableDistance() {
        let p1: Count<Int> = .finite(4)
        let p2: Count<Int> = .finite(7)
        #expect(p1.distance(to: p2) == .finite(3))

        let negativeDistance = p2.distance(to: p1)
        #expect(negativeDistance == .finite(-3))

        let infiniteCount: Count<Int> = .infinite
        #expect(p1.distance(to: infiniteCount) == .infinite)
        #expect(infiniteCount.distance(to: p1) == .infinite)
    }

    @Test
    func strideableAdvancedBy() {
        let p: Count<Int> = .finite(4)
        #expect(p.advanced(by: .finite(2)) == .finite(6))
        #expect(p.advanced(by: .finite(-3)) == .finite(1))
        #expect(p.advanced(by: .infinite) == .infinite)

        let infiniteCount: Count<Int> = .infinite
        #expect(infiniteCount.advanced(by: .finite(3)) == .infinite)
    }

    @Test
    func signedNumericConformance() {
        let positive: Count<Double> = .finite(10)
        let negative: Count<Double> = .finite(-10)
        #expect(positive.magnitude == .finite(10))
        #expect(negative.magnitude == .finite(10))
        #expect(Count<Double>.infinite.magnitude == .infinite)

        #expect(Count<UInt>.finite(10).magnitude == Count<UInt>.finite(10))
        #expect(Count<Int>.finite(-10).magnitude == Count<UInt>.finite(10))
        #expect(Count<Double>.finite(-10).magnitude == Count<Double>.finite(10))
        #expect(Count<Decimal>.finite(-10).magnitude == Count<Decimal>.finite(10))
    }

    @Test
    func exactBinaryIntegerConversion() {
        let exactInt = Count<Int>(exactly: 42)
        #expect(exactInt == .finite(42))

        let exactNegativeInt = Count<Int>(exactly: -42)
        #expect(exactNegativeInt == .finite(-42))

        let doubleResult = Count<Double>(exactly: Int.max)
        #expect(doubleResult?.value == Double(exactly: Int.max))

        let nilResult = Count<UInt8>(exactly: Int.max)
        #expect(nilResult == nil)
    }
}
