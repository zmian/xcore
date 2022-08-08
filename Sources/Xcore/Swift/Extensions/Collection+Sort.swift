//
// Xcore
// Copyright © 2022 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

extension Array {
    /// Returns the elements of the sequence, sorted using the given key path as
    /// the comparison between elements.
    ///
    /// In the following example, the key paths provides an ordering for an array
    /// of a custom `Room` type.
    ///
    /// ```swift
    /// struct Room {
    ///     let name: String
    ///     let capacity: Int
    /// }
    ///
    /// let rooms = [
    ///     Room(name: "Leopard", capacity: 75),
    ///     Room(name: "Big Sur", capacity: 50),
    ///     Room(name: "Ventura", capacity: 100)
    /// ]
    ///
    /// let sortedByCapacity = rooms.sorted(by: \.capacity)
    /// print(sortedByCapacity)
    /// // Prints "[Room(name: "Ventura", capacity: 100), Room(name: "Leopard", capacity: 75), Room(name: "Big Sur", capacity: 50)]"
    /// ```
    ///
    /// - Parameters:
    ///   - keyPath: A key path of the element to order by.
    ///   - ascending: A Boolean value indicating whether the key path ordering
    ///     should be ascending.
    /// - Returns: A sorted array of the sequence's elements.
    ///
    /// - Complexity: O(*n* log *n*), where *n* is the length of the sequence.
    public func sorted<T: Comparable>(by keyPath: KeyPath<Element, T>, ascending: Bool = false) -> [Element] {
        sorted {
            let lhs = $0[keyPath: keyPath]
            let rhs = $1[keyPath: keyPath]
            return ascending ? lhs < rhs : lhs > rhs
        }
    }

    /// Returns the elements of the sequence, sorted using the given key path as
    /// the comparison between optional elements.
    ///
    /// In the following example, the key paths provides an ordering for an array
    /// of a custom `Room` type.
    ///
    /// ```swift
    /// struct Room {
    ///     let name: String
    ///     let capacity: Int?
    /// }
    ///
    /// let rooms = [
    ///     Room(name: "Leopard", capacity: 75),
    ///     Room(name: "Big Sur", capacity: 50),
    ///     Room(name: "Ventura", capacity: nil)
    /// ]
    ///
    /// let sortedByCapacity = rooms.sorted(by: \.capacity)
    /// print(sortedByCapacity)
    /// // Prints "[Room(name: "Leopard", capacity: 75), Room(name: "Big Sur", capacity: 50), Room(name: "Ventura", capacity: nil)]"
    /// ```
    ///
    /// - Parameters:
    ///   - keyPath: A key path of the element to order by.
    ///   - ascending: A Boolean value indicating whether the key path ordering
    ///     should be ascending.
    /// - Returns: A sorted array of the sequence's elements.
    ///
    /// - Complexity: O(*n* log *n*), where *n* is the length of the sequence.
    public func sorted<T: Comparable>(by keyPath: KeyPath<Element, T?>, ascending: Bool = false) -> [Element] {
        sorted {
            guard
                let lhs = $0[keyPath: keyPath],
                let rhs = $1[keyPath: keyPath]
            else {
                return ascending
            }
            return ascending ? lhs < rhs : lhs > rhs
        }
    }
}

extension Sequence {
    /// Returns the elements of the sequence, sorted using the given predicates as
    /// the comparison between elements.
    ///
    /// In the following example, the predicates provides an ordering for an array
    /// of a custom `Room` type.
    ///
    /// ```swift
    /// struct Room {
    ///     let name: String
    ///     let capacity: Int
    /// }
    ///
    /// let rooms = [
    ///     Room(name: "Leopard", capacity: 50),
    ///     Room(name: "Big Sur", capacity: 50),
    ///     Room(name: "Ventura", capacity: 100)
    /// ]
    ///
    /// let sortedRooms = rooms.sorted(by:
    ///     { $0.capacity > $1.capacity },
    ///     { $0.name < $1.name }
    /// )
    ///
    /// print(sortedRooms)
    /// // Prints "[Room(name: "Ventura", capacity: 100), Room(name: "Big Sur", capacity: 50), Room(name: "Leopard", capacity: 50)]"
    /// ```
    ///
    /// - Parameters:
    ///   - firstPredicate: A predicate that returns `true` if its first argument
    ///     should be ordered before its second argument; otherwise, `false`.
    ///   - secondPredicate: A predicate that returns `true` if its first argument
    ///     should be ordered before its second argument; otherwise, `false`.
    ///   - otherPredicates: A predicate that returns `true` if its first argument
    ///     should be ordered before its second argument; otherwise, `false`.
    /// - Returns: A sorted array of the sequence's elements.
    ///
    /// - SeeAlso: https://stackoverflow.com/a/37612765
    public func sorted(
        by firstPredicate: (Element, Element) -> Bool,
        _ secondPredicate: (Element, Element) -> Bool,
        _ otherPredicates: ((Element, Element) -> Bool)...
    ) -> [Element] {
        sorted(by:) { lhs, rhs in
            if firstPredicate(lhs, rhs) { return true }
            if firstPredicate(rhs, lhs) { return false }
            if secondPredicate(lhs, rhs) { return true }
            if secondPredicate(rhs, lhs) { return false }
            for predicate in otherPredicates {
                if predicate(lhs, rhs) { return true }
                if predicate(rhs, lhs) { return false }
            }
            return false
        }
    }
}

extension MutableCollection where Self: RandomAccessCollection {
    /// Sorts the collection in place, using the given predicates as the comparison
    /// between elements.
    ///
    /// In the following example, the predicates provides an ordering for an array
    /// of a custom `Room` type.
    ///
    /// ```swift
    /// struct Room {
    ///     let name: String
    ///     let capacity: Int
    /// }
    ///
    /// var rooms = [
    ///     Room(name: "Leopard", capacity: 50),
    ///     Room(name: "Big Sur", capacity: 50),
    ///     Room(name: "Ventura", capacity: 100)
    /// ]
    ///
    /// rooms.sort(by:
    ///     { $0.capacity > $1.capacity },
    ///     { $0.name < $1.name }
    /// )
    ///
    /// print(rooms)
    /// // Prints "[Room(name: "Ventura", capacity: 100), Room(name: "Big Sur", capacity: 50), Room(name: "Leopard", capacity: 50)]"
    /// ```
    ///
    /// - Parameters:
    ///   - firstPredicate: A predicate that returns `true` if its first argument
    ///     should be ordered before its second argument; otherwise, `false`.
    ///   - secondPredicate: A predicate that returns `true` if its first argument
    ///     should be ordered before its second argument; otherwise, `false`.
    ///   - otherPredicates: A predicate that returns `true` if its first argument
    ///     should be ordered before its second argument; otherwise, `false`.
    /// - Returns: A sorted array of the sequence's elements.
    ///
    /// - SeeAlso: https://stackoverflow.com/a/37612765
    public mutating func sort(
        by firstPredicate: (Element, Element) -> Bool,
        _ secondPredicate: (Element, Element) -> Bool,
        _ otherPredicates: ((Element, Element) -> Bool)...
    ) {
        sort(by:) { lhs, rhs in
            if firstPredicate(lhs, rhs) { return true }
            if firstPredicate(rhs, lhs) { return false }
            if secondPredicate(lhs, rhs) { return true }
            if secondPredicate(rhs, lhs) { return false }
            for predicate in otherPredicates {
                if predicate(lhs, rhs) { return true }
                if predicate(rhs, lhs) { return false }
            }
            return false
        }
    }
}
