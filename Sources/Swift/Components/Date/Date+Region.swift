//
// Xcore
// Copyright © 2014 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

extension Date {
    /// A container that holds a `Calendar`, `TimeZone` and `Locale` types.
    public struct Region: Hashable, Equatable {
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
            var calendar = identifier.map { Calendar(identifier: $0) } ?? .autoupdatingCurrent
            calendar.timeZone = timeZone
            calendar.locale = locale
            self.calendar = calendar
        }

        fileprivate init(calendar: Calendar, fallbackLocale: Locale) {
            self.locale = calendar.locale ?? fallbackLocale
            self.timeZone = calendar.timeZone
            self.calendar = calendar
        }
    }
}

// MARK: - CustomStringConvertible

extension Date.Region: CustomStringConvertible {
    /// Description of the object
    public var description: String {
        "calendar: \(calendar.identifier), timezone: \(timeZone.identifier), locale: \(locale.identifier)"
    }
}

// MARK: - Buit-in

extension Date.Region {
    /// The user’s current region.
    ///
    /// This region does not track changes that the user makes to their preferences.
    public static var current: Self {
        .init(calendar: .current, fallbackLocale: .current)
    }

    /// A region that tracks changes to user’s preferred region.
    ///
    /// If mutated, this region will no longer track the user’s preferred region.
    ///
    /// - Note: The autoupdating region will only compare equal to another
    /// autoupdating region.
    public static var autoupdatingCurrent: Self {
        .init(calendar: .autoupdatingCurrent, fallbackLocale: .autoupdatingCurrent)
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
