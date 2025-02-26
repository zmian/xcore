//
// Xcore
// Copyright © 2017 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

/// A value that represents either a success or a failure as an `AppError`,
/// including an associated value in each case.
public typealias AppResult<Value> = Result<Value, AppError>

// MARK: - Result Helpers

extension Result where Failure == AppError {
    /// Creates a new result by evaluating an async throwing closure, capturing the
    /// returned value as a success, or any thrown error as an `AppError`.
    ///
    /// Any thrown error is attempted to cast to app error; otherwise
    /// `AppError.general` failure value is used.
    ///
    /// - Parameters:
    ///     - body: An async throwing closure to evaluate.
    ///     - fallbackError: The error to throw if `body` throws a non-AppError
    ///       instance.
    @_transparent
    public init(
        fallback fallbackError: @autoclosure () -> AppError = .general,
        catching body: @Sendable () async throws -> Success
    ) async {
        do {
            self = .success(try await body())
        } catch {
            self = .failure(error.asAppError(or: fallbackError()))
        }
    }
}

extension Result<Empty, AppError> {
    /// Creates a new result by evaluating an async throwing closure, capturing the
    /// returned value as a success, or any thrown error as an `AppError`.
    ///
    /// Any thrown error is attempted to cast to app error; otherwise
    /// `AppError.general` failure value is used.
    ///
    /// - Parameters:
    ///     - body: An async throwing closure to evaluate.
    ///     - fallbackError: The error to throw if `body` throws a non-AppError
    ///       instance.
    @_transparent
    public init(
        fallback fallbackError: @autoclosure () -> AppError = .general,
        catching body: @Sendable () async throws -> Void
    ) async {
        do {
            _ = try await body()
            self = .success
        } catch {
            self = .failure(error.asAppError(or: fallbackError()))
        }
    }
}
