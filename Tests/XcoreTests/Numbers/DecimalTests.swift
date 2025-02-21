//
// Xcore
// Copyright © 2019 Xcore
// MIT license, see LICENSE file for details
//

import Testing
import Foundation
@testable import Xcore

struct DecimalTests {
    @Test
    func rounded() {
        let x = Decimal(6.5)

        #expect(Decimal(6).rounded(fractionDigits: 2) == 6)

        #expect(x.rounded(.toNearestOrAwayFromZero, fractionDigits: 2) == 6.5)

        // Equivalent to the C 'round' function:
        #expect(x.rounded(.toNearestOrAwayFromZero) == 7.0)

        // Equivalent to the C 'trunc' function:
        #expect(x.rounded(.towardZero) == 6.0)

        // Equivalent to the C 'ceil' function:
        #expect(x.rounded(.up) == 7.0)

        // Equivalent to the C 'floor' function:
        #expect(x.rounded(.down) == 6.0)

        // Equivalent to the C 'schoolbook rounding':
        #expect(x.rounded() == 7.0)
    }

    @Test
    func round() {
        // Equivalent to the C 'round' function:
        var w = Decimal(6.5)
        w.round(.toNearestOrAwayFromZero)
        #expect(w == 7.0)

        // Equivalent to the C 'trunc' function:
        var x = Decimal(6.5)
        x.round(.towardZero)
        #expect(x == 6.0)

        // Equivalent to the C 'ceil' function:
        var y = Decimal(6.5)
        y.round(.up)
        #expect(y == 7.0)

        // Equivalent to the C 'floor' function:
        var z = Decimal(6.5)
        z.round(.down)
        #expect(z == 6.0)

        // Equivalent to the C 'schoolbook rounding':
        var w1 = 6.5
        w1.round()
        #expect(w1 == 7.0)

        var w2 = Decimal(6.5)
        w2.round(fractionDigits: 2)
        #expect(w2 == 6.5)

        var w3 = Decimal(6.56873)
        w3.round(fractionDigits: 2)
        #expect(w3 == 6.57)
    }

    @Test
    func conversionToString() throws {
        let decimal_us = try #require(Decimal(string: "0.377", locale: .usPosix))
        #expect(decimal_us.stringValue == "0.377")

        let decimal_ptPT = try #require(Decimal(string: "0,377", locale: .ptPT))
        #expect(decimal_ptPT.stringValue == "0.377")
    }

    @Test
    func integerAndFractionalParts() throws {
        let amount1 = Decimal(1200.30)
        #expect(amount1.integralPart == 1200)
        #expect(amount1.fractionalPart == 0.3)

        let amount2 = Decimal(1200.00)
        #expect(amount2.integralPart == 1200)
        #expect(amount2.fractionalPart == 0)

        let amount3 = try #require(Decimal(string: "1200.3000000012"))
        #expect(String(describing: amount3) == "1200.3000000012")
        #expect(amount3.integralPart == 1200)
        #expect(amount3.fractionalPart == Decimal(string: "0.3000000012"))
        #expect(amount3.fractionalPart.stringValue == "0.3000000012")

        let amount4 = Decimal(1200.000000000000000000)
        #expect(amount4.integralPart == 1200)
        #expect(amount4.fractionalPart == 0)
    }

    @Test
    func isFractionalPartZero() throws {
        // True
        #expect(Decimal(1200).isFractionalPartZero == true)
        #expect(Decimal(1200.00).isFractionalPartZero == true)
        #expect(Decimal(1200.000000000000000000).isFractionalPartZero == true)

        // False
        #expect(Decimal(1200.30).isFractionalPartZero == false)
        #expect(try #require(Decimal(string: "1200.3000000012")).isFractionalPartZero == false)
        #expect(try #require(Decimal(string: "1200.0000000012")).isFractionalPartZero == false)
    }
}
