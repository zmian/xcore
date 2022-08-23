//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

public struct NoopAddressSearchClient: AddressSearchClient {
    public func observe(id: UUID) -> AsyncStream<[AddressSearchResult]> {
        .init { $0.finish() }
    }

    public func update(id: UUID, searchString: String) {}

    public func validate(address: PostalAddress) async throws {}

    public func map(result: AddressSearchResult) async throws -> PostalAddress {
        .init()
    }

    public func search(query: String) async throws -> PostalAddress {
        .init()
    }
}

// MARK: - Dot Syntax Support

extension AddressSearchClient where Self == NoopAddressSearchClient {
    /// Returns noop variant of `AddressSearchClient`.
    public static var noop: Self {
        .init()
    }
}
