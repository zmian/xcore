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
}
