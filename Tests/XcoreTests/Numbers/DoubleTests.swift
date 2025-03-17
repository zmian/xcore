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
}
