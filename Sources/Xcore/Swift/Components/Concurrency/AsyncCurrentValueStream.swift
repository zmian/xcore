//
// Xcore
// Copyright © 2022 Xcore
// MIT license, see LICENSE file for details
//

/// An asynchronous sequence that wraps a single value and uses continuation to
/// produce new elements.
///
/// Unlike ``AsyncPassthroughStream``, ``AsyncCurrentValueStream`` maintains a
/// buffer of the most recently produced element.
///
/// ```swift
/// let stream = AsyncCurrentValueStream<Int>(5)
///
/// // Set up on termination handler
/// stream.onTermination { _ in
///     print("good bye")
/// }
///
/// print(stream.value) // Prints 5
///
/// // Produce new elements
/// stream.yield(1)
/// print(stream.value) // Prints 1
///
/// stream.yield(2)
///
/// // Finish producing elements
/// stream.finish()
///
/// // Current Value
/// print(stream.value) // Prints 2
/// ```
public final class AsyncCurrentValueStream<Element>: AsyncSequence {
    public typealias Base = AsyncStream<Element>
    public let base: Base
    private var continuation: Base.Continuation?

    /// The value wrapped by this stream, produced as a new element whenever it
    /// changes.
    public private(set) var value: Element

    /// Creates a current value asynchronous sequence with the given initial value.
    ///
    /// - Parameter value: The initial value to produce.
    public init(_ value: Element) {
        self.value = value

        var c: Base.Continuation?

        base = AsyncStream { continuation in
            continuation.yield(value)
            c = continuation
        }

        continuation = c
    }

    public func makeAsyncIterator() -> Base.Iterator {
        base.makeAsyncIterator()
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
    /// - Parameter value: The value to yield from the continuation.
    public func yield(_ value: Element) {
        self.value = value
        continuation?.yield(value)
    }

    /// Resume the task awaiting the next iteration point by having it return
    /// `nil`, which signifies the end of the iteration.
    ///
    /// Calling this function more than once has no effect. After calling finish,
    /// the stream enters a terminal state and doesn't produces any additional
    /// elements.
    public func finish() {
        continuation?.finish()
        continuation = nil
    }

    /// A callback to invoke when canceling iteration of an asynchronous stream.
    ///
    /// If an `onTermination` callback is set, using task cancellation to terminate
    /// iteration of an `AsyncStream` results in a call to this callback.
    ///
    /// Canceling an active iteration invokes the `onTermination` callback first,
    /// then resumes by yielding `nil`. This means that you can perform needed
    /// cleanup in the cancellation handler. After reaching a terminal state as a
    /// result of cancellation, the `AsyncStream` sets the callback to `nil`.
    public func onTermination(_ call: @escaping @Sendable (Base.Continuation.Termination) -> Void) {
        continuation?.onTermination = call
    }
}
