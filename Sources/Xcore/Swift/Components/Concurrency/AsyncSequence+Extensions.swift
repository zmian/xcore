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
#endif
