//
// Xcore
// Copyright © 2022 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

#warning("TODO")
/*
extension AsyncSequence {
    /// Shares the output of an asynchronous sequence with multiple iterators.
    public func share() -> AsyncShareStream<Self> {
        AsyncShareStream(upstream: self)
    }
}

public final class AsyncShareStream<S: AsyncSequence>: AsyncSequence {
    public typealias Element = S.Element
    private let downstream = AsyncPassthroughStream<S.Element>()
    private let upstream: S
    private var upstreamIterator: S.AsyncIterator

    /// Creates an asynchronous sequence.
    fileprivate init(upstream: S) {
        self.upstream = upstream
        self.upstreamIterator = upstream.makeAsyncIterator()
    }
}

// MARK: - Iterator

extension AsyncShareStream {
    public func makeAsyncIterator() -> AsyncIterator {
        AsyncIterator(
            upstreamIterator: upstreamIterator,
            downstream: downstream
        )
    }

    public struct AsyncIterator: AsyncIteratorProtocol {
        fileprivate var upstreamIterator: S.AsyncIterator
        fileprivate var downstream: AsyncPassthroughStream<S.Element>

        public mutating func next() async rethrows -> S.Element? {
            guard !Task.isCancelled else {
                return nil
            }

            if let next = try await upstreamIterator.next() {
                downstream.send(next)
                return next
            } else {
                downstream.finish()
                return nil
            }
        }
    }
}
*/
