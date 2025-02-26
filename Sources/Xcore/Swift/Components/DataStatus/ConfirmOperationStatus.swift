//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

/// Represents the status of an operation that requires user confirmation.
///
/// This enumeration is used to manage the lifecycle of operations that require
/// user confirmation (typically via an alert). It merges multiple state
/// variables into one, reducing the risk of inconsistencies. For example,
/// rather than using a separate flag for displaying an alert and another for
/// the operation status, this type encapsulates both. It can handle operations
/// related to an item, a Boolean value, and loading operations both inside and
/// outside an alert.
///
/// Typically multiple areas in any given app follow this workflow:
/// 1. The user performs an action.
/// 2. An alert is presented to confirm the user's decision.
/// 3. Upon confirmation, the corresponding action is executed.
///
/// **Usage**
///
/// ```swift
/// var closeAccountStatus: ConfirmOperationStatus<Empty, Empty, MyError> = .idle
///
/// // 1. Close account button tapped
/// closeAccountStatus = .waitingConfirmation
///
/// // 2. Present alert
/// var showCloseAccountAlert = closeAccountStatus.isLoadingOrWaitingConfirmation
///
/// // 3. Once confirmed
/// do {
///     closeAccountStatus = .loading
///     try closeAccount()
///     // account closing operation completed successfully
///     closeAccountStatus = .success
/// } catch {
///     // account closing operation failed
///     closeAccountStatus = .failure(error)
/// }
/// ```
///
/// **Usage**
///
/// ```swift
/// struct Place: Identifiable {
///     let id = UUID()
///     let name: String
/// }
///
/// struct FavoritesView: View {
///     @State var removePlaceStatus = ConfirmOperationStatus<Place, Empty, Error>.idle
///     @State var places = [
///         Place(name: "New York"),
///         Place(name: "London"),
///         Place(name: "Paris"),
///         Place(name: "Miami")
///     ]
///
///     var body: some View {
///         List(places) { place in
///             Text(place.name)
///                 .swipeActions {
///                     Button("Unfavorite", role: .destructive) {
///                         removePlaceStatus = .waitingConfirmation(place)
///                     }
///                 }
///         }
///         .alert("Unfavorite Place", isPresented: showAlert, presenting: removePlaceStatus.item) { _ in
///             Button.no {
///                 removePlaceStatus = .idle
///             }
///
///             Button.yes {
///                 guard let place = removePlaceStatus.item else {
///                     return
///                 }
///
///                 do {
///                     removePlaceStatus = .loading(place)
///                     try removePlace(place)
///                     removePlaceStatus = .success
///                 } catch {
///                     removePlaceStatus = .failure(error)
///                 }
///             }
///         } message: { place in
///             Text("Are you sure you want to unfavorite \(place.name)?")
///         }
///         .alert("Unable to Unfavorite", isPresented: showError, presenting: removePlaceStatus.error) { error in
///             Button.okay {
///                 removePlaceStatus = .idle
///             }
///         } message: { error in
///             Text(error.message)
///         }
///     }
///
///     private func removePlace(_ place: Place) throws {
///         guard let index = places.firstIndex(where: { $0.id == place.id }) else {
///             throw AppError(
///                 id: "place_not_found",
///                 title: "\(place.name) not found",
///                 message: "\(place.name) not found in your favorites. Please refresh and try again."
///             )
///         }
///
///         places.remove(at: index)
///     }
///
///     private var showAlert: Binding<Bool> {
///         .constant(removePlaceStatus.item.isNotNil)
///     }
///
///     private var showError: Binding<Bool> {
///         .constant(removePlaceStatus.error.isNotNil)
///     }
/// }
/// ```
@frozen
public enum ConfirmOperationStatus<Item, Success, Failure: Error> {
    /// Indicates that no data operation has been initiated.
    case idle

    /// Indicates that the data operation is currently in progress.
    ///
    /// The operation flow has been initiated; the user needs to confirm the
    /// operation regarding the given item.
    ///
    /// - Note: The `Item` may be an instance of an `Empty` struct.
    case waitingConfirmation(Item)

    /// Indicates that the data operation is currently in progress.
    ///
    /// If an associated item is provided, it must be the same as the one used in
    /// the `.waitingConfirmation` state. Depending on the use case, the item may
    /// be omitted.
    case loading(Item? = nil)

    /// Indicates a successful operation, storing the resulting value.
    case success(Success)

    /// Indicates that the data operation failed, storing the encountered error.
    case failure(Failure)
}

// MARK: - Conditional Conformance

extension ConfirmOperationStatus: Sendable where Item: Sendable, Success: Sendable {}
extension ConfirmOperationStatus: Equatable where Item: Equatable, Success: Equatable, Failure: Equatable {}
extension ConfirmOperationStatus: Hashable where Item: Hashable, Success: Hashable, Failure: Hashable {}

// MARK: - Helpers

extension ConfirmOperationStatus {
    /// A Boolean property indicating whether the current status case is `.idle`.
    public var isIdle: Bool {
        switch self {
            case .idle: true
            default: false
        }
    }

    /// A Boolean property indicating whether the current status case is
    /// `.waitingConfirmation`.
    public var isWaitingConfirmation: Bool {
        switch self {
            case .waitingConfirmation:  true
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

    /// A Boolean property indicating whether the current status case is either
    /// `.loading` or `.waitingConfirmation`.
    public var isLoadingOrWaitingConfirmation: Bool {
        switch self {
            case .loading, .waitingConfirmation: true
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

    /// Returns the item associated with the `.waitingConfirmation` and `.loading`
    /// cases.
    public var item: Item? {
        switch self {
            case let .waitingConfirmation(item): item
            case let .loading(item): item
            default: nil
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
            default:
                nil
        }
    }
}

// MARK: - Result

extension ConfirmOperationStatus {
    /// Creates a new `ConfirmOperationStatus` instance from a `Result` value.
    ///
    /// This initializer maps a `Result` to a corresponding status: a `.success`
    /// result becomes `ConfirmOperationStatus.success`, and a `.failure` result
    /// becomes `ConfirmOperationStatus.failure`.
    ///
    /// **Usage**
    ///
    /// ```swift
    /// let result: Result<String, MyError> = .success("Data")
    /// let status = ConfirmOperationStatus(result)
    /// print(status) // ConfirmOperationStatus.success("Data")
    /// ```
    ///
    /// - Parameter result: A `Result` containing either a success value or an error.
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

extension ConfirmOperationStatus where Success == Void {
    /// Returns a status representing a successful operation with no associated value.
    public static var success: Self {
        .success(())
    }
}

extension ConfirmOperationStatus where Item == Void {
    /// Returns a status indicating that the confirmation flow has been started
    /// with no associated item.
    public static var waitingConfirmation: Self {
        .waitingConfirmation(())
    }
}

// MARK: - Empty

extension ConfirmOperationStatus where Success == Empty {
    /// Returns a status representing a successful operation with an `Empty` value.
    public static var success: Self {
        .success(.init())
    }
}

extension ConfirmOperationStatus where Item == Empty {
    /// Returns a status indicating that the confirmation flow has been started
    /// with an `Empty` item.
    public static var waitingConfirmation: Self {
        .waitingConfirmation(.init())
    }
}

// MARK: - Loading

extension ConfirmOperationStatus {
    /// Returns a status representing a loading operation with no associated item.
    public static var loading: Self {
        .loading()
    }
}

// MARK: - CancellationError

extension ConfirmOperationStatus {
    /// A Boolean value indicating whether the status is a `.failure` case with
    /// `CancellationError` as its error type.
    public var isCancelled: Bool {
        error is CancellationError
    }
}
