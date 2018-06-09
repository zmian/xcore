//
// Collection+Extensions.swift
//
// Copyright © 2014 Zeeshan Mian
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

import Foundation

extension Collection {
    /// Returns the element at the specified index iff it is within bounds, otherwise `nil`.
    public func at(_ index: Index) -> Iterator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

extension Collection {
    /// Returns the `SubSequence` at the specified range iff it is within bounds, otherwise `nil`.
    public func at(_ range: Range<Index>) -> SubSequence? {
        return hasIndex(range) ? self[range] : nil
    }

    /// Return true iff range is in `self`.
    public func hasIndex(_ range: Range<Index>) -> Bool {
        return range.lowerBound >= startIndex && range.upperBound <= endIndex
    }
}

extension RandomAccessCollection where Index == Int {
    /// Returns the `SubSequence` at the specified range iff it is within bounds, otherwise `nil`.
    public func at(_ range: CountableRange<Index>) -> SubSequence? {
        return hasIndex(range) ? self[range] : nil
    }

    /// Return true iff range is in `self`.
    public func hasIndex(_ range: CountableRange<Index>) -> Bool {
        return range.lowerBound >= startIndex && range.upperBound <= endIndex
    }

    /// Returns the `SubSequence` at the specified range iff it is within bounds, otherwise `nil`.
    public func at(_ range: CountableClosedRange<Index>) -> SubSequence? {
        return hasIndex(range) ? self[range] : nil
    }

    /// Return true iff range is in `self`.
    public func hasIndex(_ range: CountableClosedRange<Index>) -> Bool {
        return range.lowerBound >= startIndex && range.upperBound <= endIndex
    }
}

extension Sequence where Iterator.Element: Hashable {
    /// Return an `Array` containing only the unique elements of `self` in order.
    public func unique() -> [Iterator.Element] {
        var seen: [Iterator.Element: Bool] = [:]
        return filter { seen.updateValue(true, forKey: $0) == nil }
    }
}

extension Sequence {
    /// Return an `Array` containing only the unique elements of `self`,
    /// in order, where `unique` criteria is determined by the `uniqueProperty` block.
    ///
    /// - Parameter uniqueProperty: `unique` criteria is determined by the value returned by this block.
    /// - Returns: Return an `Array` containing only the unique elements of `self`,
    /// in order, that satisfy the predicate `uniqueProperty`.
    public func unique<T: Hashable>(_ uniqueProperty: (Iterator.Element) -> T) -> [Iterator.Element] {
        var seen: [T: Bool] = [:]
        return filter { seen.updateValue(true, forKey: uniqueProperty($0)) == nil }
    }
}

extension Array where Element: Hashable {
    /// Modify `self` in-place such that only the unique elements of `self` in order are remaining.
    public mutating func uniqueInPlace() {
        self = unique()
    }

    /// Modify `self` in-place such that only the unique elements of `self` in order are remaining,
    /// where `unique` criteria is determined by the `uniqueProperty` block.
    ///
    /// - Parameter uniqueProperty: `unique` criteria is determined by the value returned by this block.
    public mutating func uniqueInPlace<T: Hashable>(_ uniqueProperty: (Element) -> T) {
        self = unique(uniqueProperty)
    }
}
