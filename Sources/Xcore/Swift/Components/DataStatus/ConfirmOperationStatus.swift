//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

/// A status to be used for operations that require user confirmation (typically
/// through an alert).
///
/// There are multiple places of the app where the flow goes like this:
/// 1. User performs action
/// 2. Alert is presented to confirm user's decision
/// 3. On confirmation, action is performed.
///
/// This always require at least two variables on the state: one holding a flag
/// to determinate if an alert needs to be presented, and one holding the status
/// of the operation (loading, success, failure).
///
/// This new `enum` allows to merge all these in one single variable, preventing
/// inconsistencies that can be caused by having multiple variables. Also, it
/// allows us to:
/// - Handle confirmations related to an item (previously achieved by having
///   `var itemForAlert: Item?` on the state).
/// - Handle confirmations related to a Boolean (previously achieved by having
///   `var showAlert: Bool` on the state).
/// - Handle loading operations inside the alert.
/// - Handle loading operations outside the alert
public enum ConfirmOperationStatus<Item: Hashable, Value: Hashable>: Hashable {
    /// The operation is idle.
    case idle

    /// The flow has been started, user needs to confirm the operation regarding the
    /// given item.
    ///
    /// - Note: that such `Item` can be an `Empty` struct.
    case waitingConfirmation(Item)

    /// The operation is currently being performed, and an associated item may be
    /// provided. If provided, such item must be the same used on the
    /// `.waitingConfirmation` state. However, we may want to avoid associating this
    /// state with the item depending on the use case.
    case loading(Item? = nil)

    /// The operation has finished successfully with the given `Value`.
    case success(Value)

    /// The operation has failed with the given `AppError`.
    case failure(AppError)
}

// MARK: - Helpers

extension ConfirmOperationStatus {
    /// A Boolean property indicating whether current status case is
    /// `.waitingConfirmation`.
    public var isWaitingConfirmation: Bool {
        switch self {
            case .waitingConfirmation:
                return true
            default:
                return false
        }
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

    /// A Boolean property indicating whether current status case is `.loading` or
    /// `.waitingConfirmation`.
    public var isLoadingOrWaitingConfirmation: Bool {
        switch self {
            case .loading, .waitingConfirmation:
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

    /// Returns the item associated with the `.waitingConfirmation` and `.loading`
    /// cases.
    public var item: Item? {
        switch self {
            case let .waitingConfirmation(item):
                return item
            case let .loading(item):
                return item
            default:
                return nil
        }
    }

    /// Returns the value associated with `.success` case.
    public var value: Value? {
        switch self {
            case let .success(value):
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

    /// Returns the `AppResult` when `success` or `failure` values are available.
    public var result: AppResult<Value>? {
        switch self {
            case let .success(value):
                return .success(value)
            case let .failure(error):
                return .failure(error)
            case .idle, .loading, .waitingConfirmation:
                return nil
        }
    }
}

extension ConfirmOperationStatus where Item == Xcore.Empty {
    /// The flow has been started, user needs to confirm the operation regarding the
    /// given item.
    public static var waitingConfirmation: Self {
        .waitingConfirmation(.init())
    }
}

extension ConfirmOperationStatus where Value == Xcore.Empty {
    /// The operation has finished successfully with `Empty` value.
    public static var success: Self {
        .success(.init())
    }
}

extension ConfirmOperationStatus {
    /// The operation is currently being performed and the associated item is `nil`.
    public static var loading: Self {
        .loading()
    }
}
