//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

public enum ReloadableDataStatus<Value: Hashable>: Hashable {
    case idle
    case loading
    case success(Value)
    case reloading(Value)
    case failure(AppError)
}

// MARK: - Helpers

extension ReloadableDataStatus {
    /// A Boolean property indicating whether current status case is `.idle`.
    public var isIdle: Bool {
        self == .idle
    }

    /// A Boolean property indicating whether current status case is `.loading`.
    public var isLoading: Bool {
        switch self {
            case .loading:
                return true
            default:
                return false
        }
    }

    /// A Boolean property indicating whether current status case is `.reloading`.
    public var isReloading: Bool {
        switch self {
            case .reloading:
                return true
            default:
                return false
        }
    }

    /// A Boolean property indicating whether current status case is `.success`.
    public var isSuccess: Bool {
        switch self {
            case .success:
                return true
            default:
                return false
        }
    }

    /// A Boolean property indicating whether current status case is `.failure`.
    public var isFailure: Bool {
        switch self {
            case .failure:
                return true
            default:
                return false
        }
    }

    /// Returns the value associated with `.success` and `.reloading` cases.
    public var value: Value? {
        switch self {
            case let .success(value), let .reloading(value):
                return value
            default:
                return nil
        }
    }

    /// Returns the error associated with `.failure` case.
    public var error: AppError? {
        switch self {
            case let .failure(error):
                return error
            default:
                return nil
        }
    }

    /// Returns the `AppResult` when `success`, `reloading` or `failure` values are available.
    public var result: AppResult<Value>? {
        switch self {
            case let .success(value), let .reloading(value):
                return .success(value)
            case let .failure(error):
                return .failure(error)
            case .idle, .loading:
                return nil
        }
    }

    public mutating func startLoading() {
        switch self {
            case let .success(value), let .reloading(value):
                self = .reloading(value)
            default:
                self = .loading
        }
    }
}

// MARK: - Map

extension ReloadableDataStatus {
    /// Returns a new `ReloadableDataStatus`, mapping any success value using the
    /// given transformation.
    ///
    /// - Parameter transform: A closure that takes the success value of the
    ///   instance.
    /// - Returns: A `ReloadableDataStatus` instance with the result of evaluating
    ///   transform as the new success value if this instance represents a success.
    public func mapSuccess<NewValue>(_ transform: (Value) -> NewValue) -> ReloadableDataStatus<NewValue> {
        switch self {
            case .idle:
                return .idle
            case .loading:
                return .loading
            case let .success(value):
                return .success(transform(value))
            case let .reloading(value):
                return .reloading(transform(value))
            case let .failure(error):
                return .failure(error)
        }
    }
}

// MARK: - AppResult

extension ReloadableDataStatus {
    public init(_ result: AppResult<Value>) {
        switch result {
            case let .success(value):
                self = .success(value)
            case let .failure(error):
                self = .failure(error)
        }
    }
}

extension ReloadableDataStatus where Value == Xcore.Empty {
    /// A success, storing a `Success` value.
    public static var success: Self {
        .success(Empty())
    }
}

// MARK: - isFailureOrEmpty

extension ReloadableDataStatus where Value: Collection {
    /// A Boolean property indicating whether the status is failure or value
    /// collection is empty.
    public var isFailureOrEmpty: Bool {
        switch self {
            case .idle, .loading:
                return false
            case let .success(value), let .reloading(value):
                return value.isEmpty
            case .failure:
                return true
        }
    }
}

extension ReloadableDataStatus {
    /// A Boolean property indicating whether the status is failure.
    public var isFailureOrEmpty: Bool {
        isFailure
    }
}
