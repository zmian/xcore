//
// Xcore
// Copyright © 2022 Xcore
// MIT license, see LICENSE file for details
//

#if canImport(Combine)
import Combine
#endif

extension AsyncSequence {
    /// Used to expose an instance of `some AsyncSequence` to the client, rather
    /// than this async sequence’s actual type to preserve abstraction across API
    /// boundaries, such as different modules.
    @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
    public func eraseToAsyncSequence() -> some AsyncSequence<Element, Failure> {
        self
    }
}

#if canImport(Combine)
extension AsyncSequence where Self: Sendable {
    /// Converts the asynchronous sequence into a Combine publisher.
    ///
    /// Returns a publisher that emits each element from the async sequence and
    /// finishes when the sequence completes. It respects backpressure
    /// and can propagate thrown errors.
    ///
    /// - Returns: A publisher that emits values from the async sequence and handles
    ///   errors.
    @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
    public var publisher: some Publisher<Element, Failure> {
        let box = UncheckedSendable(PassthroughSubject<Element, Failure>())

        let task = Task {
            do {
                for try await value in self {
                    box.wrappedValue.send(value)
                }
                box.wrappedValue.send(completion: .finished)
            } catch let error as Failure {
                box.wrappedValue.send(completion: .failure(error))
            }
        }

        return box
            .wrappedValue
            .handleEvents(receiveCancel: {
                task.cancel()
            })
    }
}

extension AsyncStream where Element: Sendable {
    /// Returns a publisher that emits events when asynchronous sequence produces
    /// new elements.
    @available(iOS, introduced: 13.0, obsoleted: 18.0, message: "Use the newer AsyncSequence publisher API.")
    @available(macOS, introduced: 10.15, obsoleted: 15.0, message: "Use the newer AsyncSequence publisher API.")
    @available(tvOS, introduced: 13.0, obsoleted: 18.0, message: "Use the newer AsyncSequence publisher API.")
    @available(watchOS, introduced: 6.0, obsoleted: 11.0, message: "Use the newer AsyncSequence publisher API.")
    @available(visionOS, introduced: 1.0, obsoleted: 2.0, message: "Use the newer AsyncSequence publisher API.")
    public func publisher() -> some Publisher<Element, Never> {
        let box = UncheckedSendable(PassthroughSubject<Element, Never>())

        let task = Task {
            for await value in self {
                box.wrappedValue.send(value)
            }
            box.wrappedValue.send(completion: .finished)
        }

        return box
            .wrappedValue
            .handleEvents(receiveCancel: {
                task.cancel()
            })
    }
}
#endif
