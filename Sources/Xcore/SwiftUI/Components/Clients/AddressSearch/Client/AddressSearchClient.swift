//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

/// Provides functionality for address search completion based on partial search
/// string.
public protocol AddressSearchClient {
    /// Observes search results for the given id.
    func observe(id: UUID) -> AsyncStream<[AddressSearchResult]>

    /// Update search string for the given id.
    func update(id: UUID, searchString: String)

    /// Validates given address and throws an error if the address is invalid.
    func validate(address: PostalAddress) async throws

    /// Maps a search completion into an address object.
    func map(result: AddressSearchResult) async throws -> PostalAddress

    /// Searches for an address locally with a natural language query.
    func search(query: String) async throws -> PostalAddress
}

// MARK: - Dependency

extension DependencyValues {
    private struct AddressSearchClientKey: DependencyKey {
        static let defaultValue: AddressSearchClient = .live
    }

    /// Provides functionality for address search completion based on partial search
    /// string.
    public var addressSearch: AddressSearchClient {
        get { self[AddressSearchClientKey.self] }
        set { self[AddressSearchClientKey.self] = newValue }
    }

    /// Provides functionality for address search completion based on partial search
    /// string.
    @discardableResult
    public static func addressSearch(_ value: AddressSearchClient) -> Self.Type {
        self[\.addressSearch] = value
        return Self.self
    }
}
