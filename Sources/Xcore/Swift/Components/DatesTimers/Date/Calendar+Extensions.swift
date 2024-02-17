//
// Xcore
// Copyright © 2014 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

extension Calendar: MutableAppliable {
    /// The default calendar, initially set to the `current` calendar.
    public static var `default`: Self = .current

    /// The default calendar used in ``DateCodingFormatStyle``.
    public static var defaultCodable: Self = .iso

    /// Returns the `ISO` calendar with `en_US_POSIX` locale and `UTC` time zone.
    public static let iso = Self(identifier: .gregorian).applying {
        $0.timeZone = .utc
        $0.locale = .usPosix
    }
}

extension Calendar {
    /// Returns the `gregorian` calendar with the given time zone and locale.
    ///
    /// - Parameters:
    ///   - timeZone: The time zone of the calendar.
    ///   - locale: The locale of the calendar.
    /// - Returns: A `gregorian` calendar with the specified time zone and locale.
    public static func gregorian(timeZone: TimeZone, locale: Locale = .current) -> Self {
        Calendar(identifier: .gregorian).applying {
            $0.timeZone = timeZone
            $0.locale = locale
        }
    }
}
