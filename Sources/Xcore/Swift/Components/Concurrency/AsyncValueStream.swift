//
// Xcore
// Copyright © 2022 Xcore
// MIT license, see LICENSE file for details
//

/// The ``AsyncValueStream`` that wraps a single value and produces a new
/// element whenever the value changes.
///
/// It's a lightweight wrapper over ``AsyncCurrentValueStream`` that prevents
/// outside world from producing unintended values.
///
/// ```swift
/// let internalStream = AsyncCurrentValueStream<Int>(5)
///
/// let externalStream = AsyncValueStream(internalStream)
///
/// print(externalStream.value) // Prints 5
///
/// // Produce new elements
/// internalStream.send(1)
/// print(externalStream.value) // Prints 1
///
/// internalStream.send(2)
///
/// // Finish producing elements
/// internalStream.finish()
///
/// // Current Value
/// print(externalStream.value) // Prints 2
///
/// externalStream.send(2) // 🛑 Value of type 'AsyncValueStream<Int>' has no member 'send'
/// ```
public struct AsyncValueStream<Element>: AsyncSequence {
    private let base: AsyncCurrentValueStream<Element>

    /// The value wrapped by this stream, produced as a new element whenever it
    /// changes.
    public var value: Element {
        base.value
    }

    /// Creates a current value asynchronous sequence from the given stream.
    ///
    /// - Parameter stream: The base stream.
    public init(_ stream: AsyncCurrentValueStream<Element>) {
        base = stream
    }

    public func makeAsyncIterator() -> AsyncCurrentValueStream<Element>.Iterator {
        base.makeAsyncIterator()
    }
}

// MARK: - Constant

extension AsyncValueStream {
    /// An asynchronous sequence that immediately produces the given value. Useful for
    /// situations where you must return an asynchronous sequence, but you don't
    /// need to do anything.
    ///
    /// - Parameter value: The constant value to produce.
    public static func constant(_ value: Element) -> Self {
        .init(.init(value))
    }
}
