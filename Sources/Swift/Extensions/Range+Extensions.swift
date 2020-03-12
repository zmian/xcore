//
// Xcore
// Copyright © 2017 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

extension ClosedRange where Bound: FloatingPoint {
    public func random() -> Bound {
        let range = upperBound - lowerBound
        return (Bound(UInt32.random(in: 0..<UInt32.max)) / Bound(UInt32.max)) * range + lowerBound
    }
}
