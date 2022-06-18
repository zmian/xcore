//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

#if canImport(Combine)
import Combine

extension Publisher where Failure == Never {
    /// Attaches a subscriber with closure-based behavior to a publisher that never
    /// fails.
    ///
    /// Use ``Publisher/done(_:)`` to observe value received by the publisher
    /// **once** and then automatically release the cancellable token.
    ///
    /// - Parameter receiveValue: The closure to execute on receipt of a value.
    public func done(_ receiveValue: @escaping ((Output) -> Void)) {
        var cancellable: AnyCancellable?

        cancellable = sink { output in
            receiveValue(output)
            if let token = cancellable {
                cancellables.remove(token)
                cancellable = nil
            }
        }

        if let cancellable = cancellable {
            cancellables.insert(cancellable)
        }
    }
}

extension Publisher {
    public func eraseToVoid() -> Publishers.Map<Self, Void> {
        map { _ in () }
    }

    /// Erases the publisher output to void and then turns it into an
    /// ``AnyPublisher``.
    public func eraseToVoidAnyPublisher() -> AnyPublisher<Void, Failure> {
        eraseToVoid()
            .eraseToAnyPublisher()
    }
}

extension Publisher where Failure == Never {
    public func eraseToVoidAndError<E: Error>(to failureType: E.Type) -> Publishers.SetFailureType<Publishers.Map<Self, Void>, E> {
        eraseToVoid()
            .setFailureType(to: failureType)
    }
}

extension Publisher {
    /// Publishes any value that satisfy the given predicate.
    public func match(_ predicate: @escaping (Output) -> Bool) -> AnyPublisher<Void, Failure> {
        compactMap { predicate($0) ? $0 : nil }
            .eraseToVoid()
            .eraseToAnyPublisher()
    }

    /// Publishes any value that equals the given value.
    public func when(_ value: Output) -> AnyPublisher<Void, Failure> where Output: Equatable {
        match { $0 == value }
    }
}

private var cancellables = Set<AnyCancellable>()
#endif
