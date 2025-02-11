//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI
import ComposableArchitecture

/// A reducer that handles address input, search, and validation.
///
/// `AddressForm` encapsulates the logic required to allow users to search for
/// an address, select a search result, edit the address if needed, and finally
/// validate and confirm the address.
///
/// **Usage**
///
/// ```swift
/// let store = Store(
///     initialState: .init(navigationTitle: "Enter Address"),
///     reducer: {
///         AddressForm()
///     }
/// )
/// ```
///
/// Parent views can subscribe to the store's `addressSuccess` action to be
/// notified of selected address.
@Reducer
public struct AddressForm: Sendable {
    @Dependency(\.addressSearch) private var addressSearch

    public init() {}

    // MARK: - State

    /// The state for the address input flow.
    ///
    /// It stores the current search query, search results, selected address,
    /// error messages, and various flags that control UI presentation (e.g.,
    /// whether the country or state picker is shown).
    @ObservableState
    public struct State: Equatable {
        /// A unique identifier for the current address input session.
        let id: UUID
        /// The title to be displayed in the navigation bar.
        let navigationTitle: String
        /// The current search query entered by the user.
        var search = ""
        /// The status of the search results (idle, loading, success, failure).
        var searchResults: DataStatus<[AddressSearchResult]> = .idle
        /// The currently selected postal address.
        var address = PostalAddress()
        /// A Boolean property indicating whether the address editor is visible.
        var isEditingAddress = false
        /// A Boolean property indicating whether the country picker is presented.
        var isCountryPickerPresented = false
        /// A Boolean property indicating whether the state picker is presented.
        var isStatePickerPresented = false
        /// An error encountered during address lookup.
        var lookupError: AppError?
        /// An error encountered during address validation.
        var validationError: AppError?
        /// A Boolean property indicating whether an address search or validation
        /// request is in progress.
        var isPerformingRequest = false

        /// Initializes the state with an optional navigation title.
        ///
        /// - Parameter navigationTitle: The title to display in the navigation bar.
        public init(navigationTitle: String = "") {
            @Dependency(\.uuid) var uuid
            self.id = uuid()
            self.navigationTitle = navigationTitle
        }
    }

    // MARK: - Action

    /// The actions that drive the address input flow.
    public enum Action: Sendable, Equatable, BindableAction {
        /// Indicates that the view has appeared.
        case onAppear
        /// Indicates that the view has disappeared.
        case onDisappear
        /// An action to bind state changes.
        case binding(BindingAction<State>)
        /// Carries the search results from an address search.
        case searchResult([AddressSearchResult])
        /// Indicates that a search result was tapped.
        case searchResultTapped(AddressSearchResult)
        /// Indicates that the search button was tapped.
        case searchButtonTapped
        /// Indicates that the "address not found" button was tapped.
        case addressNotFoundTapped
        /// Carries the result of a address lookup.
        case addressResult(AppResult<PostalAddress>)
        /// Indicates that the address confirmation button was tapped.
        case addressConfirmedButtonTapped
        /// Carries the result of an address validation request.
        case addressValidateResult(AppResult<Xcore.Empty>)
        /// Indicates a successful address validation with the confirmed address.
        case addressSuccess(PostalAddress)
        /// Toggles the flag indicating if a request is in progress.
        case isPerformingRequestToggle(Bool)
    }

    // MARK: - Reducer

    /// The reducer that processes actions and updates the state.
    public var body: some ReducerOf<Self> {
        BindingReducer()

        Reduce { state, action in
            enum CancelID { case search }

            switch action {
                case .onAppear:
                    return addressSearch
                        .observe(id: state.id)
                        .map(Action.searchResult)
                        .cancellable(id: CancelID.search)

                case .onDisappear:
                    return .cancel(id: CancelID.search)

                case .binding(\.search):
                    if !state.searchResults.isSuccess {
                        state.searchResults = .loading
                    }

                    addressSearch
                        .updateQuery(state.search, id: state.id)

                    return .none

                case let .searchResult(items):
                    state.searchResults = .success(items)
                    return .none

                case let .searchResultTapped(result):
                    state.isEditingAddress = true

                    return .run { send in
                        let result = await Action.addressResult(.init {
                            try await addressSearch.resolve(result)
                        })

                        await send(result)
                    }

                case .searchButtonTapped:
                    state.isEditingAddress = true

                    return .run { [query = state.search] send in
                        let result = await Action.addressResult(.init {
                            try await addressSearch.query(query)
                        })

                        await send(result)
                    }

                case .addressNotFoundTapped:
                    state.isEditingAddress = true
                    state.address = .init(countryCode: "US")
                    return .none

                case .binding(\.isEditingAddress):
                    if !state.isEditingAddress {
                        state.address = .init()
                    }
                    return .none

                case let .addressResult(.success(address)):
                    state.address = address
                    return .none

                case let .addressResult(.failure(error)):
                    state.lookupError = error
                    return .none

                case .binding(\.lookupError):
                    if state.lookupError == nil {
                        state.isEditingAddress = false
                    }
                    return .none

                case .addressConfirmedButtonTapped:
                    return .run { [address = state.address] send in
                        let result = await Action.addressValidateResult(.init {
                            try await addressSearch.validate(address)
                        })

                        await send(result)
                    }

                case .addressValidateResult(.success):
                    return .send(.addressSuccess(state.address))

                case let .addressValidateResult(.failure(error)):
                    state.validationError = error
                    return .none

                case .addressSuccess:
                    // Parent views should handle the success result accordingly.
                    return .none

                case let .isPerformingRequestToggle(value):
                    state.isPerformingRequest = value
                    return .none

                case .binding:
                    return .none
            }
        }
    }
}
