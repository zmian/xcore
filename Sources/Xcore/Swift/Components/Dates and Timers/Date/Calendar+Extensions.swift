//
// Xcore
// Copyright © 2014 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

extension Calendar: MutableAppliable {
    public static var `default`: Self = .current

    /// Returns `ISO` calendar with `en_US_POSIX` locale and `GMT` time zone.
    public static let iso = Self(
        identifier: .gregorian
    ).applying {
        $0.timeZone = .gmt
        $0.locale = .usPosix
    }
}

extension Calendar {
    /// Returns `gregorian` calendar with user's `current` locale and given time zone.
    ///
    /// - Parameter timeZone: The time zone of the calendar.
    public static func gregorian(timeZone: TimeZone) -> Self {
        Calendar(identifier: .gregorian).applying {
            $0.timeZone = timeZone
            $0.locale = .current
        }
    }
}
