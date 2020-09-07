//
// Xcore
// Copyright © 2014 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

extension Collection {
    /// Returns the element at the specified index iff it is within bounds;
    /// otherwise, `nil`.
    public func at(_ index: Index) -> Iterator.Element? {
        indices.contains(index) ? self[index] : nil
    }
}

extension Collection {
    /// Returns the `SubSequence` at the specified range iff it is within bounds;
    /// otherwise, `nil`.
    public func at(_ range: Range<Index>) -> SubSequence? {
        hasIndex(range) ? self[range] : nil
    }

    /// Return true iff range is in `self`.
    public func hasIndex(_ range: Range<Index>) -> Bool {
        range.lowerBound >= startIndex && range.upperBound <= endIndex
    }
}

extension RandomAccessCollection where Index == Int {
    /// Returns the `SubSequence` at the specified range iff it is within bounds;
    /// otherwise, `nil`.
    public func at(_ range: CountableRange<Index>) -> SubSequence? {
        hasIndex(range) ? self[range] : nil
    }

    /// Return true iff range is in `self`.
    public func hasIndex(_ range: CountableRange<Index>) -> Bool {
        range.lowerBound >= startIndex && range.upperBound <= endIndex
    }

    /// Returns the `SubSequence` at the specified range iff it is within bounds;
    /// otherwise, `nil`.
    public func at(_ range: CountableClosedRange<Index>) -> SubSequence? {
        hasIndex(range) ? self[range] : nil
    }

    /// Return true iff range is in `self`.
    public func hasIndex(_ range: CountableClosedRange<Index>) -> Bool {
        range.lowerBound >= startIndex && range.upperBound <= endIndex
    }
}
