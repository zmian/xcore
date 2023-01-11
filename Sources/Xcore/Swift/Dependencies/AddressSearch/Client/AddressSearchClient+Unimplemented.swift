//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

public struct UnimplementedAddressSearchClient: AddressSearchClient {
    public func observe(id: UUID) -> AsyncStream<[AddressSearchResult]> {
        .init {
            XCTFail("\(Self.self).observe is unimplemented")
            $0.finish()
        }
    }

    public func update(id: UUID, searchString: String) {
        XCTFail("\(Self.self).update is unimplemented")
    }

    public func validate(address: PostalAddress) async throws {
        XCTFail("\(Self.self).validate is unimplemented")
        throw CancellationError()
    }

    public func map(result: AddressSearchResult) async throws -> PostalAddress {
        XCTFail("\(Self.self).map is unimplemented")
        throw CancellationError()
    }

    public func search(query: String) async throws -> PostalAddress {
        XCTFail("\(Self.self).search is unimplemented")
        throw CancellationError()
    }
}

// MARK: - Dot Syntax Support

extension AddressSearchClient where Self == UnimplementedAddressSearchClient {
    /// Returns unimplemented variant of `AddressSearchClient`.
    public static var unimplemented: Self {
        .init()
    }
}
