//
// Xcore
// Copyright © 2019 Xcore
// MIT license, see LICENSE file for details
//

import Testing
import Foundation
@testable import Xcore

struct NumbersTests {
    @Test
    func runningSum() {
        let intRunningSum = [1, 1, 1, 1, 1, 1].runningSum()
        let expected1 = [1, 2, 3, 4, 5, 6]
        #expect(intRunningSum == expected1)

        let doubleRunningSum = [1.0, 1, 1, 1, 1, 1].runningSum()
        let expected2 = [1.0, 2, 3, 4, 5, 6]
        #expect(doubleRunningSum == expected2)
    }

    @Test
    func sum() {
        let intSum = [1, 1, 1, 1, 1, 1].sum()
        #expect(intSum == 6)

        let doubleSum = [1.0, 1, 1, 1, 1, 1].sum()
        #expect(doubleSum == 6.0)
    }

    @Test
    func sumClosure() {
        struct Expense {
            let title: String
            let amount: Double
        }

        let expenses = [
            Expense(title: "Laptop", amount: 1200),
            Expense(title: "Chair", amount: 1000)
        ]

        let totalCost = expenses.sum(\.amount)
        #expect(totalCost == 2200.0)
    }

    @Test
    func average() {
        let int = [1, 1, 1, 1, 1, 1].average()
        #expect(int == 1.0)

        let double = [1.0, 1, 1, 1, 1, 1].average()
        #expect(double == 1.0)

        let float: [Float] = [1.0, 1, 1, 1, 1, 1]
        #expect(float.average() == 1.0)

        let float2: [Float] = [1.0, 12.3, 33, 37, 34, 45]
        #expect(float2.average() == 27.050001)

        let decimal: [Decimal] = [1.0, 12.3, 33, 37, 34, 45]
        #expect(decimal.average() == 27.05)
    }

    @Test
    func map() {
        let values = 10.map { $0 * 2 }
        let expected = [2, 4, 6, 8, 10, 12, 14, 16, 18, 20]
        #expect(values == expected)
    }

    @Test
    func clamped() {
        #expect(10 == 30.clamped(to: 0...10))
        #expect(3.0 == 3.0.clamped(to: 0.0...10.0))
        #expect("x" == "z".clamped(to: "a"..."x"))
    }

    @Test
    func paddedLength() {
        // 0
        #expect("0" == 0.padded(length: 0))
        #expect("0" == 0.padded(length: 1))
        #expect("00000" == 0.padded(length: 5))
        // 1
        #expect("1" == 1.padded(length: 0))
        #expect("1" == 1.padded(length: 1))
        #expect("00001" == 1.padded(length: 5))
        // 10
        #expect("10" == 10.padded(length: 0))
        #expect("10" == 10.padded(length: 1))
        #expect("00010" == 10.padded(length: 5))
        // 100
        #expect("100" == 100.padded(length: 0))
        #expect("100" == 100.padded(length: 1))
        #expect("00100" == 100.padded(length: 5))
    }

    @Test
    func integralAndFractionalParts() throws {
        let amount1 = 1200.30
        #expect(amount1.integralPart == 1200)
        #expect(amount1.fractionalPart == 0.2999999999999545)

        let amount2 = 1200.00
        #expect(amount2.integralPart == 1200)
        #expect(amount2.fractionalPart == 0)

        let amount3 = try #require(Double("1200.3000000012"))
        #expect(String(describing: amount3) == "1200.3000000012")
        #expect(amount3.integralPart == 1200)
        #expect(amount3.fractionalPart == Double("0.3000000012000328"))
        #expect(amount3.fractionalPart.stringValue == "0.3000000012000328")

        let amount4 = 1200.000000000000000000
        #expect(amount4.integralPart == 1200)
        #expect(amount4.fractionalPart == 0)
    }

    @Test
    func isFractionalPartZero() throws {
        // True
        #expect(1200.isFractionalPartZero == true)
        #expect(1200.00.isFractionalPartZero == true)
        #expect(1200.000000000000000000.isFractionalPartZero == true)

        // False
        #expect(1200.30.isFractionalPartZero == false)
        #expect(try #require(Double("1200.3000000012")).isFractionalPartZero == false)
        #expect(try #require(Double("1200.0000000012")).isFractionalPartZero == false)
    }

    @Test
    func largestRemainderRound() {
        let input = [0.42857, 0.28571, 0.28571]
        let expected = [0.43, 0.29, 0.28]
        #expect(input.largestRemainderRound() == expected)

        #expect(input.sum() == 0.99999)
        #expect(expected.sum() == 1)
    }

    @Test
    func binaryFloatingPointRounded() {
        #expect(1.rounded(fractionDigits: 2) == 1.00)
        #expect(1.rounded() == 1.00)

        #expect(1.09.rounded(.toNearestOrAwayFromZero, fractionDigits: 2) == 1.09)
        #expect(1.09.rounded(.toNearestOrAwayFromZero) == 1.00)

        #expect(1.9.rounded(.toNearestOrAwayFromZero, fractionDigits: 2) == 1.90)
        #expect(1.9.rounded(.toNearestOrAwayFromZero) == 2.00)

        #expect(2.1345.rounded(.toNearestOrAwayFromZero, fractionDigits: 2) == 2.13)
        #expect(2.1345.rounded(.toNearestOrAwayFromZero) == 2.00)

        #expect(2.1355.rounded(.toNearestOrAwayFromZero, fractionDigits: 2) == 2.14)
        #expect(2.1355.rounded(.toNearestOrAwayFromZero) == 2.00)
    }

    @Test("Digits count for BinaryInteger")
    func digitsCount() {
        #expect((0 as Int).digitsCount == 1, "0 should have 1 digit")
        #expect((5 as Int).digitsCount == 1, "5 should have 1 digit")
        #expect((-5 as Int).digitsCount == 1, "-5 should have 1 digit")
        #expect((123 as Int).digitsCount == 3, "123 should have 3 digits")
        #expect((-1234 as Int).digitsCount == 4, "-1234 should have 4 digits")
        #expect((99999 as Int).digitsCount == 5, "99999 should have 5 digits")
        #expect((UInt(54321)).digitsCount == 5, "54321 (UInt) should have 5 digits")
        #expect((Int8(-12)).digitsCount == 2, "-12 (Int8) should have 2 digits")
        #expect((Int.max).digitsCount == 19, "Int.max should have 19 digits") // 9223372036854775807
    }
}
