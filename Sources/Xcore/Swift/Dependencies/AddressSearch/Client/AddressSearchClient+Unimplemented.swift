//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

public struct UnimplementedAddressSearchClient: AddressSearchClient {
    public func query(_ query: String) async throws -> PostalAddress {
        reportIssue("\(Self.self).search is unimplemented")
        throw CancellationError()
    }

    public func updateQuery(_ query: String, id: UUID) {
        reportIssue("\(Self.self).update is unimplemented")
    }

    public func resolve(_ result: AddressSearchResult) async throws -> PostalAddress {
        reportIssue("\(Self.self).map is unimplemented")
        throw CancellationError()
    }

    public func validate(_ address: PostalAddress) async throws {
        reportIssue("\(Self.self).validate is unimplemented")
        throw CancellationError()
    }

    public func observe(id: UUID) -> AsyncStream<[AddressSearchResult]> {
        .init {
            reportIssue("\(Self.self).observe is unimplemented")
            $0.finish()
        }
    }
}

// MARK: - Dot Syntax Support

extension AddressSearchClient where Self == UnimplementedAddressSearchClient {
    /// Returns unimplemented variant of `AddressSearchClient`.
    public static var unimplemented: Self {
        .init()
    }
}
