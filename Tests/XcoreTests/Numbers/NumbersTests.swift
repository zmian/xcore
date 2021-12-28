//
// Xcore
// Copyright © 2019 Xcore
// MIT license, see LICENSE file for details
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

    func testDoubleInit() {
        XCTAssertEqual(Double("2.5" as Any), 2.5)
        XCTAssertEqual(Double(Int(-7) as Any), -7)
        XCTAssertEqual(Double(UInt(7) as Any), 7)
        XCTAssertEqual(Double(CGFloat(2.5) as Any), 2.5)
        XCTAssertEqual(Double(CGFloat(0.07) as Any), 0.07)
        XCTAssertEqual(Double(Double(2.5) as Any), 2.5)
        XCTAssertEqual(Double(Double(0.07) as Any), 0.07)
        XCTAssertEqual(Double(Decimal(0.07) as Any), 0.07)
        XCTAssertEqual(Double(Decimal(315.36) as Any), 315.36)
        XCTAssertEqual(Double(Decimal(9.28) as Any), 9.28)
        XCTAssertEqual(Double(Decimal(0.1736) as Any), 0.1736)
        XCTAssertEqual(Double(Decimal(0.000001466) as Any), 0.000001466)
    }

    func testDouble_formatted() {
        XCTAssertEqual(Double(1).formatted(fractionDigits: 2), "1.00")
        XCTAssertEqual(Double(1.09).formatted(fractionDigits: 2), "1.09")
        XCTAssertEqual(Double(1.9).formatted(fractionDigits: 2), "1.90")
        XCTAssertEqual(Double(1.1345).formatted(fractionDigits: 2), "1.13")
        XCTAssertEqual(Double(1.1355).formatted(fractionDigits: 2), "1.14")
        XCTAssertEqual(Double(1.1355).formatted(fractionDigits: 3), "1.136")

        XCTAssertEqual(Double(9.28).formatted(fractionDigits: 3), "9.280")
        XCTAssertEqual(Double(0.1736).formatted(fractionDigits: 4), "0.1736")
        XCTAssertEqual(Double(0.1736).formatted(fractionDigits: 2), "0.17")
        XCTAssertEqual(Double(0.000001466).formatted(fractionDigits: 9), "0.000001466")
        XCTAssertEqual(Double(0.000001466).formatted(fractionDigits: 8), "0.00000147")
        XCTAssertEqual(Double(0.000001466).formatted(fractionDigits: 3), "0.000")

        // trunc
        XCTAssertEqual(Double(1.1355).formatted(.towardZero, fractionDigits: 3), "1.135")
    }

    func testAbbreviate() {
        let values1: [(Double, String)] = [
            (0.000001466, "0.000001466"),
            (0.000001566, "0.000001566"),
            (0.01466, "0.01466"),
            (0.241341466, "0.241341466"),
            (0.1736, "0.1736"),
            (9.28, "9.28"),
            (0.07, "0.07"),
            (315.36, "315.36"),
            (987, "987"),
            (1200.0, "1.2K"),
            (12000.0, "12K"),
            (120000.0, "120K"),
            (1200000.0, "1.2M"),
            (1340.0, "1.3K"),
            (132456.0, "132.5K"),
            (132456.80, "132.5K"),
            (1_116_400_000.00, "1.1B")
        ]

        for (input, output) in values1 {
            XCTAssertEqual(output, input.abbreviate())
        }

        let values2: [(Double, String)] = [
            (598, "598"),
            (987, "987"),
            (-999, "-999"),
            // K
            (1000, "1K"),
            (-1284, "-1.3K"),
            (1200, "1.2K"),
            (1340, "1.3K"),
            (9940, "9.9K"),
            (9980, "10K"),
            (12000, "12K"),
            (39900, "39.9K"),
            (99880, "99.9K"),
            (120_000, "120K"),
            (132_456, "132.5K"),
            (399_880, "399.9K"),
            // M
            (999_898, "1M"),
            (999_999, "1M"),
            (1_200_000, "1.2M"),
            (1_456_384, "1.5M"),
            (12_383_474, "12.4M"),
            (16_000_000, "16M"),
            (999_000_000, "999M"),
            (160_000_000, "160M"),
            // B
            (9_000_000_000, "9B"),
            (90_000_000_000, "90B"),
            (900_000_000_000, "900B"),
            (999_000_000_000, "999B"),
            // T
            (1_000_000_000_000, "1T"),
            (1_200_000_000_000, "1.2T"),
            (3_000_000_000_000, "3T"),
            (9_000_000_000_000, "9T"),
            (90_000_000_000_000, "90T"),
            (900_000_000_000_000, "900T"),
            (999_000_000_000_000, "999T"),
            // Other
            (0, "0"),
            (-10, "-10"),
            (500, "500"),
            (999, "999"),
            (1000, "1K"),
            (1234, "1.2K"),
            (9000, "9K"),
            (10_000, "10K"),
            (-10_000, "-10K"),
            (15_235, "15.2K"),
            (-15_235, "-15.2K"),
            (99_500, "99.5K"),
            (-99_500, "-99.5K"),
            (100_500, "100.5K"),
            (-100_500, "-100.5K"),
            (105_000_000, "105M"),
            (-105_000_000, "-105M"),
            (140_800_200_000, "140.8B"),
            (170_400_800_000_000, "170.4T"),
            (-170_400_800_000_000, "-170.4T"),
            (-9_223_372_036_854_775_808, "-9,223,372T"),
            (Double(Int.max), "9,223,372T")
        ]

        for (input, output) in values2 {
            XCTAssertEqual(output, input.abbreviate())
        }
    }

    func testAbbreviateThreshold() {
        let values: [(Double, String)] = [
            (315.36, "315.36"),
            (1_000_000, "1,000,000"),
            (9000, "9,000"),
            (105_000_000, "105M"),
            (140_800_200_000, "140.8B"),
            (170_400_800_000_000, "170.4T"),
            (-170_400_800_000_000, "-170.4T"),
            (-9_223_372_036_854_775_808, "-9,223,372T")
        ]

        for (input, output) in values {
            XCTAssertEqual(output, input.abbreviate(threshold: 2_000_000))
        }
    }

    func testAbbreviateLocale() {
        // Tr
        let valuesTr: [(Double, String)] = [
            (105_000_000, "105M"),
            (140_800_200_000, "140,8B"),
            (170_400_800_000_000, "170,4T"),
            (-170_400_800_000_000, "-170,4T"),
            (-9_223_372_036_854_775_808, "-9.223.372T")
        ]

        for (input, output) in valuesTr {
            XCTAssertEqual(output, input.abbreviate(locale: .tr))
        }

        // Fr
        let valuesFr: [(Double, String)] = [
            (105_000_000, "105M"),
            (140_800_200_000, "140,8B"),
            (170_400_800_000_000, "170,4T"),
            (-170_400_800_000_000, "-170,4T"),
            (-9_223_372_036_854_775_808, "-9 223 372T")
        ]

        for (input, output) in valuesFr {
            XCTAssertEqual(output, input.abbreviate(locale: .fr))
        }
    }
}
