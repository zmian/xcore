//
// PromiseKit+Extensions.swift
// Copyright © 2018 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

#if canImport(PromiseKit)
import PromiseKit

extension Promise {
    /// Like the `@discardableResult` attribute on a function declaration indicates
    /// that, although the function returns a value, the compiler shouldn’t generate
    /// a warning if the return value is unused.
    public func discardableResult() {}

    /// A convenience function to make sure the promise always succeed.
    public func asAlwaysSucceed() -> Promise<Void> {
        .init { seal in
            ensure {
                seal.fulfill(())
            }.discardableResult()
        }
    }
}

extension Promise where T: Collection, T: ExpressibleByArrayLiteral {
    /// A convenience function to make sure the promise always succeed.
    public func asAlwaysSucceed() -> Promise<T> {
        .init { seal in
            done {
                seal.fulfill($0)
            }.catch { _ in
                seal.fulfill([])
            }
        }
    }
}

extension Array where Element: Promise<Void> {
    /// Waits on all provided promises.
    ///
    /// `when(fulfilled:)` rejects as soon as one of the provided promises rejects.
    /// `when(resolved:)` waits on all provided promises and **never** rejects.
    /// `join(_:)` waits on all provided promises and rejects if any of the provided promises.
    ///
    /// ```
    /// [promise1, promise2, promise3].join().then { results in
    ///     for result in results where case .fulfilled(let value) {
    ///         //…
    ///     }
    /// }.catch { error in
    ///     // one or all of the promise rejected
    /// }
    /// ```
    /// - Returns: A new promise that resolves once all the provided promises resolve.
    /// - Note: The returned promise can be rejected if any one of the promises is rejected.
    public func join() -> Promise<Void> {
        .init { seal in
            let promises = self

            firstly {
                when(resolved: promises)
            }.done { results in
                for result in results {
                    if case .rejected(let error) = result {
                        seal.reject(error)
                        return
                    }
                }
                seal.fulfill(())
            }.catch { error in
                seal.reject(error)
            }
        }
    }
}

extension Array where Element == () -> Promise<Void> {
    /// Waits on all provided promises in **order**.
    ///
    /// - Returns: A new promise that resolves once all the provided promises resolve.
    /// - Note: The returned promise can be rejected if any one of the promises is rejected.
    public func orderedJoin() -> Promise<Void> {
        let promises = self
        let totalCount = promises.count
        var currentProcessIndex = 0

        func innerPromise(_ promises: [() -> Promise<Void>]) -> Promise<Void> {
            .init { seal in
                guard totalCount > currentProcessIndex else {
                    return seal.fulfill(())
                }

                firstly {
                    promises[currentProcessIndex]()
                }.then { () -> Promise<Void> in
                    currentProcessIndex += 1
                    return innerPromise(promises)
                }.done {
                    seal.fulfill(())
                }.catch { error in
                    seal.reject(error)
                }
            }
        }

        return innerPromise(promises)
    }
}

/// Waits on all provided promises in **order**.
///
/// - Returns: A new promise that resolves once all the provided promises resolve.
/// - Note: The returned promise can be rejected if any one of the promises is rejected.
public func orderedJoin<T>(_ promises: [() -> Promise<[T]>]) -> Promise<[T]> {
    let totalCount = promises.count
    var currentProcessIndex = 0

    func innerPromise(_ promises: [() -> Promise<[T]>], initialValue: [T]) -> Promise<[T]> {
        .init { seal in
            guard totalCount > currentProcessIndex else {
                return seal.fulfill(initialValue)
            }

            firstly {
                promises[currentProcessIndex]()
            }.then { values -> Promise<[T]> in
                currentProcessIndex += 1
                let aggregateValue = initialValue + values
                return innerPromise(promises, initialValue: aggregateValue)
            }.done { finalValue in
                seal.fulfill(finalValue)
            }.catch { error in
                seal.reject(error)
            }
        }
    }

    return innerPromise(promises, initialValue: [])
}

// MARK: - MultiplePromisesResponse

extension Promise {
    public struct MultiplePromisesResponse {
        public let values: [T]
        public let errors: [Error]

        public init(values: [T], errors: [Error]) {
            self.values = values
            self.errors = errors
        }
    }
}

public enum MultiplePromisesResolutionStrategy {
    /// Rejects as soon as one of the provided promises rejects.
    case rejectsIfAnyRejects
    /// Waits on all provided promises and **never** rejects.
    case neverRejects
}

/// Waits on all provided promises and resolves them using the given strategy.
///
/// - Parameters:
///   - promises: A list of promises to waits on before resolving to one final promise with the outcome.
///   - strategy: The strategy to use when resolving the given `promises` if they fail.
///               The default value is `.rejectsIfAnyRejects`.
/// - Returns: A new promise that resolves once all the provided promises resolve.
public func join<T>(_ promises: [Promise<[T]>], strategy: MultiplePromisesResolutionStrategy = .rejectsIfAnyRejects) -> Promise<Promise<T>.MultiplePromisesResponse> {
    .init { seal in
        when(resolved: promises).done { results in
            var values: [T] = []
            var errors: [Error] = []

            for result in results {
                switch result {
                    case .fulfilled(let value):
                        values += value
                    case .rejected(let error):
                        switch strategy {
                            case .rejectsIfAnyRejects:
                                seal.reject(error)
                                // Terminate the for-loop, we are done.
                                return
                            case .neverRejects:
                                errors.append(error)
                        }
                }
            }

            seal.fulfill(.init(values: values, errors: errors))
        }
    }
}

/// Repeatedly evaluates a promise `body` until a value satisfies the predicate.
///
/// `promiseWhile` produces a promise with the supplied `body` and then waits
/// for it to resolve. If the resolved value satisfies the predicate then the
/// returned promise will `fulfill`. Otherwise, it will produce a new promise.
/// The method continues to do this until the predicate is satisfied or an error
/// occurs.
///
/// **Example:**
/// ```swift
/// promiseUntil(
///     predicate: { $0.isEmailVerified == true },
///     body: getProfile,
///     retryDelay: 1,
///     maxRetrySeconds: 30
/// )
///
/// func getProfile() -> Promise<Profile> {
///     // fetch profile.
/// }
/// ```
///
/// - Parameters:
///   - predicate: A predicate that given `body` must satisfies.
///   - body: The promise to repeatedly evaluate until `predicate` is satisfied.
///   - retryDelay: Number of seconds delay before retying the `body` again.
///   - maxRetrySeconds: Maximum number of seconds before the `promise` fulfill
///                      if the given `predicate` isn't satisfied.
/// - Returns: A promise that is guaranteed to fulfill with a value that
///            satisfies the predicate, or reject.
public func promiseUntil<T>(
    predicate: @escaping (T) -> Bool,
    body: @escaping () -> Promise<T>,
    retryDelay: TimeInterval = 0,
    maxRetrySeconds: Int = 15
) -> Promise<T> {
    .init { seal in
        let maxTries = Int(maxRetrySeconds / Int(retryDelay))
        var numberOfPastTries = 0
        var isTimedOut: Bool {
            numberOfPastTries += 1
            return numberOfPastTries >= maxTries
        }

        func loop() {
            firstly {
                body()
            }.done { value -> Void in
                if predicate(value) || isTimedOut {
                    seal.fulfill(value)
                } else {
                    firstly {
                        after(seconds: retryDelay)
                    }.done {
                        loop()
                    }.catch { error in
                        seal.reject(error)
                    }
                }
            }.catch { error in
                seal.reject(error)
            }
        }

        loop()
    }
}
#endif
