//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

#if canImport(Combine)
// These extensions are ported from Effect type to AnyPublisher:
// https://github.com/pointfreeco/swift-composable-architecture/blob/main/Sources/ComposableArchitecture/Effect.swift
import Combine

extension AnyPublisher {
    /// Initializes any publisher that immediately emits the given value.
    ///
    /// - Parameter value: The value that is immediately emitted by the publisher.
    public init(value: Output) {
        self.init(Just(value).setFailureType(to: Failure.self))
    }

    /// Initializes any publisher that immediately fails with the given error.
    ///
    /// - Parameter error: The error that is immediately emitted by the publisher.
    public init(error: Failure) {
        self.init(Fail(error: error))
    }

    /// Any publisher that does nothing and completes immediately. Useful for
    /// situations where you must return a publisher, but you don't need to do
    /// anything.
    public static var none: Self {
        Combine.Empty(completeImmediately: true)
            .eraseToAnyPublisher()
    }

    /// Creates any publisher that can supply a single value asynchronously in the
    /// future.
    ///
    /// This can be helpful for converting APIs that are callback-based into ones
    /// that deal with ``Publisher``s.
    ///
    /// For example, to create any publisher that delivers an integer after waiting
    /// a second:
    ///
    /// ```swift
    /// AnyPublisher<Int, Never>.future { callback in
    ///     DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
    ///         callback(.success(42))
    ///     }
    /// }
    /// ```
    ///
    /// Note that you can only deliver a single value to the `callback`. If you send
    /// more they will be discarded:
    ///
    /// ```swift
    /// AnyPublisher<Int, Never>.future { callback in
    ///     DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
    ///         callback(.success(42))
    ///         callback(.success(1729)) // Will not be emitted by the publisher
    ///     }
    /// }
    /// ```
    ///
    /// - Parameter attemptToFulfill: A closure that takes a `callback` as an
    ///   argument which can be used to feed it `Result<Output, Failure>` values.
    public static func future(
        _ attemptToFulfill: @escaping (@escaping (Result<Output, Failure>) -> Void) -> Void
    ) -> Self {
        Deferred {
            Future(attemptToFulfill)
        }
        .eraseToAnyPublisher()
    }

    /// Any publisher that causes a test to fail if it runs.
    public static func unimplemented(_ prefix: String) -> Self {
        Deferred { () -> Self in
            XCTFail("\(prefix.isEmpty ? "" : "\(prefix) - ")A failing publisher ran.")
            return .none
        }
        .eraseToAnyPublisher()
    }
}

extension Publisher {
    /// Turns any publisher into an ``AnyPublisher`` that cannot fail by wrapping
    /// its output and failure into a result and then applying passed in function to
    /// it.
    ///
    /// ```swift
    /// case .buttonTapped:
    ///     return environment.fetchUser(id: 1)
    ///         .catchToResult(ProfileAction.userResponse)
    /// ```
    ///
    /// - Parameters:
    ///   - transform: A mapping function that converts `Result<Output,Failure>` to
    ///     another type.
    /// - Returns: Any publisher that wraps `self`.
    public func catchToResult<T>(
        _ transform: @escaping (Result<Output, Failure>) -> T
    ) -> AnyPublisher<T, Never> {
        self
            .map { transform(.success($0)) }
            .catch { Just(transform(.failure($0))) }
            .eraseToAnyPublisher()
    }

    /// Turns any publisher into an ``AnyPublisher`` that cannot fail by wrapping
    /// its output and failure into a result and then applying passed in function to
    /// it.
    ///
    /// ```swift
    /// case .buttonTapped:
    ///     return environment.fetchUser(id: 1)
    ///         .catchToResult()
    ///         .done { result in
    ///             // ...
    ///         }
    /// ```
    ///
    /// - Returns: Any publisher that wraps `self`.
    public func catchToResult() -> AnyPublisher<Result<Output, Failure>, Never> {
        catchToResult { $0 }
    }

    /// Runs the given publisher after ``self`` and returns the failure and errors
    /// of ``self`` without any transformation.
    ///
    /// ```swift
    /// fetchFriends()
    ///     .passthrough { [weak self] result in
    ///         self?.log(result)
    ///     }
    /// }
    /// ```
    ///
    /// - Parameters:
    ///   - publisher: A publisher to execute and return the result type of the
    ///     ``self``.
    /// - Returns: A publisher with output and failure passed down.
    public func passthrough<T, P>(
        _ publisher: @escaping (Result<Output, Failure>) -> P?
    ) -> AnyPublisher<Output, Failure> where T == P.Output, P: Publisher, Self.Failure == P.Failure {
        catchToResult { result -> AnyPublisher<Output, Failure> in
            guard let publisher = publisher(result) else {
                switch result {
                    case let .success(value):
                        return .init(value: value)
                    case let .failure(error):
                        return .init(error: error)
                }
            }

            return publisher
                .flatMap { _ -> AnyPublisher<Output, Failure> in
                    switch result {
                        case let .success(value):
                            return .init(value: value)
                        case let .failure(error):
                            return .init(error: error)
                    }
                }
                .eraseToAnyPublisher()
        }
        .flatMap { $0 }
        .eraseToAnyPublisher()
    }

    /// Runs the given publisher after ``self`` and returns the failure and errors
    /// of ``self`` without any transformation.
    ///
    /// ```swift
    /// fetchFriends()
    ///     .passthrough { [weak self] result in
    ///         self?.log(result)
    ///     }
    /// }
    /// ```
    ///
    /// - Parameters:
    ///   - publisher: A publisher to execute and return the result type of the
    ///     ``self``.
    /// - Returns: A publisher with output and failure passed down.
    public func passthrough<T, P>(
        _ publisher: @escaping (Result<Output, Failure>) -> P?
    ) -> AnyPublisher<Output, Failure> where T == P.Output, P: Publisher, P.Failure == Never {
        passthrough {
            publisher($0)?
                .setFailureType(to: Failure.self)
        }
    }
}

extension AnyPublisher where Failure == Error {
    /// Creates a new publisher by evaluating a throwing closure, capturing the
    /// returned value or immediately fails with the given error.
    ///
    /// - Parameter body: A throwing closure to evaluate.
    public init(catching body: () throws -> Output) {
        do {
            self.init(value: try body())
        } catch {
            self.init(error: error)
        }
    }

    /// Creates any publisher that can supply a single value asynchronously in the
    /// future by evaluating a throwing closure, capturing the returned value or
    /// failing with the given error.
    public static func future(
        catching body: @escaping () throws -> Output
    ) -> AnyPublisher {
        .future { callback in
            do {
                callback(.success(try body()))
            } catch {
                callback(.failure(error))
            }
        }
    }
}
#endif
