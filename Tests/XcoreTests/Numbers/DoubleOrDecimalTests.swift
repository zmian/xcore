//
// Xcore
// Copyright © 2022 Xcore
// MIT license, see LICENSE file for details
//

import Testing
import Foundation
@testable import Xcore

@Suite
struct DoubleOrDecimalTests {}

// MARK: - Precision

extension DoubleOrDecimalTests {
    @Test
    func double_calculatePrecision() {
        #expect(components(Double(1)) == Component(range: 2...2, string: "1"))
        #expect(components(Double(1.234)) == Component(range: 2...2, string: "1.23"))
        #expect(components(Double(1.000031)) == Component(range: 2...2, string: "1"))
        #expect(components(Double(0.00001)) == Component(range: 2...6, string: "0.00001"))
        #expect(components(Double(0.000010000)) == Component(range: 2...6, string: "0.00001"))
        #expect(components(Double(0.000012)) == Component(range: 2...6, string: "0.000012"))
        #expect(components(Double(0.00001243)) == Component(range: 2...6, string: "0.000012"))
        #expect(components(Double(0.00001253)) == Component(range: 2...6, string: "0.000013"))
        #expect(components(Double(0.00001283)) == Component(range: 2...6, string: "0.000013"))
        #expect(components(Double(0.000000138)) == Component(range: 2...8, string: "0.00000014"))
    }

