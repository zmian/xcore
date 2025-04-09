//
// Xcore
// Copyright © 2025 Xcore
// MIT license, see LICENSE file for details
//

/// An infinite collection that cycles through the elements of a base
/// collection.
///
/// `CycledCollection` wraps a base collection and provides an infinite sequence
/// of its elements, repeating from the start when it reaches the end. If the
/// base collection is empty, the resulting collection yields no elements. It
/// preserves the bidirectional and random-access capabilities of the base
/// collection when applicable.
///
/// - Complexity: O(1) for element access and index operations when the base is
///   random-access.
public struct CycledCollection<Base: Collection>: Sequence {
    public typealias Element = Base.Element

    /// The underlying collection being cycled.
    @usableFromInline
    let base: Base

    /// Creates an instance that presents the elements of `base` in cycle
    /// collection.
    ///
    /// - Complexity: O(1)
    @inlinable
    init(_ base: Base) {
        self.base = base
    }

    @inlinable
    public func makeIterator() -> Iterator {
        Iterator(base)
    }
}

// MARK: - Iterator

extension CycledCollection {
    @frozen
    public struct Iterator: IteratorProtocol {
        @usableFromInline
        let base: Base

        @usableFromInline
        var index: Base.Index?

        /// Creates an iterator over the given collection.
        @inlinable
        init(_ base: Base) {
            self.base = base
            self.index = base.isEmpty ? nil : base.startIndex
        }

        @inlinable
        public mutating func next() -> Element? {
            guard let currentIndex = index else {
                return nil
            }

            let element = base[currentIndex]
            base.formIndex(after: &index!)
            if index == base.endIndex {
                index = base.startIndex
            }
            return element
        }
    }
}

// MARK: - Collection

extension CycledCollection: Collection {
    public enum Index: Comparable, Sendable {
        case position(Int)
        case infinity

        @inlinable
        public static func <(lhs: Index, rhs: Index) -> Bool {
            switch (lhs, rhs) {
                case let (.position(l), .position(r)): l < r
                case (.position, .infinity): true
                case (.infinity, _): false
            }
        }

        @inlinable
        public static func ==(lhs: Index, rhs: Index) -> Bool {
            switch (lhs, rhs) {
                case let (.position(l), .position(r)):
                    l == r
                case (.infinity, .infinity):
                    true
                case (.infinity, .position), (.position, .infinity):
                    false
            }
        }
    }

    @inlinable
    public var startIndex: Index {
        base.isEmpty ? .infinity : .position(0)
    }

    @inlinable
    public var endIndex: Index {
        .infinity
    }

    @inlinable
    public func index(after index: Index) -> Index {
        switch index {
            case let .position(pos):
                base.isEmpty ? .infinity : .position(pos + 1)
            case .infinity:
                    .infinity
        }
    }

    @inlinable
    public subscript(position: Int) -> Element {
        let count = base.count
        // Ensure positive remainder, avoiding overflow with Int.min
        let offset = ((position % count) + count) % count
        return base[base.index(base.startIndex, offsetBy: offset)]
    }

    @inlinable
    public subscript(position: Index) -> Element {
        switch position {
            case let .position(pos):
                self[pos]
            case .infinity:
                fatalError("Cannot access element at infinity of CycledCollection")
        }
    }
}

// MARK: - Bidirectional Collection

extension CycledCollection: BidirectionalCollection where Base: BidirectionalCollection {
    @inlinable
    public func index(before index: Index) -> Index {
        switch index {
            case let .position(pos):
                base.isEmpty ? .infinity : .position(pos - 1)
            case .infinity:
                base.isEmpty ? .infinity : .position(Int.max)
        }
    }
}

// MARK: - Random Access Collection

extension CycledCollection: RandomAccessCollection where Base: RandomAccessCollection {
    @inlinable
    public func index(_ index: Index, offsetBy distance: Int) -> Index {
        switch index {
            case let .position(pos):
                base.isEmpty ? .infinity : .position(pos + distance)
            case .infinity:
                base.isEmpty ? .infinity : distance < 0 ? .position(Int.max + distance) : .infinity
        }
    }

    @inlinable
    public func distance(from start: Index, to end: Index) -> Int {
        switch (start, end) {
            case let (.position(s), .position(e)):
                base.isEmpty ? 0 : e - s
            case (.position, .infinity):
                base.isEmpty ? 0 : Int.max
            case let (.infinity, .position(e)):
                base.isEmpty ? 0 : e - Int.max
            case (.infinity, .infinity):
                0
        }
    }
}

// MARK: - LazyCollection

