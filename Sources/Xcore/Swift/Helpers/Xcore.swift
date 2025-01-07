//
// Xcore
// Copyright © 2014 Xcore
// MIT license, see LICENSE file for details
//

import Foundation
@_exported import AnyCodable
@_exported import KeychainAccess
@_exported import Dependencies

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
