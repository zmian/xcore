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
    private let base: CurrentValueSubject<Output, Failure>

    /// The value wrapped by this subject, published as a new element whenever it
    /// changes.
    public var value: Output {
        base.value
    }

    /// Creates a current value subject from the given subject.
    ///
    /// - Parameter subject: The base subject.
    public init(_ subject: CurrentValueSubject<Output, Failure>) {
        base = subject
    }

    public func receive<S>(subscriber: S) where S: Subscriber, Failure == S.Failure, Output == S.Input {
        base.subscribe(subscriber)
    }
}

// MARK: - Constant

extension ValuePublisher {
    /// An publisher that immediately publishes the given value. Useful for
    /// situations where you must return an publisher, but you don't need to do
    /// anything.
    ///
    /// - Parameter output: The constant output to publish.
    public static func constant(_ output: Output) -> Self {
        .init(.init(output))
    }
}
#endif
