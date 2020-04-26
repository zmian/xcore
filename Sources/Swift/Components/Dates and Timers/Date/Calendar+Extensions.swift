//
// Xcore
// Copyright © 2014 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

extension Calendar: MutableAppliable {
    public static var `default`: Self = .current

    public static let iso = Self(
        identifier: .gregorian
    ).applying {
        $0.timeZone = .gmt
        $0.locale = .usPosix
    }
}