    @Test
    func decimal_calculatePrecision() {
        #expect(components(Decimal(1)) == Component(range: 2...2, string: "1"))
        #expect(components(Decimal(1.234)) == Component(range: 2...2, string: "1.23"))
        #expect(components(Decimal(1.000031)) == Component(range: 2...2, string: "1"))
        #expect(components(Decimal(0.00001)) == Component(range: 2...6, string: "0.00001"))
        #expect(components(Decimal(0.000010000)) == Component(range: 2...6, string: "0.00001"))
        #expect(components(Decimal(0.000012)) == Component(range: 2...6, string: "0.000012"))
        #expect(components(Decimal(0.00001243)) == Component(range: 2...6, string: "0.000012"))
        #expect(components(Decimal(0.00001253)) == Component(range: 2...6, string: "0.000013"))
        #expect(components(Decimal(0.00001283)) == Component(range: 2...6, string: "0.000013"))
        #expect(components(Decimal(0.000000138)) == Component(range: 2...8, string: "0.00000014"))
        #expect(components(Decimal(string: "-0.0000758574812982132645558836229533068")!) == Component(range: 2...6, string: "−0.000076"))
        #expect(components(Decimal(string: "-0.0000758")!) == Component(range: 2...6, string: "−0.000076"))
        #expect(components(Decimal(string: "-0.000075")!) == Component(range: 2...6, string: "−0.000075"))
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
    @Test
    func double() {
        #expect(Double("20.05588")!.formatted(.asNumber) == "20.05588")
        #expect(Double("5.04198")!.formatted(.asNumber) == "5.04198")
        #expect(Double(5.04198).formatted(.asNumber) == "5.04198")

        #expect(Double(0.008379).formatted(.asNumber) == "0.008379")
        #expect(Double(0.008379).formatted(.asRounded) == "0.0084")
        #expect(Double(0.008379).formatted(.asPercent) == "0.84%")
        #expect(Double(0.008379).formatted(.asPercent.fractionLength(2)) == "0.84%")
        #expect(Double(0.008379).formatted(.asPercent(scale: .zeroToHundred)) == "0.0084%")
        #expect(Double(0.008379).formatted(.asPercent(scale: .zeroToHundred).fractionLength(2)) == "0.01%")
        #expect(Double(-0.0000758574812982132645558836229533068).formatted(.asPercent) == "−0.0076%")
    }

    @Test
    func double_locale() {
        #expect(Double(290_900.05588).formatted(.asNumber) == "290,900.05588")
        #expect(Double(290_900.05588).formatted(.asNumber.locale(.fr)) == "290 900,05588")
        #expect(Double(0.019).formatted(.asPercent.locale(.fr)) == "1,90 %")
        #expect(Double(0.02).formatted(.asPercent.locale(.ar)) == "٢٫٠٠٪؜")
    }

    @Test
    func double_asNumber() {
        // .asNumber.trimFractionalPartIfZero(true)
        #expect(Double(1).formatted(.asNumber) == "1")
        #expect(Double(1.09).formatted(.asNumber) == "1.09")
        #expect(Double(1.9).formatted(.asNumber) == "1.9")
        #expect(Double(2).formatted(.asNumber) == "2")
        #expect(Double(2.1345).formatted(.asNumber) == "2.1345")
        #expect(Double(2.1355).formatted(.asNumber) == "2.1355")
        #expect(Double(20024.1355).formatted(.asNumber) == "20,024.1355")

        // .asNumber.trimFractionalPartIfZero(false)
        #expect(Double(1).formatted(.asNumber.trimFractionalPartIfZero(false).fractionLength(2)) == "1.00")
        #expect(Double(1.09).formatted(.asNumber.trimFractionalPartIfZero(false)) == "1.09")
        #expect(Double(1.9).formatted(.asNumber.trimFractionalPartIfZero(false).fractionLength(2)) == "1.90")
        #expect(Double(2).formatted(.asNumber.trimFractionalPartIfZero(false).fractionLength(2)) == "2.00")
        #expect(Double(2.1345).formatted(.asNumber.trimFractionalPartIfZero(false)) == "2.1345")
        #expect(Double(2.1355).formatted(.asNumber.trimFractionalPartIfZero(false)) == "2.1355")

        // .asNumber.trimFractionalPartIfZero(false).signSymbols(.both)
        #expect(Double(0).formatted(.asNumber.signSymbols(.both).trimFractionalPartIfZero(false).fractionLength(2)) == "0.00")
        #expect(Double(1).formatted(.asNumber.signSymbols(.both).trimFractionalPartIfZero(false).fractionLength(2)) == "+1.00")
        #expect(Double(1.09).formatted(.asNumber.signSymbols(.both).trimFractionalPartIfZero(false).fractionLength(2)) == "+1.09")
        #expect(Double(1.9).formatted(.asNumber.signSymbols(.both).trimFractionalPartIfZero(false).fractionLength(2)) == "+1.90")
        #expect(Double(2).formatted(.asNumber.signSymbols(.both).trimFractionalPartIfZero(false).fractionLength(2)) == "+2.00")
        #expect(Double(-2).formatted(.asNumber.signSymbols(.both).trimFractionalPartIfZero(false).fractionLength(2)) == "−2.00")
        #expect(Double(2.1345).formatted(.asNumber.signSymbols(.both).trimFractionalPartIfZero(false)) == "+2.1345")
        #expect(Double(-2.1355).formatted(.asNumber.signSymbols(.both).trimFractionalPartIfZero(false)) == "−2.1355")

        // .asNumber.trimFractionalPartIfZero(false).signSymbols(.both).minimumBound
        #expect(Double(0).formatted(.asNumber.minimumBound(1)) == "<1")
        #expect(Double(1).formatted(.asNumber.minimumBound(1)) == "1")
        #expect(Double(1.09).formatted(.asNumber.signSymbols(.both).minimumBound(5)) == "<+5")
        #expect(Double(0.0000109).formatted(.asNumber.fractionLength(.maxFractionDigits)) == "0.0000109")
        #expect(Double(-0.0000109).formatted(.asNumber.fractionLength(.maxFractionDigits)) == "−0.0000109")
        #expect(Double(-0.0000109).formatted(.asNumber) == "−0.0000109")
    }

    @Test
    func double_asRounded() {
        // .asRounded.trimFractionalPartIfZero(true)
        #expect(Double(1).formatted(.asRounded) == "1")
        #expect(Double(1.09).formatted(.asRounded) == "1.09")
        #expect(Double(1.9).formatted(.asRounded) == "1.90")
        #expect(Double(2).formatted(.asRounded) == "2")
        #expect(Double(2.1345).formatted(.asRounded) == "2.13")
        #expect(Double(2.1355).formatted(.asRounded) == "2.14")
        #expect(Double(20024.1355).formatted(.asRounded) == "20,024.14")

        // .asRounded.trimFractionalPartIfZero(false)
        #expect(Double(1).formatted(.asRounded.trimFractionalPartIfZero(false)) == "1.00")
        #expect(Double(1.09).formatted(.asRounded.trimFractionalPartIfZero(false)) == "1.09")
        #expect(Double(1.9).formatted(.asRounded.trimFractionalPartIfZero(false)) == "1.90")
        #expect(Double(2).formatted(.asRounded.trimFractionalPartIfZero(false)) == "2.00")
        #expect(Double(2.1345).formatted(.asRounded.trimFractionalPartIfZero(false)) == "2.13")
        #expect(Double(2.1355).formatted(.asRounded.trimFractionalPartIfZero(false)) == "2.14")

        // .asRounded.trimFractionalPartIfZero(false).signSymbols(.both)
        #expect(Double(0).formatted(.asRounded.signSymbols(.both).trimFractionalPartIfZero(false)) == "0.00")
        #expect(Double(1).formatted(.asRounded.signSymbols(.both).trimFractionalPartIfZero(false)) == "+1.00")
        #expect(Double(1.09).formatted(.asRounded.signSymbols(.both).trimFractionalPartIfZero(false)) == "+1.09")
        #expect(Double(1.9).formatted(.asRounded.signSymbols(.both).trimFractionalPartIfZero(false)) == "+1.90")
        #expect(Double(2).formatted(.asRounded.signSymbols(.both).trimFractionalPartIfZero(false)) == "+2.00")
        #expect(Double(-2).formatted(.asRounded.signSymbols(.both).trimFractionalPartIfZero(false)) == "−2.00")
        #expect(Double(2.1345).formatted(.asRounded.signSymbols(.both).trimFractionalPartIfZero(false)) == "+2.13")
        #expect(Double(-2.1355).formatted(.asRounded.signSymbols(.both).trimFractionalPartIfZero(false)) == "−2.14")

        // .asRounded.trimFractionalPartIfZero(false).signSymbols(.both).minimumBound
        #expect(Double(0).formatted(.asRounded.minimumBound(1)) == "<1")
        #expect(Double(1).formatted(.asRounded.minimumBound(1)) == "1")
        #expect(Double(1.09).formatted(.asRounded.signSymbols(.both).minimumBound(5)) == "<+5")
        #expect(Double(0.0000109).formatted(.asRounded.fractionLength(.maxFractionDigits)) == "0.0000109")
        #expect(Double(-0.0000109).formatted(.asRounded.fractionLength(.maxFractionDigits)) == "−0.0000109")
        #expect(Double(-0.0000109).formatted(.asRounded) == "−0.000011")
    }

    @Test
    func double_asPercent_fractionLength() {
        // .asPercent(scale: .zeroToOne).fractionLength(2)
        #expect(Double(1).formatted(.asPercent.fractionLength(2)) == "100%")
        #expect(Double(1.09).formatted(.asPercent.fractionLength(2)) == "109%")
        #expect(Double(1.9).formatted(.asPercent.fractionLength(2)) == "190%")
        #expect(Double(2).formatted(.asPercent.fractionLength(2)) == "200%")
        #expect(Double(2.1345).formatted(.asPercent.fractionLength(2)) == "213.45%")
        #expect(Double(2.1355).formatted(.asPercent.fractionLength(2)) == "213.55%")

        #expect(Double(0.019).formatted(.asPercent.fractionLength(2)) == "1.90%")
        #expect(Double(-0.0109).formatted(.asPercent.fractionLength(2)) == "−1.09%")
        #expect(Double(0.02).formatted(.asPercent.fractionLength(2)) == "2%")
        #expect(Double(1).formatted(.asPercent.fractionLength(2)) == "100%")

        // .asPercent(scale: .zeroToHundred).fractionLength(2)
        #expect(Double(1).formatted(.asPercent(scale: .zeroToHundred).fractionLength(2)) == "1%")
        #expect(Double(1.09).formatted(.asPercent(scale: .zeroToHundred).fractionLength(2)) == "1.09%")
        #expect(Double(1.9).formatted(.asPercent(scale: .zeroToHundred).fractionLength(2)) == "1.90%")
        #expect(Double(2).formatted(.asPercent(scale: .zeroToHundred).fractionLength(2)) == "2%")
        #expect(Double(2.1345).formatted(.asPercent(scale: .zeroToHundred).fractionLength(2)) == "2.13%")
        #expect(Double(2.1355).formatted(.asPercent(scale: .zeroToHundred).fractionLength(2)) == "2.14%")
        #expect(Double(0.021355).formatted(.asPercent.fractionLength(2)) == "2.14%")
    }

    @Test
    func double_asPercent() {
        // .asPercent(scale: .zeroToOne)
        #expect(Double(0.019).formatted(.asPercent) == "1.90%")
        #expect(Double(-0.0109).formatted(.asPercent) == "−1.09%")
        #expect(Double(0.02).formatted(.asPercent) == "2%")
        #expect(Double(0.02).formatted(.asPercent.trimFractionalPartIfZero(false)) == "2.00%")
        #expect(Double(1).formatted(.asPercent) == "100%")

        // .asPercent(scale: .zeroToOne)
        #expect(Double(1).formatted(.asPercent) == "100%")
        #expect(Double(1.09).formatted(.asPercent) == "109%")
        #expect(Double(1.9).formatted(.asPercent) == "190%")
        #expect(Double(2).formatted(.asPercent) == "200%")
        #expect(Double(2.1345).formatted(.asPercent) == "213.45%")
        #expect(Double(2.1355).formatted(.asPercent) == "213.55%")

        // .asPercent(scale: .zeroToHundred)
        #expect(Double(1).formatted(.asPercent(scale: .zeroToHundred)) == "1%")
        #expect(Double(1.09).formatted(.asPercent(scale: .zeroToHundred)) == "1.09%")
        #expect(Double(1.9).formatted(.asPercent(scale: .zeroToHundred)) == "1.90%")
        #expect(Double(2).formatted(.asPercent(scale: .zeroToHundred)) == "2%")
        #expect(Double(2.1345).formatted(.asPercent(scale: .zeroToHundred)) == "2.13%")
        #expect(Double(2.1355).formatted(.asPercent(scale: .zeroToHundred)) == "2.14%")

        // .asPercent(scale: .zeroToOne).fractionLength(0...0)
        #expect(Double(0.019).formatted(.asPercent.fractionLength(0...0)) == "2%")
        #expect(Double(-0.0109).formatted(.asPercent.fractionLength(0...0)) == "−1%")
        #expect(Double(0.02).formatted(.asPercent.fractionLength(0...0)) == "2%")
        #expect(Double(1).formatted(.asPercent.fractionLength(0...0)) == "100%")

        // .asPercent(scale: .zeroToOne).fractionLength(0...2)
        #expect(Double(0.019).formatted(.asPercent.fractionLength(0...2)) == "1.9%")
        #expect(Double(-0.0109).formatted(.asPercent.fractionLength(0...2)) == "−1.09%")
        #expect(Double(0.02).formatted(.asPercent.fractionLength(0...2)) == "2%")
        #expect(Double(1).formatted(.asPercent.fractionLength(0...2)) == "100%")

        // .asPercent(scale: .zeroToOne).fractionLength(2...2).signSymbols(.both)
        #expect(Double(0).formatted(.asPercent.fractionLength(0...2).signSymbols(.both)) == "0%")
        #expect(Double(0.019).formatted(.asPercent.fractionLength(0...2).signSymbols(.both)) == "+1.9%")
        #expect(Double(-0.0109).formatted(.asPercent.fractionLength(0...2).signSymbols(.both)) == "−1.09%")
        #expect(Double(0.02).formatted(.asPercent.fractionLength(0...2).signSymbols(.both)) == "+2%")
        #expect(Double(1).formatted(.asPercent.fractionLength(0...2).signSymbols(.both)) == "+100%")

        // .asPercent(scale: .zeroToOne).signSymbols(.both).minimumBound(0.0001)
        #expect(Double(0.019).formatted(.asPercent.signSymbols(.both).minimumBound(0.01)) == "+1.90%")
        #expect(Double(-0.0109).formatted(.asPercent.signSymbols(.both).minimumBound(0.01)) == "−1.09%")
        #expect(Double(0.02).formatted(.asPercent.signSymbols(.both).minimumBound(0.01)) == "+2%")
        #expect(Double(1).formatted(.asPercent.signSymbols(.both).minimumBound(0.01)) == "+100%")
        #expect(Double(-0.0000109).formatted(.asPercent.signSymbols(.both).minimumBound(0.0001)) == "<−0.01%")
        #expect(Double(0.0000109).formatted(.asPercent.signSymbols(.both).minimumBound(0.0001)) == "<+0.01%")
        #expect(Double(-0.0000109).formatted(.asPercent.fractionLength(.maxFractionDigits)) == "−0.00109%")
        #expect(Double(0.0000109).formatted(.asPercent.fractionLength(.maxFractionDigits)) == "0.00109%")
    }
}

// MARK: - Decimal

extension DoubleOrDecimalTests {
    @Test
    func decimal() {
        #expect(Decimal(string: "20.05588")!.formatted(.asNumber) == "20.05588")
        #expect(Decimal(string: "5.04198")!.formatted(.asNumber) == "5.04198")
        #expect(Decimal(5.04198).formatted(.asNumber) == "5.04198")

        #expect(Decimal(string: "0.008379")!.formatted(.asNumber) == "0.008379")
        #expect(Decimal(0.008379).formatted(.asRounded) == "0.0084")
        #expect(Decimal(0.008379).formatted(.asPercent) == "0.84%")
        #expect(Decimal(0.008379).formatted(.asPercent.fractionLength(2)) == "0.84%")
        #expect(Decimal(0.008379).formatted(.asPercent(scale: .zeroToHundred)) == "0.0084%")
        #expect(Decimal(0.008379).formatted(.asPercent(scale: .zeroToHundred).fractionLength(2)) == "0.01%")
        #expect(Decimal(string: "-0.0000758574812982132645558836229533068")!.formatted(.asPercent) == "−0.0076%")
    }

