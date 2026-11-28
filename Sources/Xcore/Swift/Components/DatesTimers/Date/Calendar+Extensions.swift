//
// Xcore
// Copyright © 2014 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

extension Calendar: MutableAppliable {
    private static let defaultStorage = LockIsolated(Calendar.current)
    private static let defaultCodableStorage = LockIsolated(Calendar.iso)

    /// The default calendar, initially set to the `current` calendar.
    public static var `default`: Self {
        get { defaultStorage.value }
        set { defaultStorage.setValue(newValue) }
    }

    /// The default calendar used in ``DateCodingFormatStyle``.
    public static var defaultCodable: Self {
        get { defaultCodableStorage.value }
        set { defaultCodableStorage.setValue(newValue) }
    }

    /// Returns the `ISO` calendar with `en_US_POSIX` locale and `UTC` time zone.
    public static let iso = gregorian(timeZone: .utc, locale: .usPosix)
}

extension Calendar {
    /// Returns the `gregorian` calendar with the given time zone and locale.
    ///
    /// - Parameters:
    ///   - timeZone: The time zone of the calendar.
    ///   - locale: The locale of the calendar.
    /// - Returns: A `gregorian` calendar with the specified time zone and locale.
    public static func gregorian(
        timeZone: TimeZone = .autoupdatingCurrent,
        locale: Locale = .autoupdatingCurrent
    ) -> Self {
        Calendar(identifier: .gregorian).applying {
            $0.timeZone = timeZone
            $0.locale = locale
        }
    }
}
