//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

public struct UnimplementedAddressSearchClient: AddressSearchClient {
    public func query(_ query: String) async throws -> PostalAddress {
        reportIssue(#"Unimplemented: @Dependency(\.addressSearch).query"#)
        throw CancellationError()
    }

    public func updateQuery(_ query: String, id: UUID) {
        reportIssue(#"Unimplemented: @Dependency(\.addressSearch).updateQuery"#)
    }

    public func resolve(_ result: AddressSearchResult) async throws -> PostalAddress {
        reportIssue(#"Unimplemented: @Dependency(\.addressSearch).resolve"#)
        throw CancellationError()
    }

    public func validate(_ address: PostalAddress) async throws {
        reportIssue(#"Unimplemented: @Dependency(\.addressSearch).validate"#)
        throw CancellationError()
    }

    public func observe(id: UUID) -> AsyncStream<[AddressSearchResult]> {
        .init { continuation in
            reportIssue(#"Unimplemented: @Dependency(\.addressSearch).observe"#)
            continuation.finish()
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