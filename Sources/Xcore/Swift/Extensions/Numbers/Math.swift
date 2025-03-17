//
// Xcore
// Copyright © 2025 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

/// Raises a base to the power of an exponent.
///
/// - Parameters:
///   - base: The base value.
///   - exponent: The exponent.
/// - Returns: The result of base raised to the power of exponent.
func pow_xc<T>(_ base: T, _ exponent: Int) -> T where T: FloatingPoint {
    // Handle zero base with negative exponent
    if base == 0 && exponent < 0 {
        return .infinity
    }

    // Standard positive exponent case
    let absExponent = abs(exponent)
    if absExponent == 0 { return 1 }
    if absExponent == 1 { return exponent < 0 ? 1 / base : base }

    var result: T = 1
    var base = base
    var exp = absExponent

    while exp > 0 {
        if exp % 2 == 1 {
            result *= base
        }
        base *= base
        exp /= 2
    }

    return exponent < 0 ? 1 / result : result
}
