//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

/// Represents the state of a data-loading operation.
///
/// Use this enumeration to track the lifecycle of an asynchronous data request.
/// It distinguishes between the following states:
/// - `idle`: No operation has begun.
/// - `loading`: The operation is in progress.
/// - `success`: The operation completed successfully, with an associated value.
/// - `failure`: The operation failed, with an associated error.
///
/// **Usage**
///
/// ```swift
/// var status: DataStatus<String, MyError> = .idle
///
/// // When beginning an operation:
/// status = .loading
///
/// // On success:
/// status = .success("Fetched Data")
///
/// // On failure:
/// status = .failure(.someError)
/// ```
@frozen
public enum DataStatus<Success, Failure: Error> {
    /// Indicates that no data operation has been initiated.
    case idle

    /// Indicates that the data operation is currently in progress.
    case loading

    /// Indicates a successful operation, storing the resulting value.
    case success(Success)

    /// Indicates that the data operation failed, storing the encountered error.
    case failure(Failure)
}

// MARK: - Conditional Conformance

extension DataStatus: Sendable where Success: Sendable {}
extension DataStatus: Equatable where Success: Equatable, Failure: Equatable {}
extension DataStatus: Hashable where Success: Hashable, Failure: Hashable {}

// MARK: - Helpers

extension DataStatus {
    /// A Boolean property indicating whether the current status case is `.idle`.
    public var isIdle: Bool {
        switch self {
            case .idle: true
            default: false
        }
    }

    /// A Boolean property indicating whether the current status case is `.loading`.
    public var isLoading: Bool {
        switch self {
            case .loading: true
            default: false
        }
    }

    /// A Boolean property indicating whether the current status case is `.success`.
    public var isSuccess: Bool {
        switch self {
            case .success: true
            default: false
        }
    }

    /// A Boolean property indicating whether the current status case is `.failure`.
    public var isFailure: Bool {
        switch self {
            case .failure: true
            default: false
        }
    }

    /// Returns the success value if the current status case is `.success`.
    public var value: Success? {
        switch self {
            case let .success(value): value
            default: nil
        }
    }

    /// Returns the error if the current status case is `.failure`.
    public var error: Failure? {
        switch self {
            case let .failure(error): error
            default: nil
        }
    }

    /// Returns a `Result` representing the operation outcome when the status case
    /// is either `.success` or `.failure`.
    public var result: Result<Success, Failure>? {
        switch self {
            case let .success(value):
                .success(value)
            case let .failure(error):
                .failure(error)
            case .idle, .loading:
                nil
        }
    }
}

// MARK: - Map

extension DataStatus {
    /// Returns a new `DataStatus`, mapping any success value using the given
    /// transformation.
    ///
    /// Use this method when you need to transform the value of a `DataStatus`
    /// instance when it represents a success. The following example transforms
    /// the integer success value of a `DataStatus` into a string:
    ///
    /// **Usage**
    ///
    /// ```swift
    /// func getNextInteger() -> DataStatus<Int, Error> { /* ... */ }
    ///
    /// let integerStatus = getNextInteger()
    /// // integerStatus == .success(5)
    /// let stringStatus = integerStatus.map { String($0) }
    /// // stringStatus == .success("5")
    /// ```
    ///
    /// - Parameter transform: A closure that takes the success value of the
    ///   instance.
    /// - Returns: A `DataStatus` instance with the result of evaluating `transform`
    ///   as the new success value if this instance represents a success.
    public consuming func map<NewSuccess>(_ transform: (Success) -> NewSuccess) -> DataStatus<NewSuccess, Failure> {
        flatMap { .success(transform($0)) }
    }

    /// Returns a new `DataStatus`, mapping any success value using the given
    /// transformation and unwrapping the produced result.
    ///
    /// Use this method to avoid a nested result when your transformation
    /// produces another `DataStatus` type.
    ///
    /// In this example, note the difference in the result of using `map` and
    /// `flatMap` with a transformation that returns a `DataStatus` type.
    ///
    /// **Usage**
    ///
    /// ```swift
    /// func getNextInteger() -> DataStatus<Int, Error> {
    ///     .success(4)
    /// }
    ///
    /// func getNextAfterInteger(_ n: Int) -> DataStatus<Int, Error> {
    ///     .success(n + 1)
    /// }
    ///
    /// let result = getNextInteger().map { getNextAfterInteger($0) }
    /// // result == .success(.success(5))
    ///
    /// let result = getNextInteger().flatMap { getNextAfterInteger($0) }
    /// // result == .success(5)
    /// ```
    ///
    /// - Parameter transform: A closure that takes the success value of the
    ///   instance.
    /// - Returns: A `DataStatus` instance with the result of evaluating `transform`
    ///   as the new success value if this instance represents a success.
    public consuming func flatMap<NewSuccess>(_ transform: (Success) -> DataStatus<NewSuccess, Failure>) -> DataStatus<NewSuccess, Failure> {
        switch self {
            case .idle:
                .idle
            case .loading:
                .loading
            case let .success(value):
                transform(value)
            case let .failure(error):
                .failure(error)
        }
    }
}

