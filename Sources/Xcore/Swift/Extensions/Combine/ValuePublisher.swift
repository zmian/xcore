//
// Xcore
// Copyright © 2022 Xcore
// MIT license, see LICENSE file for details
//

#if canImport(Combine)
import Combine

/// The ``ValuePublisher`` that wraps a single value and publishes a new element
/// whenever the value changes.
///
/// It's a lightweight wrapper over ``CurrentValueSubject`` that hides the
/// subject from the client to avoid publishing unintended values by outside
/// world.
public struct ValuePublisher<Output, Failure: Error>: Publisher {
    private let upstream: CurrentValueSubject<Output, Failure>

    public var value: Output {
        upstream.value
    }

    public init(_ subject: CurrentValueSubject<Output, Failure>) {
        upstream = subject
    }

    public func receive<S>(subscriber: S) where S: Subscriber, Failure == S.Failure, Output == S.Input {
        upstream.subscribe(subscriber)
    }
}
#endif
