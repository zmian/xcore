//
// Xcore
// Copyright © 2022 Xcore
// MIT license, see LICENSE file for details
//

import XCTest
@testable import Xcore

final class DoubleOrDecimalTests: TestCase {}

// MARK: - Precision

extension DoubleOrDecimalTests {
    func testDouble_calculatePrecision() {
        XCTAssertEqual(components(Double(1)), Component(range: 2...2, string: "1"))
        XCTAssertEqual(components(Double(1.234)), Component(range: 2...2, string: "1.23"))
        XCTAssertEqual(components(Double(1.000031)), Component(range: 2...2, string: "1"))
        XCTAssertEqual(components(Double(0.00001)), Component(range: 2...6, string: "0.00001"))
        XCTAssertEqual(components(Double(0.000010000)), Component(range: 2...6, string: "0.00001"))
        XCTAssertEqual(components(Double(0.000012)), Component(range: 2...6, string: "0.000012"))
        XCTAssertEqual(components(Double(0.00001243)), Component(range: 2...6, string: "0.000012"))
        XCTAssertEqual(components(Double(0.00001253)), Component(range: 2...6, string: "0.000013"))
        XCTAssertEqual(components(Double(0.00001283)), Component(range: 2...6, string: "0.000013"))
        XCTAssertEqual(components(Double(0.000000138)), Component(range: 2...8, string: "0.00000014"))
    }

    func testDecimal_calculatePrecision() {
        XCTAssertEqual(components(Decimal(1)), Component(range: 2...2, string: "1"))
        XCTAssertEqual(components(Decimal(1.234)), Component(range: 2...2, string: "1.23"))
        XCTAssertEqual(components(Decimal(1.000031)), Component(range: 2...2, string: "1"))
        XCTAssertEqual(components(Decimal(0.00001)), Component(range: 2...6, string: "0.00001"))
        XCTAssertEqual(components(Decimal(0.000010000)), Component(range: 2...6, string: "0.00001"))
        XCTAssertEqual(components(Decimal(0.000012)), Component(range: 2...6, string: "0.000012"))
        XCTAssertEqual(components(Decimal(0.00001243)), Component(range: 2...6, string: "0.000012"))
        XCTAssertEqual(components(Decimal(0.00001253)), Component(range: 2...6, string: "0.000013"))
        XCTAssertEqual(components(Decimal(0.00001283)), Component(range: 2...6, string: "0.000013"))
        XCTAssertEqual(components(Decimal(0.000000138)), Component(range: 2...8, string: "0.00000014"))
        XCTAssertEqual(components(Decimal(string: "-0.0000758574812982132645558836229533068")!), Component(range: 2...6, string: "−0.000076"))
        XCTAssertEqual(components(Decimal(string: "-0.0000758")!), Component(range: 2...6, string: "−0.000076"))
        XCTAssertEqual(components(Decimal(string: "-0.000075")!), Component(range: 2...6, string: "−0.000075"))
    }

    private struct Component: Equatable {
        let range: ClosedRange<Int>
        let string: String
    }

    private func components<V>(_ value: V) -> Component where V: DoubleOrDecimalProtocol {
        Component(
            range: value.calculatePrecision(),
            string: value.formatted(.init(type: .number)
                .fractionLength(value.calculatePrecision()))
        )
    }
}

// MARK: - Double

extension DoubleOrDecimalTests {
    func testDouble() {
        XCTAssertEqual(Double(0.008379).formatted(.asNumber), "0.0084")
        XCTAssertEqual(Double(0.008379).formatted(.asPercent), "0.84%")
        XCTAssertEqual(Double(0.008379).formatted(.asPercent.fractionLength(2)), "0.84%")
        XCTAssertEqual(Double(0.008379).formatted(.asPercent(scale: .zeroToHundred)), "0.0084%")
        XCTAssertEqual(Double(0.008379).formatted(.asPercent(scale: .zeroToHundred).fractionLength(2)), "0.01%")
        XCTAssertEqual(Double(-0.0000758574812982132645558836229533068).formatted(.asPercent), "−0.0076%")
    }

