//
// Xcore
// Copyright © 2022 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

/// An asynchronous sequence that wraps a single value and uses continuation to
/// produce new elements.
///
/// Unlike ``AsyncPassthroughStream``, ``AsyncCurrentValueStream`` maintains a
/// buffer of the most recently produced element.
///
/// ```swift
/// let stream = AsyncCurrentValueStream<Int>(5)
///
/// print(stream.value) // Prints 5
///
/// // Produce new elements
/// stream.send(1)
/// print(stream.value) // Prints 1
///
/// stream.send(2)
///
/// // Finish producing elements
/// stream.finish()
///
/// // Current Value
/// print(stream.value) // Prints 2
/// ```
public struct AsyncCurrentValueStream<Element: Sendable>: AsyncSequence, Sendable {
    fileprivate typealias Base = AsyncStream<Element>
    private typealias Continuation = Base.Continuation
    private let continuations = LockIsolated([UUID: Continuation]())
    /// The lock-isolated value.
    private let lockedValue: LockIsolated<Element>

    /// The value wrapped by this stream, produced as a new element whenever it
    /// changes.
    public var value: Element {
        lockedValue.value
    }

    /// Creates a current value asynchronous sequence with the given initial value.
    ///
    /// - Parameter value: The initial value to produce.
    public init(_ value: Element) {
        lockedValue = LockIsolated(value)
    }

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
        lockedValue.setValue(value)
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
        continuations.withValue {
            $0.values.forEach {
                $0.finish()
            }

            $0.removeAll()
        }
    }
}

// MARK: - Iterator

extension AsyncCurrentValueStream {
    public func makeAsyncIterator() -> Iterator {
        let id = UUID()

        let stream = AsyncStream<Element> { continuation in
            continuation.yield(lockedValue.value)
            continuations.withValue {
                $0[id] = continuation
            }

            continuation.onTermination = { _ in
                continuations.withValue {
                    $0[id] = nil
                }
            }
        }

        return Iterator(stream.makeAsyncIterator()) {
            continuations.withValue {
                $0[id] = nil
            }
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
