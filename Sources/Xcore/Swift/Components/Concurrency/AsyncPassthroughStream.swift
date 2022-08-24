//
// Xcore
// Copyright © 2022 Xcore
// MIT license, see LICENSE file for details
//

/// An asynchronous sequence that uses continuation to produce new elements.
///
/// Unlike ``AsyncCurrentValueStream``, a ``AsyncPassthroughStream`` doesn’t
/// have an initial value or a buffer of the most recently-published element.
///
/// ```swift
/// let stream = AsyncPassthroughStream<Int>()
///
/// // Set up on termination handler
/// stream.onTermination { _ in
///     print("good bye")
/// }
///
/// // Produce new elements
/// stream.yield(1)
/// stream.yield(2)
///
/// // Finish producing elements
/// stream.finish()
/// ```
public final class AsyncPassthroughStream<Element>: AsyncSequence {
    public typealias Base = AsyncStream<Element>
    public let base: Base
    private var continuation: Base.Continuation?

    /// Creates an asynchronous sequence.
    public init() {
        var c: Base.Continuation?

        base = AsyncStream { continuation in
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
