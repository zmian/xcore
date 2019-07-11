//
// NumbersTests.swift
//
// Copyright © 2019 Xcore
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

import XCTest
@testable import Xcore

final class NumbersTests: TestCase {
    func testRunningSum() {
        let intRunningSum = [1, 1, 1, 1, 1, 1].runningSum()
        let expected1 = [1, 2, 3, 4, 5, 6]
        XCTAssertEqual(intRunningSum, expected1)

        let doubleRunningSum = [1.0, 1, 1, 1, 1, 1].runningSum()
        let expected2 = [1.0, 2, 3, 4, 5, 6]
        XCTAssertEqual(doubleRunningSum, expected2)
    }

    func testSum() {
        let intSum = [1, 1, 1, 1, 1, 1].sum()
        XCTAssertEqual(intSum, 6)

        let doubleSum = [1.0, 1, 1, 1, 1, 1].sum()
        XCTAssertEqual(doubleSum, 6.0)
    }

    func testSumClosure() {
        struct Expense {
            let title: String
            let amount: Double
        }

        let expenses = [
            Expense(title: "Laptop", amount: 1200),
            Expense(title: "Chair", amount: 1000)
        ]

        let totalCost = expenses.sum { $0.amount }
        XCTAssertEqual(totalCost, 2200.0)
    }

    func testAverage() {
        let int = [1, 1, 1, 1, 1, 1].average()
        XCTAssertEqual(int, 1.0)

        let double = [1.0, 1, 1, 1, 1, 1].average()
        XCTAssertEqual(double, 1.0)

        let float: [Float] = [1.0, 1, 1, 1, 1, 1]
        XCTAssertEqual(float.average(), 1.0)

        let float2: [Float] = [1.0, 12.3, 33, 37, 34, 45]
        XCTAssertEqual(float2.average(), 27.050001)

        let decimal: [Decimal] = [1.0, 12.3, 33, 37, 34, 45]
        XCTAssertEqual(decimal.average(), 27.05)
    }

    func testMap() {
        let values = 10.map { $0 * 2 }
        let expected = [2, 4, 6, 8, 10, 12, 14, 16, 18, 20]
        XCTAssertEqual(values, expected)
    }
}