    func testDouble_asNumber() {
        // .asNumber.trimFractionalPartIfZero(true)
        XCTAssertEqual(Double(1).formatted(.asNumber), "1")
        XCTAssertEqual(Double(1.09).formatted(.asNumber), "1.09")
        XCTAssertEqual(Double(1.9).formatted(.asNumber), "1.90")
        XCTAssertEqual(Double(2).formatted(.asNumber), "2")
        XCTAssertEqual(Double(2.1345).formatted(.asNumber), "2.13")
        XCTAssertEqual(Double(2.1355).formatted(.asNumber), "2.14")

        // .asNumber.trimFractionalPartIfZero(false)
        XCTAssertEqual(Double(1).formatted(.asNumber.trimFractionalPartIfZero(false)), "1.00")
        XCTAssertEqual(Double(1.09).formatted(.asNumber.trimFractionalPartIfZero(false)), "1.09")
        XCTAssertEqual(Double(1.9).formatted(.asNumber.trimFractionalPartIfZero(false)), "1.90")
        XCTAssertEqual(Double(2).formatted(.asNumber.trimFractionalPartIfZero(false)), "2.00")
        XCTAssertEqual(Double(2.1345).formatted(.asNumber.trimFractionalPartIfZero(false)), "2.13")
        XCTAssertEqual(Double(2.1355).formatted(.asNumber.trimFractionalPartIfZero(false)), "2.14")

        // .asNumber.trimFractionalPartIfZero(false).sign(.both)
        XCTAssertEqual(Double(0).formatted(.asNumber.sign(.both).trimFractionalPartIfZero(false)), "0.00")
        XCTAssertEqual(Double(1).formatted(.asNumber.sign(.both).trimFractionalPartIfZero(false)), "+1.00")
        XCTAssertEqual(Double(1.09).formatted(.asNumber.sign(.both).trimFractionalPartIfZero(false)), "+1.09")
        XCTAssertEqual(Double(1.9).formatted(.asNumber.sign(.both).trimFractionalPartIfZero(false)), "+1.90")
        XCTAssertEqual(Double(2).formatted(.asNumber.sign(.both).trimFractionalPartIfZero(false)), "+2.00")
        XCTAssertEqual(Double(-2).formatted(.asNumber.sign(.both).trimFractionalPartIfZero(false)), "−2.00")
        XCTAssertEqual(Double(2.1345).formatted(.asNumber.sign(.both).trimFractionalPartIfZero(false)), "+2.13")
        XCTAssertEqual(Double(-2.1355).formatted(.asNumber.sign(.both).trimFractionalPartIfZero(false)), "−2.14")

        // .asNumber.trimFractionalPartIfZero(false).sign(.both).minimumBound
        XCTAssertEqual(Double(0).formatted(.asNumber.minimumBound(1)), "<1")
        XCTAssertEqual(Double(1).formatted(.asNumber.minimumBound(1)), "1")
        XCTAssertEqual(Double(1.09).formatted(.asNumber.sign(.both).minimumBound(5)), "<+5")
        XCTAssertEqual(Double(0.0000109).formatted(.asNumber.fractionLength(.maxFractionDigits)), "0.0000109")
        XCTAssertEqual(Double(-0.0000109).formatted(.asNumber.fractionLength(.maxFractionDigits)), "−0.0000109")
        XCTAssertEqual(Double(-0.0000109).formatted(.asNumber), "−0.000011")
    }

    func testDouble_asPercent_fractionLength() {
        // .asPercent(scale: .zeroToOne).fractionLength(2)
        XCTAssertEqual(Double(1).formatted(.asPercent.fractionLength(2)), "100%")
        XCTAssertEqual(Double(1.09).formatted(.asPercent.fractionLength(2)), "109%")
        XCTAssertEqual(Double(1.9).formatted(.asPercent.fractionLength(2)), "190%")
        XCTAssertEqual(Double(2).formatted(.asPercent.fractionLength(2)), "200%")
        XCTAssertEqual(Double(2.1345).formatted(.asPercent.fractionLength(2)), "213.45%")
        XCTAssertEqual(Double(2.1355).formatted(.asPercent.fractionLength(2)), "213.55%")

        XCTAssertEqual(Double(0.019).formatted(.asPercent.fractionLength(2)), "1.90%")
        XCTAssertEqual(Double(-0.0109).formatted(.asPercent.fractionLength(2)), "−1.09%")
        XCTAssertEqual(Double(0.02).formatted(.asPercent.fractionLength(2)), "2%")
        XCTAssertEqual(Double(1).formatted(.asPercent.fractionLength(2)), "100%")

        // .asPercent(scale: .zeroToHundred).fractionLength(2)
        XCTAssertEqual(Double(1).formatted(.asPercent(scale: .zeroToHundred).fractionLength(2)), "1%")
        XCTAssertEqual(Double(1.09).formatted(.asPercent(scale: .zeroToHundred).fractionLength(2)), "1.09%")
        XCTAssertEqual(Double(1.9).formatted(.asPercent(scale: .zeroToHundred).fractionLength(2)), "1.90%")
        XCTAssertEqual(Double(2).formatted(.asPercent(scale: .zeroToHundred).fractionLength(2)), "2%")
        XCTAssertEqual(Double(2.1345).formatted(.asPercent(scale: .zeroToHundred).fractionLength(2)), "2.13%")
        XCTAssertEqual(Double(2.1355).formatted(.asPercent(scale: .zeroToHundred).fractionLength(2)), "2.14%")
        XCTAssertEqual(Double(0.021355).formatted(.asPercent.fractionLength(2)), "2.14%")
    }

