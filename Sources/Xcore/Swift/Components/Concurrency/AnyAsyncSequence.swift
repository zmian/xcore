//
// Xcore
// Copyright © 2022 Xcore
// MIT license, see LICENSE file for details
//

// MARK: - AsyncSequence

extension AsyncSequence {
    public func eraseToAnyAsyncSequence() -> AnyAsyncSequence<Element> {
        AnyAsyncSequence(self)
    }
}

// MARK: - AnyAsyncSequence

/// An asynchronous sequence that performs type erasure by wrapping another
/// asynchronous sequence.
public struct AnyAsyncSequence<Element>: AsyncSequence {
    private let _makeAsyncIterator: () -> Iterator

    /// Creates a type-erasing asynchronous sequence to wrap the provided
    /// asynchronous sequence.
    ///
    /// - Parameter sequence: An asynchronous sequence to wrap with a type-eraser.
    public init<S: AsyncSequence>(_ sequence: S) where S.Element == Element {
        _makeAsyncIterator = {
            Iterator(sequence.makeAsyncIterator())
        }
    }
}

// MARK: - Iterator

extension AnyAsyncSequence {
    /// The asynchronous iterator for iterating any asynchronous sequence.
    public struct Iterator: AsyncIteratorProtocol {
        private let _next: () async throws -> Element?

        fileprivate init<I: AsyncIteratorProtocol>(_ iterator: I) where I.Element == Element {
            var iterator = iterator
            self._next = {
                try await iterator.next()
            }
        }

        public mutating func next() async throws -> Element? {
            try await _next()
        }
    }

    public func makeAsyncIterator() -> Iterator {
        _makeAsyncIterator()
    }
}

// MARK: - Sendable

extension AnyAsyncSequence: @unchecked Sendable where Element: Sendable {}
