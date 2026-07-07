//
// Xcore
// Copyright © 2014 Xcore
// MIT license, see LICENSE file for details
//

public import Foundation
@_exported public import AnyCodable
@_exported public import KeychainAccess
@_exported public import Dependencies

// MARK: - Bundle

extension Bundle {
    private class XcoreMarker {}
    public static var xcore: Bundle {
        #if SWIFT_PACKAGE
        return .module
        #else
        return .init(for: XcoreMarker.self)
        #endif
    }
}

extension AnyCodable {
    public static func from(_ value: any Sendable) -> Self {
        self.init(value)
    }
}
