//
// Xcore
// Copyright © 2025 Xcore
// MIT license, see LICENSE file for details
//

import Testing
import Foundation
@testable import Xcore

struct PowFunctionTests {
    @Test("Pow function with Double")
    func double() {
        #expect(pow_xc(5.0, 0) == Double(1.0), "5.0^0 should be 1.0")
        #expect(pow_xc(5.0, 1) == Double(5.0), "5.0^1 should be 5.0")
        #expect(pow_xc(0.0, 0) == Double(1.0), "0.0^0 should be 1.0")
        #expect(pow_xc(0.0, 1) == Double(0.0), "0.0^1 should be 0.0")

        // Positive Exponents
        #expect(pow_xc(2.5, 2) == Double(6.25), "2.5^2 should be 6.25")
        #expect(pow_xc(1.5, 3) == Double(3.375), "1.5^3 should be 3.375")

        // Negative Base
        #expect(pow_xc(-2.0, 3) == Double(-8.0), "-2.0^3 should be -8.0")
        #expect(pow_xc(-2.0, 2) == Double(4.0), "-2.0^2 should be 4.0")

        // Negative Base & Exponent
        #expect(pow_xc(-2.0, -3) == Double(-0.125), "-2.0^-3 should be -0.125")
        #expect(pow_xc(2.0, -1) == Double(0.5), "2.0^-1 should be 0.5")
        #expect(pow_xc(0.0, -1) == Double.infinity, "0.0^-1 should be infinity")
    }

    @Test("Pow vs Built-in Pow function with Double")
    func double_built_in_pow() {
        #expect(pow_xc(5.0, 0) == pow(5.0, 0))
        #expect(pow_xc(5.0, 1) == pow(5.0, 1))
        #expect(pow_xc(0.0, 0) == pow(0.0, 0))
        #expect(pow_xc(0.0, 1) == pow(0.0, 1))

        // Positive Exponents
        #expect(pow_xc(2.5, 2) == pow(2.5, 2))
        #expect(pow_xc(1.5, 3) == pow(1.5, 3))

        // Negative Base
        #expect(pow_xc(-2.0, 3) == pow(-2.0, 3))
        #expect(pow_xc(-2.0, 2) == pow(-2.0, 2))

        // Negative Base & exponent
        #expect(pow_xc(-2.0, -3) == pow(-2.0, -3))
        #expect(pow_xc(2.0, -1) == pow(2.0, -1))
        #expect(pow_xc(0.0, -1) == pow(0, -1))
    }
}
