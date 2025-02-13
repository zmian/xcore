//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

/// Provides functionality for address search completion based on partial search
/// string.
///
/// This client defines methods for performing address searches, resolving
/// search results into complete addresses, validating addresses, and observing
/// search updates in real time.
///
/// Implementations of this protocol may integrate with third-party APIs or
/// local search databases.
///
/// **Usage**
///
/// ```swift
/// class ViewModel {
///     @Dependency(\.addressSearch) var addressSearch
///
///     func address() async throws {
///         let address = try await addressSearch.query("One Apple Park Way")
///         print(address)
///     }
/// }
/// ```
///
/// The query parameter should be a **partial** or **full** address string,
/// similar to what users would enter in a search field.
public protocol AddressSearchClient: Sendable {
    /// Performs an address lookup based on a search query.
    ///
    /// The query string may contain a full or partial address, a point of interest,
    /// or any other location-based keyword. The search is performed locally and may
    /// integrate with external services if necessary.
    ///
    /// - Parameter query: A **natural language query** describing the location.
    /// - Returns: A `PostalAddress` object representing the best match.
    func query(_ query: String) async throws -> PostalAddress

    /// Updates the search query for a specific session.
    ///
    /// This method allows incremental search updates (e.g., when users type in a
    /// search field). The results can be observed via `observe(id:)`.
    ///
    /// - Parameters:
    ///   - query: The updated search query string.
    ///   - id: The unique identifier for the search session.
    func updateQuery(_ query: String, id: UUID)

    /// Resolves a search result into a complete address.
    ///
    /// Some search results may return incomplete or ambiguous data. This method
    /// attempts to retrieve the **full address**.
    ///
    /// - Parameter result: The search result to be resolved.
    /// - Returns: A fully resolved `PostalAddress`.
    func resolve(_ result: AddressSearchResult) async throws -> PostalAddress

    /// Validates an address and throws an error if invalid.
    ///
    /// This method ensures that an address meets formatting requirements and
    /// contains the necessary fields for use in transactions, deliveries, etc.
    ///
    /// - Parameter address: The `PostalAddress` to be validated.
    /// - Throws: An error if validation fails.
    func validate(_ address: PostalAddress) async throws

    /// Observes real-time search results for a specific session.
    ///
    /// This function provides an async stream of search results that updates as the
    /// user types. It enables **live search suggestions**.
    ///
    /// - Parameter id: The unique identifier for the search session.
    /// - Returns: An `AsyncStream` that emits an array of `AddressSearchResult`
    ///   objects.
    func observe(id: UUID) -> AsyncStream<[AddressSearchResult]>
}

// MARK: - Dependency

extension DependencyValues {
    private enum AddressSearchClientKey: DependencyKey {
        static let liveValue: AddressSearchClient = .live
        static let testValue: AddressSearchClient = .unimplemented
    }

    /// Provides functionality for address search completion based on partial search
    /// string.
    ///
    /// This client defines methods for performing address searches, resolving
    /// search results into complete addresses, validating addresses, and observing
    /// search updates in real time.
    ///
    /// **Usage**
    ///
    /// ```swift
    /// class ViewModel {
    ///     @Dependency(\.addressSearch) var addressSearch
    ///
    ///     func address() async throws {
    ///         let address = try await addressSearch.query("One Apple Park Way")
    ///         print(address)
    ///     }
    /// }
    /// ```
    ///
    /// The query parameter should be a **partial** or **full** address string,
    /// similar to what users would enter in a search field.
    public var addressSearch: AddressSearchClient {
        get { self[AddressSearchClientKey.self] }
        set { self[AddressSearchClientKey.self] = newValue }
    }
}