extension CycledCollection: LazyCollectionProtocol {}

// MARK: - Sendable

extension CycledCollection: Sendable where Base: Sendable {}
extension CycledCollection.Iterator: Sendable where Base: Sendable, Base.Index: Sendable {}

// MARK: - Convenience Extension

extension Collection {
    /// Returns a view presenting the elements of the collection repeated
    /// indefinitely.
    ///
    /// You can cycle a collection without allocating new space for its elements by
    /// calling this `cycled()` method. A `CycledCollection` instance wraps an
    /// underlying collection and provides infinite access to its elements by
    /// repeating them in their original order. This example prints the characters
    /// of a string repeatedly:
    ///
    /// ```swift
    /// let word = "Cycle"
    /// for char in word.cycled().prefix(8) {
    ///     print(char, terminator: "")
    /// }
    /// // Prints "CycleCyc"
    /// ```
    ///
    /// If you need a finite repetition or a specific collection type, you can use
    /// the cycled collection with methods like ``prefix(_:)`` to limit the number
    /// of elements, then initialize a new instance of your desired type. For
    /// example, to get a string with the characters repeated twice:
    ///
    /// ```swift
    /// let repeatedWord = String(word.cycled().prefix(word.count * 2))
    /// print(repeatedWord)
    /// // Prints "CycleCycle"
    /// ```
    ///
    /// > Important: When the base collection is non-empty, the resulting
    /// > `CycledCollection` is an infinite collection. Do not directly call methods
    /// > that require finite sequences like ``map``, ``filter``, or ``reduce``
    /// > without first limiting the number of elements, for example, by using
    /// > ``prefix(_:)`` to limit it and avoid creating an infinite loop.
    /// >
    /// > Example of incorrect usage:
    /// >
    /// > ```swift
    /// > let numbers = [1, 2, 3].cycled()
    /// > // Infinite loop!
    /// > let mapped = numbers.map { $0 * 2 }
    /// > ```
    /// >
    /// > Correct usage with `prefix(_:)`:
    /// >
    /// > ```swift
    /// > let numbers = [1, 2, 3].cycled()
    /// > // [2, 4, 6, 2, 4, 6]
    /// > let finiteMapped = numbers.prefix(6).map { $0 * 2 }
    /// > print(finiteMapped) // [2, 4, 6, 2, 4, 6]
    /// > ```
    ///
    /// - Complexity: O(1)
    @inlinable
    public consuming func cycled() -> CycledCollection<Self> {
        CycledCollection(self)
    }
}

extension CycledCollection {
    /// Returns this `CycledCollection` instance unchanged when cycled again.
    ///
    /// Since a `CycledCollection` already provides an infinite sequence of its base
    /// collection’s elements, calling `cycled()` on an existing `CycledCollection`
    /// simply returns the same instance to avoid unnecessary nesting. This ensures
    /// that repeated calls to `cycled()` do not create redundant layers of wrapping,
    /// maintaining performance and clarity.
    ///
    /// For example, cycling an already cycled collection yields the same behavior:
    ///
    /// ```swift
    /// let numbers = [1, 2, 3]
    /// let cycledOnce = numbers.cycled()
    /// let cycledTwice = cycledOnce.cycled()
    /// print(cycledTwice[5])  // Prints "3"
    /// print(cycledTwice === cycledOnce)  // Prints "true"
    /// ```
    ///
    /// > Important: When the base collection is non-empty, the resulting
    /// > `CycledCollection` is an infinite collection. Do not directly call methods
    /// > that require finite sequences like ``map``, ``filter``, or ``reduce``
    /// > without first limiting the number of elements, for example, by using
    /// > ``prefix(_:)`` to limit it and avoid creating an infinite loop.
    /// >
    /// > Example of incorrect usage:
    /// >
    /// > ```swift
    /// > let numbers = [1, 2, 3].cycled()
    /// > // Infinite loop!
    /// > let mapped = numbers.map { $0 * 2 }
    /// > ```
    /// >
    /// > Correct usage with `prefix(_:)`:
    /// >
    /// > ```swift
    /// > let numbers = [1, 2, 3].cycled()
    /// > // [2, 4, 6, 2, 4, 6]
    /// > let finiteMapped = numbers.prefix(6).map { $0 * 2 }
    /// > print(finiteMapped) // [2, 4, 6, 2, 4, 6]
    /// > ```
    ///
    /// - Complexity: O(1)
    /// - Returns: This `CycledCollection` instance.
    @inlinable
    public consuming func cycled() -> Self {
        self
    }
}
