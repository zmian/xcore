//
// Xcore
// Copyright © 2022 Xcore
// MIT license, see LICENSE file for details
//

// MARK: - AnyAsyncSequence

extension AsyncStream {
    /// Any asynchronous sequence that causes a test to fail if it runs.
    public static func unimplemented(_ prefix: String) -> Self {
        AsyncStream {
            reportIssue("\(prefix.isEmpty ? "" : "\(prefix) - ")A failing asynchronous sequence ran.")
            $0.finish()
        }
    }
}

// MARK: - AsyncThrowingStream

extension AsyncThrowingStream where Failure == Error {
    /// Any asynchronous sequence that causes a test to fail if it runs.
    public static func unimplemented(_ prefix: String) -> Self {
        AsyncThrowingStream {
            reportIssue("\(prefix.isEmpty ? "" : "\(prefix) - ")A failing asynchronous sequence ran.")
            $0.finish()
        }
    }
}

// MARK: - AsyncPassthroughStream

extension AsyncPassthroughStream {
    /// Any asynchronous sequence that causes a test to fail if it runs.
    public static func unimplemented(_ prefix: String) -> Self {
        let stream = Self()
        reportIssue("\(prefix.isEmpty ? "" : "\(prefix) - ")A failing asynchronous sequence ran.")
        stream.finish()
        return stream
    }

    /// An `AsyncPassthroughStream` that never emits and completes immediately.
    ///
    /// Useful for situations where you must return an asynchronous sequence, but
    /// you don't need to do anything.
    public static var finished: Self {
        let stream = Self()
        stream.finish()
        return stream
    }
}

// MARK: - AsyncCurrentValueStream

extension AsyncCurrentValueStream {
    /// Any asynchronous sequence that causes a test to fail if it runs.
    public static func unimplemented(_ prefix: String, placeholder: Element) -> Self {
        let stream = Self(placeholder)
        reportIssue("\(prefix.isEmpty ? "" : "\(prefix) - ")A failing asynchronous sequence ran.")
        stream.finish()
        return stream
    }
}

// MARK: - AsyncValueStream

extension AsyncValueStream {
    /// Any asynchronous sequence that causes a test to fail if it runs.
    public static func unimplemented(_ prefix: String, placeholder: Element) -> Self {
        let stream = constant(placeholder)
        reportIssue("\(prefix.isEmpty ? "" : "\(prefix) - ")A failing asynchronous sequence ran.")
        return stream
    }
}
