//
// Xcore
// Copyright © 2014 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

extension Date {
    /// A container that holds a `Calendar`, `TimeZone` and `Locale` types.
    public struct Region {
        public let calendar: Calendar
        public let timeZone: TimeZone
        public let locale: Locale

        public init(
            calendar identifier: Calendar.Identifier? = nil,
            timeZone: TimeZone,
            locale: Locale
        ) {
            self.locale = locale
            self.timeZone = timeZone
            var calendar: Calendar = identifier.map { .init(identifier: $0) } ?? .current
            calendar.timeZone = timeZone
            calendar.locale = locale
            self.calendar = calendar
        }
    }
}

extension Date.Region {
    public static var current: Self {
        .init(calendar: .gregorian, timeZone: .current, locale: .current)
    }

    public static var iso: Self {
        .init(calendar: .gregorian, timeZone: .utc, locale: .usPosix)
    }

    public static var gregorianUtc: Self {
        .init(calendar: .gregorian, timeZone: .utc, locale: .current)
    }

    public static var usEastern: Self {
        .init(calendar: .gregorian, timeZone: .eastern, locale: .current)
    }
}
