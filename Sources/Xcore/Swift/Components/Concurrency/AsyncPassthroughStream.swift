//
// Xcore
// Copyright © 2022 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

/// An asynchronous sequence that uses continuation to produce new elements.
///
/// Unlike ``AsyncCurrentValueStream``, a ``AsyncPassthroughStream`` doesn’t
/// have an initial value or a buffer of the most recently-published element.
///
/// ```swift
/// let stream = AsyncPassthroughStream<Int>()
///
/// // Produce new elements
/// stream.send(1)
/// stream.send(2)
///
/// // Finish producing elements
/// stream.finish()
/// ```
public final class AsyncPassthroughStream<Element>: AsyncSequence {
    fileprivate typealias Base = AsyncStream<Element>
    private typealias Continuation = Base.Continuation
    private var continuations = [AnyHashable: Continuation]()

    /// Creates an asynchronous sequence.
    public init() {}

    /// Resume the task awaiting the next iteration point by having it return
    /// nomally from its suspension point with a given element.
    ///
    /// If nothing is awaiting the next value, this method attempts to buffer the
    /// result's element.
    ///
    /// This can be called more than once and returns to the caller immediately
    /// without blocking for any awaiting consumption from the iteration.
    ///
    /// - Parameter value: The value to send from the continuation.
    public func send(_ value: Element) {
        continuations.values.forEach {
            $0.yield(value)
        }
    }

    /// Resume the task awaiting the next iteration point by having it return
    /// `nil`, which signifies the end of the iteration.
    ///
    /// Calling this function more than once has no effect. After calling finish,
    /// the stream enters a terminal state and doesn't produces any additional
    /// elements.
    public func finish() {
        continuations.values.forEach {
            $0.finish()
        }

        continuations.removeAll()
    }
}

// MARK: - Iterator

extension AsyncPassthroughStream {
    public func makeAsyncIterator() -> Iterator {
        let id = UUID()

        let stream = AsyncStream<Element> { [weak self] continuation in
            self?.continuations[id] = continuation

            continuation.onTermination = { [weak self] _ in
                self?.continuations[id] = nil
            }
        }

        return Iterator(stream.makeAsyncIterator()) { [weak self] in
            self?.continuations[id] = nil
        }
    }

    public struct Iterator: AsyncIteratorProtocol {
        private var iterator: Base.Iterator
        private let onTermination: () -> Void

        fileprivate init(_ iterator: Base.Iterator, onTermination: @escaping () -> Void) {
            self.iterator = iterator
            self.onTermination = onTermination
        }

        public mutating func next() async -> Element? {
            guard !Task.isCancelled else {
                onTermination()
                return nil
            }

            let next = await iterator.next()
            if next == nil {
                onTermination()
            }
            return next
        }
    }
}

// MARK: - AsyncStream

extension AsyncPassthroughStream {
    /// Creates an asynchronous sequence that produce new elements over time.
    public func makeAsyncStream() -> AsyncStream<Element> {
        AsyncStream(self)
    }
}
