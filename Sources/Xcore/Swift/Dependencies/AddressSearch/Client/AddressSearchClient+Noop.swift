//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

public struct NoopAddressSearchClient: AddressSearchClient {
    public func query(_ query: String) async throws -> PostalAddress {
        .init()
    }

    public func updateQuery(_ query: String, id: UUID) {}

    public func resolve(_ result: AddressSearchResult) async throws -> PostalAddress {
        .init()
    }

    public func validate(_ address: PostalAddress) async throws {}

    public func observe(id: UUID) -> AsyncStream<[AddressSearchResult]> {
        .finished
    }
}

// MARK: - Dot Syntax Support

extension AddressSearchClient where Self == NoopAddressSearchClient {
    /// Returns noop variant of `AddressSearchClient`.
    public static var noop: Self {
        .init()
    }
}
