//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

public struct UnimplementedAddressSearchClient: AddressSearchClient {
    public func query(_ query: String) async throws -> PostalAddress {
        IssueReporting.unimplemented("\(AddressSearchClient.self).search")
        throw CancellationError()
    }

    public func updateQuery(_ query: String, id: UUID) {
        IssueReporting.unimplemented("\(AddressSearchClient.self).updateQuery")
    }

    public func resolve(_ result: AddressSearchResult) async throws -> PostalAddress {
        IssueReporting.unimplemented("\(AddressSearchClient.self).resolve")
        throw CancellationError()
    }

    public func validate(_ address: PostalAddress) async throws {
        IssueReporting.unimplemented("\(AddressSearchClient.self).validate")
        throw CancellationError()
    }

    public func observe(id: UUID) -> AsyncStream<[AddressSearchResult]> {
        .init {
            IssueReporting.unimplemented("\(AddressSearchClient.self).observe")
            $0.finish()
        }
    }
}

// MARK: - Dot Syntax Support

extension AddressSearchClient where Self == UnimplementedAddressSearchClient {
    /// Returns the unimplemented variant of `AddressSearchClient`.
    public static var unimplemented: Self {
        .init()
    }
}