    @Test
    func decimal_locale() {
        #expect(Decimal(string: "290900.05588")!.formatted(.asNumber) == "290,900.05588")
        #expect(Decimal(string: "290900.05588")!.formatted(.asNumber.locale(.fr)) == "290 900,05588")
        #expect(Decimal(0.019).formatted(.asPercent.locale(.fr)) == "1,90 %")
        #expect(Decimal(0.02).formatted(.asPercent.locale(.ar)) == "٢٫٠٠٪؜")
    }

    @Test
    func decimal_asNumber() {
        // .asNumber.trimFractionalPartIfZero(true)
        #expect(Decimal(1).formatted(.asNumber) == "1")
        #expect(Decimal(1.09).formatted(.asNumber) == "1.09")
        #expect(Decimal(1.9).formatted(.asNumber) == "1.9")
        #expect(Decimal(2).formatted(.asNumber) == "2")
        #expect(Decimal(2.1345).formatted(.asNumber) == "2.1345")
        #expect(Decimal(2.1355).formatted(.asNumber) == "2.1355")
        #expect(Decimal(string: "20024.1355")!.formatted(.asNumber) == "20,024.1355")

        // .asNumber.trimFractionalPartIfZero(false)
        #expect(Decimal(1).formatted(.asNumber.trimFractionalPartIfZero(false).fractionLength(2)) == "1.00")
        #expect(Decimal(1.09).formatted(.asNumber.trimFractionalPartIfZero(false)) == "1.09")
        #expect(Decimal(1.9).formatted(.asNumber.trimFractionalPartIfZero(false).fractionLength(2)) == "1.90")
        #expect(Decimal(2).formatted(.asNumber.trimFractionalPartIfZero(false).fractionLength(2)) == "2.00")
        #expect(Decimal(2.1345).formatted(.asNumber.trimFractionalPartIfZero(false)) == "2.1345")
        #expect(Decimal(2.1355).formatted(.asNumber.trimFractionalPartIfZero(false)) == "2.1355")

        // .asNumber.trimFractionalPartIfZero(false).signSymbols(.both)
        #expect(Decimal(0).formatted(.asNumber.signSymbols(.both).trimFractionalPartIfZero(false).fractionLength(2)) == "0.00")
        #expect(Decimal(1).formatted(.asNumber.signSymbols(.both).trimFractionalPartIfZero(false).fractionLength(2)) == "+1.00")
        #expect(Decimal(1.09).formatted(.asNumber.signSymbols(.both).trimFractionalPartIfZero(false).fractionLength(2)) == "+1.09")
        #expect(Decimal(1.9).formatted(.asNumber.signSymbols(.both).trimFractionalPartIfZero(false).fractionLength(2)) == "+1.90")
        #expect(Decimal(2).formatted(.asNumber.signSymbols(.both).trimFractionalPartIfZero(false).fractionLength(2)) == "+2.00")
        #expect(Decimal(-2).formatted(.asNumber.signSymbols(.both).trimFractionalPartIfZero(false).fractionLength(2)) == "−2.00")
        #expect(Decimal(2.1345).formatted(.asNumber.signSymbols(.both).trimFractionalPartIfZero(false)) == "+2.1345")
        #expect(Decimal(-2.1355).formatted(.asNumber.signSymbols(.both).trimFractionalPartIfZero(false)) == "−2.1355")

        // .asNumber.trimFractionalPartIfZero(false).signSymbols(.both).minimumBound
        #expect(Decimal(0).formatted(.asNumber.minimumBound(1)) == "<1")
        #expect(Decimal(1).formatted(.asNumber.minimumBound(1)) == "1")
        #expect(Decimal(1.09).formatted(.asNumber.signSymbols(.both).minimumBound(5)) == "<+5")
        #expect(Decimal(0.0000109).formatted(.asNumber.fractionLength(.maxFractionDigits)) == "0.0000109")
        #expect(Decimal(-0.0000109).formatted(.asNumber.fractionLength(.maxFractionDigits)) == "−0.0000109")
        #expect(Decimal(-0.0000109).formatted(.asNumber) == "−0.0000109")
    }