    func testDouble_asPercent() {
        // .asPercent(scale: .zeroToOne)
        XCTAssertEqual(Double(0.019).formatted(.asPercent), "1.90%")
        XCTAssertEqual(Double(-0.0109).formatted(.asPercent), "−1.09%")
        XCTAssertEqual(Double(0.02).formatted(.asPercent), "2%")
        XCTAssertEqual(Double(0.02).formatted(.asPercent.trimFractionalPartIfZero(false)), "2.00%")
        XCTAssertEqual(Double(1).formatted(.asPercent), "100%")

        // .asPercent(scale: .zeroToOne)
        XCTAssertEqual(Double(1).formatted(.asPercent), "100%")
        XCTAssertEqual(Double(1.09).formatted(.asPercent), "109%")
        XCTAssertEqual(Double(1.9).formatted(.asPercent), "190%")
        XCTAssertEqual(Double(2).formatted(.asPercent), "200%")
        XCTAssertEqual(Double(2.1345).formatted(.asPercent), "213.45%")
        XCTAssertEqual(Double(2.1355).formatted(.asPercent), "213.55%")

        // .asPercent(scale: .zeroToHundred)
        XCTAssertEqual(Double(1).formatted(.asPercent(scale: .zeroToHundred)), "1%")
        XCTAssertEqual(Double(1.09).formatted(.asPercent(scale: .zeroToHundred)), "1.09%")
        XCTAssertEqual(Double(1.9).formatted(.asPercent(scale: .zeroToHundred)), "1.90%")
        XCTAssertEqual(Double(2).formatted(.asPercent(scale: .zeroToHundred)), "2%")
        XCTAssertEqual(Double(2.1345).formatted(.asPercent(scale: .zeroToHundred)), "2.13%")
        XCTAssertEqual(Double(2.1355).formatted(.asPercent(scale: .zeroToHundred)), "2.14%")

        // .asPercent(scale: .zeroToOne).fractionLength(0...0)
        XCTAssertEqual(Double(0.019).formatted(.asPercent.fractionLength(0...0)), "2%")
        XCTAssertEqual(Double(-0.0109).formatted(.asPercent.fractionLength(0...0)), "−1%")
        XCTAssertEqual(Double(0.02).formatted(.asPercent.fractionLength(0...0)), "2%")
        XCTAssertEqual(Double(1).formatted(.asPercent.fractionLength(0...0)), "100%")

        // .asPercent(scale: .zeroToOne).fractionLength(0...2)
        XCTAssertEqual(Double(0.019).formatted(.asPercent.fractionLength(0...2)), "1.9%")
        XCTAssertEqual(Double(-0.0109).formatted(.asPercent.fractionLength(0...2)), "−1.09%")
        XCTAssertEqual(Double(0.02).formatted(.asPercent.fractionLength(0...2)), "2%")
        XCTAssertEqual(Double(1).formatted(.asPercent.fractionLength(0...2)), "100%")

        // .asPercent(scale: .zeroToOne).fractionLength(2...2).sign(.both)
        XCTAssertEqual(Double(0).formatted(.asPercent.fractionLength(0...2).sign(.both)), "0%")
        XCTAssertEqual(Double(0.019).formatted(.asPercent.fractionLength(0...2).sign(.both)), "+1.9%")
        XCTAssertEqual(Double(-0.0109).formatted(.asPercent.fractionLength(0...2).sign(.both)), "−1.09%")
        XCTAssertEqual(Double(0.02).formatted(.asPercent.fractionLength(0...2).sign(.both)), "+2%")
        XCTAssertEqual(Double(1).formatted(.asPercent.fractionLength(0...2).sign(.both)), "+100%")

        // .asPercent(scale: .zeroToOne).sign(.both).minimumBound(0.0001)
        XCTAssertEqual(Double(0.019).formatted(.asPercent.sign(.both).minimumBound(0.01)), "+1.90%")
        XCTAssertEqual(Double(-0.0109).formatted(.asPercent.sign(.both).minimumBound(0.01)), "−1.09%")
        XCTAssertEqual(Double(0.02).formatted(.asPercent.sign(.both).minimumBound(0.01)), "+2%")
        XCTAssertEqual(Double(1).formatted(.asPercent.sign(.both).minimumBound(0.01)), "+100%")
        XCTAssertEqual(Double(-0.0000109).formatted(.asPercent.sign(.both).minimumBound(0.0001)), "<−0.01%")
        XCTAssertEqual(Double(0.0000109).formatted(.asPercent.sign(.both).minimumBound(0.0001)), "<+0.01%")
        XCTAssertEqual(Double(-0.0000109).formatted(.asPercent.fractionLength(.maxFractionDigits)), "−0.00109%")
        XCTAssertEqual(Double(0.0000109).formatted(.asPercent.fractionLength(.maxFractionDigits)), "0.00109%")
    }
}