// MARK: - Map Error

extension DataStatus {
    /// Returns a new `DataStatus`, mapping any failure value using the given
    /// transformation.
    ///
    /// Use this method when you need to transform the value of a `DataStatus`
    /// instance when it represents a failure. The following example transforms
    /// the error value of a result by wrapping it in a custom `Error` type:
    ///
    /// **Usage**
    ///
    /// ```swift
    /// struct DatedError: Error {
    ///     var error: Error
    ///     var date: Date
    ///
    ///     init(_ error: Error) {
    ///         self.error = error
    ///         self.date = Date()
    ///     }
    /// }
    ///
    /// let result: DataStatus<Int, Error> = // ...
    /// // result == .failure(<error value>)
    ///
    /// let resultWithDatedError = result.mapError { DatedError($0) }
    /// // result == .failure(DatedError(error: <error value>, date: <date>))
    /// ```
    ///
    /// - Parameter transform: A closure that takes the failure value of the
    ///   instance.
    /// - Returns: A `DataStatus` instance with the result of evaluating `transform`
    ///   as the new failure value if this instance represents a failure.
    public consuming func mapError<NewFailure: Error>(_ transform: (Failure) -> NewFailure) -> DataStatus<Success, NewFailure> {
        flatMapError { .failure(transform($0)) }
    }

    /// Returns a new `DataStatus`, mapping any failure value using the given
    /// transformation and unwrapping the produced result.
    ///
    /// Use this method to avoid a nested result when your transformation
    /// produces another `DataStatus` type.
    ///
    /// In this example, note the difference in the result of using `mapError` and
    /// `flatMapError` with a transformation that returns a `DataStatus` type.
    ///
    /// **Usage**
    ///
    /// ```swift
    /// struct DatedError: Error {
    ///     var error: Error
    ///     var date: Date
    ///
    ///     init(_ error: Error) {
    ///         self.error = error
    ///         self.date = Date()
    ///     }
    /// }
    ///
    /// let result: DataStatus<Int, Error> = // ...
    /// // result == .failure(<error value>)
    ///
    /// let resultWithDatedError = result.flatMapError { .failure(DatedError($0)) }
    /// // result == .failure(DatedError(error: <error value>, date: <date>))
    /// ```
    ///
    /// - Parameter transform: A closure that takes the failure value of the
    ///   instance.
    /// - Returns: A `DataStatus` instance with the result of evaluating `transform`
    ///   as the new failure value if this instance represents a failure.
    public consuming func flatMapError<NewFailure: Error>(_ transform: (Failure) -> DataStatus<Success, NewFailure>) -> DataStatus<Success, NewFailure> {
        switch self {
            case .idle:
                .idle
            case .loading:
                .loading
            case let .success(value):
                .success(value)
            case let .failure(error):
                transform(error)
        }
    }
}

// MARK: - Result

extension DataStatus {
    /// Creates a new `DataStatus` instance from a `Result` value.
    ///
    /// This initializer maps a `Result` to a corresponding status: a `.success`
    /// result becomes `DataStatus.success`, and a `.failure` result becomes
    /// `DataStatus.failure`.
    ///
    /// **Usage**
    ///
    /// ```swift
    /// let result: Result<String, MyError> = .success("Data")
    /// let status = DataStatus(result)
    /// print(status) // DataStatus.success("Data")
    /// ```
    ///
    /// - Parameter result: A `Result` value containing either a success with an
    ///   associated value, or a failure with an associated error.
    public init(_ result: Result<Success, Failure>) {
        switch result {
            case let .success(value):
                self = .success(value)
            case let .failure(error):
                self = .failure(error)
        }
    }
}

// MARK: - Void

extension DataStatus where Success == Void {
    /// A success, storing a void `Success` value.
    public static var success: Self {
        .success(())
    }
}

// MARK: - Empty

extension DataStatus where Success == Empty {
    /// A success, storing an empty `Success` value.
    public static var success: Self {
        .success(Empty())
    }
}

// MARK: - CancellationError

extension DataStatus {
    /// A Boolean value indicating whether the status is a `.failure` case with
    /// `CancellationError` as its error type.
    public var isCancelled: Bool {
        error is CancellationError
    }
}

// MARK: - isFailureOrEmpty

extension DataStatus where Success: Collection {
    /// A Boolean property indicating whether the status is failure or value
    /// collection is empty.
    public var isFailureOrEmpty: Bool {
        switch self {
            case .idle, .loading: false
            case let .success(value): value.isEmpty
            case .failure: true
        }
    }
}

extension DataStatus {
    /// A Boolean property indicating whether the status is failure.
    public var isFailureOrEmpty: Bool {
        isFailure
    }
}