    @Test
    func decimal_asRounded() {
        // .asRounded.trimFractionalPartIfZero(true)
        #expect(Decimal(1).formatted(.asRounded) == "1")
        #expect(Decimal(1.09).formatted(.asRounded) == "1.09")
        #expect(Decimal(1.9).formatted(.asRounded) == "1.90")
        #expect(Decimal(2).formatted(.asRounded) == "2")
        #expect(Decimal(2.1345).formatted(.asRounded) == "2.13")
        #expect(Decimal(2.1355).formatted(.asRounded) == "2.14")
        #expect(Decimal(20024.1355).formatted(.asRounded) == "20,024.14")

        // .asRounded.trimFractionalPartIfZero(false)
        #expect(Decimal(1).formatted(.asRounded.trimFractionalPartIfZero(false)) == "1.00")
        #expect(Decimal(1.09).formatted(.asRounded.trimFractionalPartIfZero(false)) == "1.09")
        #expect(Decimal(1.9).formatted(.asRounded.trimFractionalPartIfZero(false)) == "1.90")
        #expect(Decimal(2).formatted(.asRounded.trimFractionalPartIfZero(false)) == "2.00")
        #expect(Decimal(2.1345).formatted(.asRounded.trimFractionalPartIfZero(false)) == "2.13")
        #expect(Decimal(2.1355).formatted(.asRounded.trimFractionalPartIfZero(false)) == "2.14")

        // .asRounded.trimFractionalPartIfZero(false).signSymbols(.both)
        #expect(Decimal(0).formatted(.asRounded.signSymbols(.both).trimFractionalPartIfZero(false)) == "0.00")
        #expect(Decimal(1).formatted(.asRounded.signSymbols(.both).trimFractionalPartIfZero(false)) == "+1.00")
        #expect(Decimal(1.09).formatted(.asRounded.signSymbols(.both).trimFractionalPartIfZero(false)) == "+1.09")
        #expect(Decimal(1.9).formatted(.asRounded.signSymbols(.both).trimFractionalPartIfZero(false)) == "+1.90")
        #expect(Decimal(2).formatted(.asRounded.signSymbols(.both).trimFractionalPartIfZero(false)) == "+2.00")
        #expect(Decimal(-2).formatted(.asRounded.signSymbols(.both).trimFractionalPartIfZero(false)) == "−2.00")
        #expect(Decimal(2.1345).formatted(.asRounded.signSymbols(.both).trimFractionalPartIfZero(false)) == "+2.13")
        #expect(Decimal(-2.1355).formatted(.asRounded.signSymbols(.both).trimFractionalPartIfZero(false)) == "−2.14")

        // .asRounded.trimFractionalPartIfZero(false).signSymbols(.both).minimumBound
        #expect(Decimal(0).formatted(.asRounded.minimumBound(1)) == "<1")
        #expect(Decimal(1).formatted(.asRounded.minimumBound(1)) == "1")
        #expect(Decimal(1.09).formatted(.asRounded.signSymbols(.both).minimumBound(5)) == "<+5")
        #expect(Decimal(0.0000109).formatted(.asRounded.fractionLength(.maxFractionDigits)) == "0.0000109")
        #expect(Decimal(-0.0000109).formatted(.asRounded.fractionLength(.maxFractionDigits)) == "−0.0000109")
        #expect(Decimal(-0.0000109).formatted(.asRounded) == "−0.000011")
    }

