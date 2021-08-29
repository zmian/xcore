//
// Xcore
// Copyright © 2014 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

extension Sequence where Iterator.Element: Hashable {
    /// Return an `Array` containing only the unique elements of `self` in order.
    public func uniqued() -> [Iterator.Element] {
        uniqued { $0 }
    }
}

extension Sequence {
    /// Return an `Array` containing only the unique elements of `self`, in order,
    /// where `unique` criteria is determined by the `uniqueProperty` block.
    ///
    /// - Parameter uniqueProperty: `unique` criteria is determined by the value
    ///   returned by this block.
    /// - Returns: Return an `Array` containing only the unique elements of `self`,
    ///   in order, that satisfy the predicate `uniqueProperty`.
    public func uniqued<T: Hashable>(_ uniqueProperty: (Iterator.Element) -> T) -> [Iterator.Element] {
        var seen: [T: Bool] = [:]
        return filter { seen.updateValue(true, forKey: uniqueProperty($0)) == nil }
    }
}

extension Array where Element: Hashable {
    /// Modify `self` in-place such that only the unique elements of `self` in order
    /// are remaining.
    public mutating func unique() {
        self = uniqued()
    }

    /// Modify `self` in-place such that only the unique elements of `self` in order
    /// are remaining, where `unique` criteria is determined by the `uniqueProperty`
    /// block.
    ///
    /// - Parameter uniqueProperty: `unique` criteria is determined by the value
    ///   returned by this block.
    public mutating func unique<T: Hashable>(_ uniqueProperty: (Element) -> T) {
        self = uniqued(uniqueProperty)
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
    ///   its argument and returns a Boolean value indicating whether the element
    ///   should be included in the returned count.
    /// - Returns: A count of elements that satisfy the given predicate.
    /// - Complexity: O(_n_), where _n_ is the length of the sequence.
    public func count(where predicate: (Element) throws -> Bool) rethrows -> Int {
        try filter(predicate).count
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
    ///   its argument and returns a Boolean value indicating whether the element
    ///   should be removed from the collection.
    /// - Returns: A collection of the elements that are removed.
    public mutating func removingAll(where predicate: (Element) throws -> Bool) rethrows -> Self {
        let result = try filter(predicate)
        try removeAll(where: predicate)
        return result
    }
}

extension RangeReplaceableCollection where Element: Equatable, Index == Int {
    /// Removes given element by value from the collection.
    ///
    /// - Returns: `true` if removed; `false` otherwise
    @discardableResult
    public mutating func remove(_ element: Element) -> Bool {
        for (index, elementToCompare) in enumerated() where element == elementToCompare {
            remove(at: index)
            return true
        }
        return false
    }

    /// Removes given elements by value from the collection.
    public mutating func remove(_ elements: [Element]) {
        elements.forEach { remove($0) }
    }

    // MARK: - Non-mutating

    /// Removes given element by value from the collection.
    public func removing(_ element: Element) -> Self {
        var copy = self
        copy.remove(element)
        return copy
    }

    /// Removes given elements by value from the collection.
    public func removing(_ elements: [Element]) -> Self {
        var copy = self
        copy.remove(elements)
        return copy
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

extension Sequence {
    /// Returns the first element of the sequence that satisfies the given
    /// predicate.
    ///
    /// - Parameter keyPaths: A list of `keyPaths` that are used to find an element
    ///   in the sequence.
    /// - Returns: The first element of the sequence that satisfies predicate, or
    ///   `nil` if there is no element that satisfies predicate.
    /// - Complexity: O(_n_), where _n_ is the length of the sequence.
    func first(_ keyPaths: KeyPath<Element, Bool>...) -> Element? {
        first { element in
            keyPaths.allSatisfy {
                element[keyPath: $0]
            }
        }
    }

    /// Returns the first element of the sequence that satisfies the given
    /// predicate.
    ///
    /// - Parameter keyPaths: A list of `keyPaths` that are used to find an element
    ///   in the sequence.
    /// - Returns: The first element of the sequence that satisfies predicate, or
    ///   `nil` if there is no element that satisfies predicate.
    /// - Complexity: O(_n_), where _n_ is the length of the sequence.
    func first(_ keyPaths: [KeyPath<Element, Bool>]) -> Element? {
        first { element in
            keyPaths.allSatisfy {
                element[keyPath: $0]
            }
        }
    }
}

// MARK: - NSPredicate

extension Collection {
    /// Returns an array containing, in order, the elements of the sequence that
    /// satisfy the given predicate.
    public func filter(with predicate: NSPredicate) -> [Element] {
        filter(predicate.evaluate(with:))
    }

    /// Returns the first element of the sequence that satisfies the given
    /// predicate.
    public func first(with predicate: NSPredicate) -> Element? {
        first(where: predicate.evaluate(with:))
    }
}
