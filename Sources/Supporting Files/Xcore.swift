//
// Xcore
// Copyright © 2014 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

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