    @Test
    func decimal_asPercent_fractionLength() {
        // .asPercent(scale: .zeroToOne).fractionLength(2)
        #expect(Decimal(1).formatted(.asPercent.fractionLength(2)) == "100%")
        #expect(Decimal(1.09).formatted(.asPercent.fractionLength(2)) == "109%")
        #expect(Decimal(1.9).formatted(.asPercent.fractionLength(2)) == "190%")
        #expect(Decimal(2).formatted(.asPercent.fractionLength(2)) == "200%")
        #expect(Decimal(2.1345).formatted(.asPercent.fractionLength(2)) == "213.45%")
        #expect(Decimal(2.1355).formatted(.asPercent.fractionLength(2)) == "213.55%")

        #expect(Decimal(0.019).formatted(.asPercent.fractionLength(2)) == "1.90%")
        #expect(Decimal(-0.0109).formatted(.asPercent.fractionLength(2)) == "−1.09%")
        #expect(Decimal(0.02).formatted(.asPercent.fractionLength(2)) == "2%")
        #expect(Decimal(1).formatted(.asPercent.fractionLength(2)) == "100%")

        // .asPercent(scale: .zeroToHundred).fractionLength(2)
        #expect(Decimal(1).formatted(.asPercent(scale: .zeroToHundred).fractionLength(2)) == "1%")
        #expect(Decimal(1.09).formatted(.asPercent(scale: .zeroToHundred).fractionLength(2)) == "1.09%")
        #expect(Decimal(1.9).formatted(.asPercent(scale: .zeroToHundred).fractionLength(2)) == "1.90%")
        #expect(Decimal(2).formatted(.asPercent(scale: .zeroToHundred).fractionLength(2)) == "2%")
        #expect(Decimal(2.1345).formatted(.asPercent(scale: .zeroToHundred).fractionLength(2)) == "2.13%")
        #expect(Decimal(2.1355).formatted(.asPercent(scale: .zeroToHundred).fractionLength(2)) == "2.14%")
        #expect(Decimal(0.021355).formatted(.asPercent.fractionLength(2)) == "2.14%")
    }

