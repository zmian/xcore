//
// Xcore
// Copyright © 2020 Xcore
// MIT license, see LICENSE file for details
//

// MARK: - Void

extension Result where Success == Void {
    /// A success, storing a void `Success` value.
    public static var success: Self {
        .success(())
    }
}

// MARK: - Empty

extension Result where Success == Empty {
    /// A success, storing an empty `Success` value.
    public static var success: Self {
        .success(Empty())
    }
}

// MARK: - Associated Values

extension Result {
    /// Returns the value associated with `.success` case.
    public var value: Success? {
        switch self {
            case let .success(value): value
            default: nil
        }
    }

    /// Returns the error associated with `.failure` case.
    public var error: Failure? {
        switch self {
            case let .failure(error): error
            default: nil
        }
    }
}

// MARK: - CancellationError

extension Result where Failure: Error {
    /// A Boolean value indicating whether the result is a `.failure` case with
    /// `CancellationError` as its error type.
    public var isCancelled: Bool {
        error is CancellationError
    }
}
