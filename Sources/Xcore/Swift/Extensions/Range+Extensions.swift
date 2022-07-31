//
// Xcore
// Copyright © 2017 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

extension ClosedRange where Bound: FloatingPoint {
    /// Returns a random value within the range.
    public func random() -> Bound {
        let range = upperBound - lowerBound
        return (Bound(Int.random(in: 0..<Int.max)) / Bound(Int.max)) * range + lowerBound
    }
}
