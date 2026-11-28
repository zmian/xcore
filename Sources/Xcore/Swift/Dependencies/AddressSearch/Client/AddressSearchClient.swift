//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

/// Provides functionality for address search completion based on partial search
/// string.
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
public struct AddressSearchClient: Sendable {
    /// Performs an address lookup based on a search query.
    public let query: @Sendable (String) async throws -> PostalAddress

    /// Updates the search query for a specific session.
    public let updateQuery: @Sendable (String, UUID) -> Void

    /// Resolves a search result into a complete address.
    public let resolve: @Sendable (AddressSearchResult) async throws -> PostalAddress

    /// Validates an address and throws an error if invalid.
    public let validate: @Sendable (PostalAddress) async throws -> Void

    /// Observes real-time search results for a specific session.
    public let observe: @Sendable (UUID) -> AsyncStream<[AddressSearchResult]>

    public init(
        query: @escaping @Sendable (String) async throws -> PostalAddress,
        updateQuery: @escaping @Sendable (String, UUID) -> Void,
        resolve: @escaping @Sendable (AddressSearchResult) async throws -> PostalAddress,
        validate: @escaping @Sendable (PostalAddress) async throws -> Void,
        observe: @escaping @Sendable (UUID) -> AsyncStream<[AddressSearchResult]>
    ) {
        self.query = query
        self.updateQuery = updateQuery
        self.resolve = resolve
        self.validate = validate
        self.observe = observe
    }
}

// MARK: - Variants

extension AddressSearchClient {
    /// Returns the noop variant of `AddressSearchClient`.
    public static var noop: Self {
        .init(
            query: { _ in .init() },
            updateQuery: { _, _ in },
            resolve: { _ in .init() },
            validate: { _ in },
            observe: { _ in .finished }
        )
    }

    /// Returns the unimplemented variant of `AddressSearchClient`.
    public static var unimplemented: Self {
        .init(
            query: { _ in
                reportIssue(#"Unimplemented: @Dependency(\.addressSearch).query"#)
                throw CancellationError()
            },
            updateQuery: { _, _ in
                reportIssue(#"Unimplemented: @Dependency(\.addressSearch).updateQuery"#)
            },
            resolve: { _ in
                reportIssue(#"Unimplemented: @Dependency(\.addressSearch).resolve"#)
                throw CancellationError()
            },
            validate: { _ in
                reportIssue(#"Unimplemented: @Dependency(\.addressSearch).validate"#)
                throw CancellationError()
            },
            observe: { _ in
                .init { continuation in
                    reportIssue(#"Unimplemented: @Dependency(\.addressSearch).observe"#)
                    continuation.finish()
                }
            }
        )
    }
}

// MARK: - Dependency

extension DependencyValues {
    private enum AddressSearchClientKey: DependencyKey {
        static let liveValue: AddressSearchClient = .live
        static let testValue: AddressSearchClient = .unimplemented
        static let previewValue: AddressSearchClient = .noop
    }

    /// Provides functionality for address search completion based on partial search
    /// string.
    public var addressSearch: AddressSearchClient {
        get { self[AddressSearchClientKey.self] }
        set { self[AddressSearchClientKey.self] = newValue }
    }
}