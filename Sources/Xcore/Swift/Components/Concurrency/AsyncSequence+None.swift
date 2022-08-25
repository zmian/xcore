//
// Xcore
// Copyright © 2022 Xcore
// MIT license, see LICENSE file for details
//

// MARK: - AsyncStream

extension AsyncStream {
    /// Any asynchronous sequence that does nothing and completes immediately.
    /// Useful for situations where you must return an asynchronous sequence, but
    /// you don't need to do anything.
    public static var none: Self {
        AsyncStream { $0.finish() }
    }
}

// MARK: - AsyncThrowingStream

extension AsyncThrowingStream where Failure == Error {
    /// Any asynchronous sequence that does nothing and completes immediately.
    /// Useful for situations where you must return an asynchronous sequence, but
    /// you don't need to do anything.
    public static var none: AsyncThrowingStream<Element, Failure> {
        AsyncThrowingStream { $0.finish() }
    }
}

// MARK: - AnyAsyncSequence

extension AnyAsyncSequence {
    /// Any asynchronous sequence that does nothing and completes immediately.
    /// Useful for situations where you must return an asynchronous sequence, but
    /// you don't need to do anything.
    public static var none: Self {
        AsyncStream
            .none
            .eraseToAnyAsyncSequence()
    }
}

// MARK: - AnyAsyncSequence

extension AsyncPassthroughStream {
    /// Any asynchronous sequence that does nothing and completes immediately.
    /// Useful for situations where you must return an asynchronous sequence, but
    /// you don't need to do anything.
    public static var none: Self {
        let stream = Self()
        stream.finish()
        return stream
    }
}