// MARK: - Decimal

extension DoubleOrDecimalTests {
    func testDecimal() {
        XCTAssertEqual(Decimal(0.008379).formatted(.asNumber), "0.0084")
        XCTAssertEqual(Decimal(0.008379).formatted(.asPercent), "0.84%")
        XCTAssertEqual(Decimal(0.008379).formatted(.asPercent.fractionLength(2)), "0.84%")
        XCTAssertEqual(Decimal(0.008379).formatted(.asPercent(scale: .zeroToHundred)), "0.0084%")
        XCTAssertEqual(Decimal(0.008379).formatted(.asPercent(scale: .zeroToHundred).fractionLength(2)), "0.01%")
        XCTAssertEqual(Decimal(string: "-0.0000758574812982132645558836229533068")!.formatted(.asPercent), "−0.0076%")
    }

    func testDecimal_asNumber() {
        // .asNumber.trimFractionalPartIfZero(true)
        XCTAssertEqual(Decimal(1).formatted(.asNumber), "1")
        XCTAssertEqual(Decimal(1.09).formatted(.asNumber), "1.09")
        XCTAssertEqual(Decimal(1.9).formatted(.asNumber), "1.90")
        XCTAssertEqual(Decimal(2).formatted(.asNumber), "2")
        XCTAssertEqual(Decimal(2.1345).formatted(.asNumber), "2.13")
        XCTAssertEqual(Decimal(2.1355).formatted(.asNumber), "2.14")

        // .asNumber.trimFractionalPartIfZero(false)
        XCTAssertEqual(Decimal(1).formatted(.asNumber.trimFractionalPartIfZero(false)), "1.00")
        XCTAssertEqual(Decimal(1.09).formatted(.asNumber.trimFractionalPartIfZero(false)), "1.09")
        XCTAssertEqual(Decimal(1.9).formatted(.asNumber.trimFractionalPartIfZero(false)), "1.90")
        XCTAssertEqual(Decimal(2).formatted(.asNumber.trimFractionalPartIfZero(false)), "2.00")
        XCTAssertEqual(Decimal(2.1345).formatted(.asNumber.trimFractionalPartIfZero(false)), "2.13")
        XCTAssertEqual(Decimal(2.1355).formatted(.asNumber.trimFractionalPartIfZero(false)), "2.14")

        // .asNumber.trimFractionalPartIfZero(false).sign(.both)
        XCTAssertEqual(Decimal(0).formatted(.asNumber.sign(.both).trimFractionalPartIfZero(false)), "0.00")
        XCTAssertEqual(Decimal(1).formatted(.asNumber.sign(.both).trimFractionalPartIfZero(false)), "+1.00")
        XCTAssertEqual(Decimal(1.09).formatted(.asNumber.sign(.both).trimFractionalPartIfZero(false)), "+1.09")
        XCTAssertEqual(Decimal(1.9).formatted(.asNumber.sign(.both).trimFractionalPartIfZero(false)), "+1.90")
        XCTAssertEqual(Decimal(2).formatted(.asNumber.sign(.both).trimFractionalPartIfZero(false)), "+2.00")
        XCTAssertEqual(Decimal(-2).formatted(.asNumber.sign(.both).trimFractionalPartIfZero(false)), "−2.00")
        XCTAssertEqual(Decimal(2.1345).formatted(.asNumber.sign(.both).trimFractionalPartIfZero(false)), "+2.13")
        XCTAssertEqual(Decimal(-2.1355).formatted(.asNumber.sign(.both).trimFractionalPartIfZero(false)), "−2.14")

        // .asNumber.trimFractionalPartIfZero(false).sign(.both).minimumBound
        XCTAssertEqual(Decimal(0).formatted(.asNumber.minimumBound(1)), "<1")
        XCTAssertEqual(Decimal(1).formatted(.asNumber.minimumBound(1)), "1")
        XCTAssertEqual(Decimal(1.09).formatted(.asNumber.sign(.both).minimumBound(5)), "<+5")
        XCTAssertEqual(Decimal(0.0000109).formatted(.asNumber.fractionLength(.maxFractionDigits)), "0.0000109")
        XCTAssertEqual(Decimal(-0.0000109).formatted(.asNumber.fractionLength(.maxFractionDigits)), "−0.0000109")
        XCTAssertEqual(Decimal(-0.0000109).formatted(.asNumber), "−0.000011")
    }

