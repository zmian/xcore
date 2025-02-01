//
// Xcore
// Copyright © 2017 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

extension ClosedRange where Bound: FloatingPoint {
    /// Returns a random floating-point number within the range.
    ///
    /// This method generates a random value that is evenly distributed within the
    /// range `[lowerBound, upperBound]`. The result will always be within the
    /// inclusive bounds of the range.
    ///
    /// **Usage**
    ///
    /// ```swift
    /// let randomValue = (0.0...1.0).random()
    /// print(randomValue) // Example: 0.4728392
    /// ```
    ///
    /// - Returns: A random floating-point number within the range.
    public func random() -> Bound {
        let range = upperBound - lowerBound
        return (Bound(Int.random(in: 0..<Int.max)) / Bound(Int.max)) * range + lowerBound
    }
}
