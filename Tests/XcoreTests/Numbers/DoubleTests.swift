//
// Xcore
// Copyright © 2019 Xcore
// MIT license, see LICENSE file for details
//

import Testing
import Foundation
@testable import Xcore

struct DoubleTests {
    @Test
    func initAny() {
        #expect(Double(any: "2.5") == 2.5)
        #expect(Double(any: Int(-7)) == -7)
        #expect(Double(any: UInt(7)) == 7)
        #expect(Double(any: CGFloat(2.5)) == 2.5)
        #expect(Double(any: CGFloat(0.07)) == 0.07)
        #expect(Double(any: Double(2.5)) == 2.5)
        #expect(Double(any: Double(0.07)) == 0.07)
        #expect(Double(any: Decimal(0.07)) == 0.07)
        #expect(Double(any: Decimal(315.36)) == 315.36)
        #expect(Double(any: Decimal(9.28)) == 9.28)
        #expect(Double(any: Decimal(0.1736)) == 0.1736)
        #expect(Double(any: Decimal(0.000001466)) == 0.000001466)
    }

    @Test
    func initTruncating() {
        #expect(Double(truncating: Decimal(string: "2.5", locale: .us)!) == 2.5)
        #expect(Double(truncating: Decimal(2.5)) == 2.5)

        #expect(Double(truncating: Decimal(string: "-7", locale: .us)!) == -7)
        #expect(Double(truncating: Decimal(-7)) == -7)

        #expect(Double(truncating: Decimal(string: "0.07", locale: .us)!) != 0.07)
        #expect(Double(truncating: Decimal(0.07)) != 0.07)

        #expect(Double(truncating: Decimal(string: "315.36", locale: .us)!) == 315.36)
        #expect(Double(truncating: Decimal(315.36)) == 315.3600000000001)
        #expect(Double(any: Decimal(315.36)) == 315.36)

        #expect(Double(truncating: Decimal(string: "9.28", locale: .us)!) == 9.28)
        #expect(Double(truncating: Decimal(9.28)) == 9.28)

        #expect(Double(truncating: Decimal(string: "0.1736", locale: .us)!) == 0.1736)
        #expect(Double(truncating: Decimal(0.1736)) == 0.1736)

        #expect(NSDecimalNumber(decimal: Decimal(0.07)).doubleValue == 0.07000000000000003)
        #expect(Double(any: Decimal(string: "0.07", locale: .us)!) == 0.07)
        #expect(Decimal(0.07) == 0.07)
        #expect(NSDecimalNumber(decimal: Decimal(string: "0.07", locale: .us)!).doubleValue == 0.06999999999999999)
        #expect(NSNumber(value: Double(0.07)).doubleValue == 0.07)
        #expect(Double(0.07) == 0.07)

        #expect(Double(truncating: Decimal(string: "0.000001466", locale: .us)!) != 0.000001466)
        #expect(Double(truncating: Decimal(0.000001466)) != 0.000001466)
    }

    @Test
    func formatted() {
        #expect(Double(1).formatted(.number.precision(.fractionLength(2))) == "1.00")
        #expect(Double(1.09).formatted(.number.precision(.fractionLength(2))) == "1.09")
        #expect(Double(1.9).formatted(.number.precision(.fractionLength(2))) == "1.90")
        #expect(Double(1.1345).formatted(.number.precision(.fractionLength(2))) == "1.13")
        #expect(Double(1.1355).formatted(.number.precision(.fractionLength(2))) == "1.14")
        #expect(Double(1.1355).formatted(.number.precision(.fractionLength(3))) == "1.136")

        #expect(Double(9.28).formatted(.number.precision(.fractionLength(3))) == "9.280")
        #expect(Double(0.1736).formatted(.number.precision(.fractionLength(4))) == "0.1736")
        #expect(Double(0.1736).formatted(.number.precision(.fractionLength(2))) == "0.17")
        #expect(Double(0.000001466).formatted(.number.precision(.fractionLength(9))) == "0.000001466")
        #expect(Double(0.000001466).formatted(.number.precision(.fractionLength(8))) == "0.00000147")
        #expect(Double(0.000001466).formatted(.number.precision(.fractionLength(3))) == "0.000")

        // trunc
        #expect(Double(1.1355).formatted(.number.precision(.fractionLength(3)).rounded(rule: .towardZero)) == "1.135")
    }

    @Test
    func abbreviated() {
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
            (120_000.0, "120K"),
            (1_200_000.0, "1.2M"),
            (1340.0, "1.34K"),
            (132_456.0, "132.46K"),
            (132_456.80, "132.46K"),
            (1_116_400_000.00, "1.12B")
        ]

        for (input, output) in values1 {
            #expect(output == input.formatted(.asAbbreviated))
        }

        let values2: [(Double, String)] = [
            (598, "598"),
            (987, "987"),
            (-999, "−999"),
            // K
            (1000, "1K"),
            (-1284, "−1.3K"),
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
            (-10, "−10"),
            (500, "500"),
            (999, "999"),
            (1000, "1K"),
            (1234, "1.2K"),
            (9000, "9K"),
            (10_000, "10K"),
            (-10_000, "−10K"),
            (15_235, "15.2K"),
            (-15_235, "−15.2K"),
            (99_500, "99.5K"),
            (-99_500, "−99.5K"),
            (100_500, "100.5K"),
            (-100_500, "−100.5K"),
            (105_000_000, "105M"),
            (-105_000_000, "−105M"),
            (140_800_200_000, "140.8B"),
            (170_400_800_000_000, "170.4T"),
            (-170_400_800_000_000, "−170.4T"),
            (-9_223_372_036_854_775_808, "−9,223,372T"),
            (Double(Int.max), "9,223,372T")
        ]

        for (input, output) in values2 {
            #expect(output == input.formatted(.asAbbreviated.fractionLength(0...1)))
        }
    }

    @Test
    func abbreviatedThreshold() {
        let values: [(Double, String)] = [
            (315.36, "315.36"),
            (1_000_000, "1,000,000"),
            (9000, "9,000"),
            (105_000_000, "105M"),
            (140_800_200_000, "140.8B"),
            (170_400_800_000_000, "170.4T"),
            (-170_400_800_000_000, "−170.4T"),
            (-9_223_372_036_854_775_808, "−9,223,372T")
        ]

        for (input, output) in values {
            #expect(output == input.formatted(.asAbbreviated(threshold: 2_000_000).fractionLength(0...1)))
        }
    }

    @Test
    func abbreviatedLocale() {
        // Tr
        let valuesTr: [(Double, String)] = [
            (105_000_000, "105M"),
            (140_800_200_000, "140,8B"),
            (170_400_800_000_000, "170,4T"),
            (-170_400_800_000_000, "−170,4T"),
            (-9_223_372_036_854_775_808, "−9.223.372,04T")
        ]

        for (input, output) in valuesTr {
            #expect(output == input.formatted(.asAbbreviated.locale(.tr)))
        }

        // Fr
        let valuesFr: [(Double, String)] = [
            (105_000_000, "105M"),
            (140_800_200_000, "140,8B"),
            (170_400_800_000_000, "170,4T"),
            (-170_400_800_000_000, "−170,4T"),
            (-9_223_372_036_854_775_808, "−9 223 372T")
        ]

        for (input, output) in valuesFr {
            #expect(output == input.formatted(.asAbbreviated.locale(.fr).fractionLength(0...1)))
        }
    }
}