    @Test
    func decimal_asPercent() {
        // .asPercent(scale: .zeroToOne)
        #expect(Decimal(0.019).formatted(.asPercent) == "1.90%")
        #expect(Decimal(-0.0109).formatted(.asPercent) == "−1.09%")
        #expect(Decimal(0.02).formatted(.asPercent) == "2%")
        #expect(Decimal(0.02).formatted(.asPercent.trimFractionalPartIfZero(false)) == "2.00%")
        #expect(Decimal(1).formatted(.asPercent) == "100%")

        // .asPercent(scale: .zeroToOne)
        #expect(Decimal(1).formatted(.asPercent) == "100%")
        #expect(Decimal(1.09).formatted(.asPercent) == "109%")
        #expect(Decimal(1.9).formatted(.asPercent) == "190%")
        #expect(Decimal(2).formatted(.asPercent) == "200%")
        #expect(Decimal(2.1345).formatted(.asPercent) == "213.45%")
        #expect(Decimal(2.1355).formatted(.asPercent) == "213.55%")

        // .asPercent(scale: .zeroToHundred)
        #expect(Decimal(1).formatted(.asPercent(scale: .zeroToHundred)) == "1%")
        #expect(Decimal(1.09).formatted(.asPercent(scale: .zeroToHundred)) == "1.09%")
        #expect(Decimal(1.9).formatted(.asPercent(scale: .zeroToHundred)) == "1.90%")
        #expect(Decimal(2).formatted(.asPercent(scale: .zeroToHundred)) == "2%")
        #expect(Decimal(2.1345).formatted(.asPercent(scale: .zeroToHundred)) == "2.13%")
        #expect(Decimal(2.1355).formatted(.asPercent(scale: .zeroToHundred)) == "2.14%")

        // .asPercent(scale: .zeroToOne).fractionLength(0...0)
        #expect(Decimal(0.019).formatted(.asPercent.fractionLength(0...0)) == "2%")
        #expect(Decimal(-0.0109).formatted(.asPercent.fractionLength(0...0)) == "−1%")
        #expect(Decimal(0.02).formatted(.asPercent.fractionLength(0...0)) == "2%")
        #expect(Decimal(1).formatted(.asPercent.fractionLength(0...0)) == "100%")

        // .asPercent(scale: .zeroToOne).fractionLength(0...2)
        #expect(Decimal(0.019).formatted(.asPercent.fractionLength(0...2)) == "1.9%")
        #expect(Decimal(-0.0109).formatted(.asPercent.fractionLength(0...2)) == "−1.09%")
        #expect(Decimal(0.02).formatted(.asPercent.fractionLength(0...2)) == "2%")
        #expect(Decimal(1).formatted(.asPercent.fractionLength(0...2)) == "100%")

        // .asPercent(scale: .zeroToOne).fractionLength(2...2).signSymbols(.both)
        #expect(Decimal(0).formatted(.asPercent.fractionLength(0...2).signSymbols(.both)) == "0%")
        #expect(Decimal(0.019).formatted(.asPercent.fractionLength(0...2).signSymbols(.both)) == "+1.9%")
        #expect(Decimal(-0.0109).formatted(.asPercent.fractionLength(0...2).signSymbols(.both)) == "−1.09%")
        #expect(Decimal(0.02).formatted(.asPercent.fractionLength(0...2).signSymbols(.both)) == "+2%")
        #expect(Decimal(1).formatted(.asPercent.fractionLength(0...2).signSymbols(.both)) == "+100%")

        // .asPercent(scale: .zeroToOne).signSymbols(.both).minimumBound(0.0001)
        #expect(Decimal(0.019).formatted(.asPercent.signSymbols(.both).minimumBound(0.01)) == "+1.90%")
        #expect(Decimal(-0.0109).formatted(.asPercent.signSymbols(.both).minimumBound(0.01)) == "−1.09%")
        #expect(Decimal(0.02).formatted(.asPercent.signSymbols(.both).minimumBound(0.01)) == "+2%")
        #expect(Decimal(1).formatted(.asPercent.signSymbols(.both).minimumBound(0.01)) == "+100%")
        #expect(Decimal(-0.0000109).formatted(.asPercent.signSymbols(.both).minimumBound(0.0001)) == "<−0.01%")
        #expect(Decimal(0.0000109).formatted(.asPercent.signSymbols(.both).minimumBound(0.0001)) == "<+0.01%")
        #expect(Decimal(-0.0000109).formatted(.asPercent.fractionLength(.maxFractionDigits)) == "−0.00109%")
        #expect(Decimal(0.0000109).formatted(.asPercent.fractionLength(.maxFractionDigits)) == "0.00109%")
    }
}

// MARK: - asAbbreviated

extension DoubleOrDecimalTests {
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