    func testDecimal_asPercent_fractionLength() {
        // .asPercent(scale: .zeroToOne).fractionLength(2)
        XCTAssertEqual(Decimal(1).formatted(.asPercent.fractionLength(2)), "100%")
        XCTAssertEqual(Decimal(1.09).formatted(.asPercent.fractionLength(2)), "109%")
        XCTAssertEqual(Decimal(1.9).formatted(.asPercent.fractionLength(2)), "190%")
        XCTAssertEqual(Decimal(2).formatted(.asPercent.fractionLength(2)), "200%")
        XCTAssertEqual(Decimal(2.1345).formatted(.asPercent.fractionLength(2)), "213.45%")
        XCTAssertEqual(Decimal(2.1355).formatted(.asPercent.fractionLength(2)), "213.55%")

        XCTAssertEqual(Decimal(0.019).formatted(.asPercent.fractionLength(2)), "1.90%")
        XCTAssertEqual(Decimal(-0.0109).formatted(.asPercent.fractionLength(2)), "−1.09%")
        XCTAssertEqual(Decimal(0.02).formatted(.asPercent.fractionLength(2)), "2%")
        XCTAssertEqual(Decimal(1).formatted(.asPercent.fractionLength(2)), "100%")

        // .asPercent(scale: .zeroToHundred).fractionLength(2)
        XCTAssertEqual(Decimal(1).formatted(.asPercent(scale: .zeroToHundred).fractionLength(2)), "1%")
        XCTAssertEqual(Decimal(1.09).formatted(.asPercent(scale: .zeroToHundred).fractionLength(2)), "1.09%")
        XCTAssertEqual(Decimal(1.9).formatted(.asPercent(scale: .zeroToHundred).fractionLength(2)), "1.90%")
        XCTAssertEqual(Decimal(2).formatted(.asPercent(scale: .zeroToHundred).fractionLength(2)), "2%")
        XCTAssertEqual(Decimal(2.1345).formatted(.asPercent(scale: .zeroToHundred).fractionLength(2)), "2.13%")
        XCTAssertEqual(Decimal(2.1355).formatted(.asPercent(scale: .zeroToHundred).fractionLength(2)), "2.14%")
        XCTAssertEqual(Decimal(0.021355).formatted(.asPercent.fractionLength(2)), "2.14%")
    }

