//
// PromiseKit+Extensions.swift
//
// Copyright © 2018 Xcore
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

import Foundation

#if canImport(PromiseKit)
// swiftlint:disable:next import_promiseKit
import PromiseKit

extension Promise {
    /// Like the `@discardableResult` attribute on a function declaration indicates
    /// that, although the function returns a value, the compiler shouldn’t generate
    /// a warning if the return value is unused.
    public func discardableResult() {}

    /// A convenience function to make sure the promise always succeed.
    public func asAlwaysSucceed() -> Promise<Void> {
        return Promise<Void> { seal in
            ensure {
                seal.fulfill(())
            }.discardableResult()
        }
    }
}

extension Promise where T: Collection, T: ExpressibleByArrayLiteral {
    /// A convenience function to make sure the promise always succeed.
    public func asAlwaysSucceed() -> Promise<T> {
        return Promise { seal in
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
        return Promise { seal in
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
            return Promise { seal in
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
        return Promise { seal in
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
public func join<T>(_ promises: [Promise<[T]>], strategy: MultiplePromisesResolutionStrategy = .rejectsIfAnyRejects) -> Promise<[T]> {
    return Promise { seal in
        firstly {
            when(resolved: promises)
        }.done { results in
            var values: [T] = []

            for result in results {
                switch result {
                    case .fulfilled(let value):
                        values += value
                    case .rejected(let error):
                        if strategy == .rejectsIfAnyRejects {
                            seal.reject(error)
                            return
                        }
                }
            }

            seal.fulfill(values)
        }.catch { error in
            seal.reject(error)
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
    return Promise { seal in
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
