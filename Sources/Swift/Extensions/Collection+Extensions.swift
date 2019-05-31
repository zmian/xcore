//
// Collection+Extensions.swift
//
// Copyright © 2014 Xcore
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

extension Collection {
    /// Returns the number of elements of the sequence that satisfy the given
    /// predicate.
    ///
    /// ```swift
    /// let cast = ["Vivien", "Marlon", "Kim", "Karl"]
    /// let shortNamesCount = cast.count { $0.count < 5 }
    /// print(shortNamesCount)
    /// // Prints "2"
    /// ```
    ///
    /// - Parameter predicate: A closure that takes an element of the sequence as
    ///                        its argument and returns a Boolean value indicating
    ///                        whether the element should be included in the
    ///                        returned count.
    /// - Returns: A count of elements that satisfy the given predicate.
    /// - Complexity: O(_n_), where _n_ is the length of the sequence.
    public func count(where predicate: (Element) throws -> Bool) rethrows -> Int {
        return try filter(predicate).count
    }
}

extension RangeReplaceableCollection {
    /// Returns an array by removing all the elements that satisfy the given
    /// predicate.
    ///
    /// Use this method to remove every element in a collection that meets
    /// particular criteria. This example removes all the odd values from an array
    /// of numbers:
    ///
    /// ```swift
    /// var numbers = [5, 6, 7, 8, 9, 10, 11]
    /// let removedNumbers = numbers.removingAll(where: { $0 % 2 == 1 })
    ///
    /// // numbers == [6, 8, 10]
    /// // removedNumbers == [5, 7, 9, 11]
    /// ```
    ////
    /// - Parameter predicate: A closure that takes an element of the sequence as
    ///                        its argument and returns a Boolean value indicating
    ///                        whether the element should be removed from the
    ///                        collection.
    /// - Returns: A collection of the elements that are removed.
    public mutating func removingAll(where predicate: (Element) throws -> Bool) rethrows -> Self {
        let result = try filter(predicate)
        try removeAll(where: predicate)
        return result
    }
}

extension RangeReplaceableCollection where Element: Equatable, Index == Int {
    /// Remove element by value.
    ///
    /// - Returns: true if removed; false otherwise
    @discardableResult
    public mutating func remove(_ element: Element) -> Bool {
        for (index, elementToCompare) in enumerated() where element == elementToCompare {
            remove(at: index)
            return true
        }
        return false
    }

    /// Remove elements by value.
    public mutating func remove(_ elements: [Element]) {
        elements.forEach { remove($0) }
    }

    /// Move an element in `self` to a specific index.
    ///
    /// - Parameters:
    ///   - element: The element in `self` to move.
    ///   - index: An index locating the new location of the element in `self`.
    /// - Returns: `true` if moved; otherwise, `false`.
    @discardableResult
    public mutating func move(_ element: Element, to index: Int) -> Bool {
        guard remove(element) else {
            return false
        }

        insert(element, at: index)
        return true
    }
}