    func testDecimal_asPercent() {
        // .asPercent(scale: .zeroToOne)
        XCTAssertEqual(Decimal(0.019).formatted(.asPercent), "1.90%")
        XCTAssertEqual(Decimal(-0.0109).formatted(.asPercent), "−1.09%")
        XCTAssertEqual(Decimal(0.02).formatted(.asPercent), "2%")
        XCTAssertEqual(Decimal(0.02).formatted(.asPercent.trimFractionalPartIfZero(false)), "2.00%")
        XCTAssertEqual(Decimal(1).formatted(.asPercent), "100%")

        // .asPercent(scale: .zeroToOne)
        XCTAssertEqual(Decimal(1).formatted(.asPercent), "100%")
        XCTAssertEqual(Decimal(1.09).formatted(.asPercent), "109%")
        XCTAssertEqual(Decimal(1.9).formatted(.asPercent), "190%")
        XCTAssertEqual(Decimal(2).formatted(.asPercent), "200%")
        XCTAssertEqual(Decimal(2.1345).formatted(.asPercent), "213.45%")
        XCTAssertEqual(Decimal(2.1355).formatted(.asPercent), "213.55%")

        // .asPercent(scale: .zeroToHundred)
        XCTAssertEqual(Decimal(1).formatted(.asPercent(scale: .zeroToHundred)), "1%")
        XCTAssertEqual(Decimal(1.09).formatted(.asPercent(scale: .zeroToHundred)), "1.09%")
        XCTAssertEqual(Decimal(1.9).formatted(.asPercent(scale: .zeroToHundred)), "1.90%")
        XCTAssertEqual(Decimal(2).formatted(.asPercent(scale: .zeroToHundred)), "2%")
        XCTAssertEqual(Decimal(2.1345).formatted(.asPercent(scale: .zeroToHundred)), "2.13%")
        XCTAssertEqual(Decimal(2.1355).formatted(.asPercent(scale: .zeroToHundred)), "2.14%")

        // .asPercent(scale: .zeroToOne).fractionLength(0...0)
        XCTAssertEqual(Decimal(0.019).formatted(.asPercent.fractionLength(0...0)), "2%")
        XCTAssertEqual(Decimal(-0.0109).formatted(.asPercent.fractionLength(0...0)), "−1%")
        XCTAssertEqual(Decimal(0.02).formatted(.asPercent.fractionLength(0...0)), "2%")
        XCTAssertEqual(Decimal(1).formatted(.asPercent.fractionLength(0...0)), "100%")

        // .asPercent(scale: .zeroToOne).fractionLength(0...2)
        XCTAssertEqual(Decimal(0.019).formatted(.asPercent.fractionLength(0...2)), "1.9%")
        XCTAssertEqual(Decimal(-0.0109).formatted(.asPercent.fractionLength(0...2)), "−1.09%")
        XCTAssertEqual(Decimal(0.02).formatted(.asPercent.fractionLength(0...2)), "2%")
        XCTAssertEqual(Decimal(1).formatted(.asPercent.fractionLength(0...2)), "100%")

        // .asPercent(scale: .zeroToOne).fractionLength(2...2).sign(.both)
        XCTAssertEqual(Decimal(0).formatted(.asPercent.fractionLength(0...2).sign(.both)), "0%")
        XCTAssertEqual(Decimal(0.019).formatted(.asPercent.fractionLength(0...2).sign(.both)), "+1.9%")
        XCTAssertEqual(Decimal(-0.0109).formatted(.asPercent.fractionLength(0...2).sign(.both)), "−1.09%")
        XCTAssertEqual(Decimal(0.02).formatted(.asPercent.fractionLength(0...2).sign(.both)), "+2%")
        XCTAssertEqual(Decimal(1).formatted(.asPercent.fractionLength(0...2).sign(.both)), "+100%")

        // .asPercent(scale: .zeroToOne).sign(.both).minimumBound(0.0001)
        XCTAssertEqual(Decimal(0.019).formatted(.asPercent.sign(.both).minimumBound(0.01)), "+1.90%")
        XCTAssertEqual(Decimal(-0.0109).formatted(.asPercent.sign(.both).minimumBound(0.01)), "−1.09%")
        XCTAssertEqual(Decimal(0.02).formatted(.asPercent.sign(.both).minimumBound(0.01)), "+2%")
        XCTAssertEqual(Decimal(1).formatted(.asPercent.sign(.both).minimumBound(0.01)), "+100%")
        XCTAssertEqual(Decimal(-0.0000109).formatted(.asPercent.sign(.both).minimumBound(0.0001)), "<−0.01%")
        XCTAssertEqual(Decimal(0.0000109).formatted(.asPercent.sign(.both).minimumBound(0.0001)), "<+0.01%")
        XCTAssertEqual(Decimal(-0.0000109).formatted(.asPercent.fractionLength(.maxFractionDigits)), "−0.00109%")
        XCTAssertEqual(Decimal(0.0000109).formatted(.asPercent.fractionLength(.maxFractionDigits)), "0.00109%")
    }
}
