//
// Xcore
// Copyright © 2014 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

// MARK: - Bundle

private class XcoreMarker { }
extension Bundle {
    public static var xcore: Bundle {
        .init(for: XcoreMarker.self)
    }
}
