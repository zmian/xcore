//
// Xcore
// Copyright © 2014 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

extension Date {
    /// An enumeration representing date and time style of a date object.
    public enum Style: Sendable, Hashable {
        /// A style that uses the date and time styles.
        case dateTime(FormatStyle.DateStyle, time: FormatStyle.TimeStyle)

        /// A style that omits time and uses the date style.
        public static func date(_ style: FormatStyle.DateStyle) -> Self {
            dateTime(style, time: .omitted)
        }

        /// A style that omits date and uses the time style.
        public static func time(_ style: FormatStyle.TimeStyle) -> Self {
            dateTime(.omitted, time: style)
        }

        /// A style to use when describing a relative date, for example “1 day ago” or
        /// “yesterday”.
        ///
        /// **Always Relative:**
        ///
        /// ```swift
        /// let relative = Date.Style.relative(until: .era)
        ///
        /// let yesterday = Date().adjusting(.day, by: -1)
        /// yesterday.formatted(style: relative) // "Yesterday"
        ///
        /// let twoMonthAgo = Date().adjusting(.month, by: -2)
        /// twoMonthAgo.formatted(style: relative) // "2 months ago"
        /// ```
        ///
        /// **Relative For 1 Month:**
        ///
        /// ```swift
        /// // Relative until one month and then outputs using `.date(.medium)` style.
        /// let relative = Date.Style.relative(until: .month)
        ///
        /// let yesterday = Date().adjusting(.day, by: -1)
        /// yesterday.formatted(style: relative) // "Yesterday"
        ///
        /// let twoMonthAgo = Date().adjusting(.month, by: -2)
        /// twoMonthAgo.formatted(style: relative) // "Jun 4, 2022"
        /// ```
        ///
        /// - Parameter until: The calendar component threshold until the date is styled
        ///   as a relative style. After the given threshold it outputs using
        ///   `.date(.medium) style (e.g., Jun 4, 2022)`.
        case relative(until: Calendar.Component)

        /// A style that uses the weekday in calendar.
        ///
        /// - Parameter width: The width of the weekday name.
        case weekdayName(FormatStyle.Symbol.Weekday)

        /// A style that uses the month in calendar.
        ///
        /// - Parameter width: The width of the month name.
        case monthName(FormatStyle.Symbol.Month)

        /// A style that uses the ordinal month day in calendar (e.g., June 4th).
        ///
        /// ```swift
        /// Date().formatted(style: .monthDayOrdinal(.wide)) // June 4th
        /// Date().formatted(style: .monthDayOrdinal(.abbreviated)) // Jun 4th
        /// Date().formatted(style: .monthDayOrdinal(.narrow)) // J 4th
        /// ```
        ///
        /// - Parameter width: The width of the month name.
        case monthDayOrdinal(FormatStyle.Symbol.Month)
    }
}

// MARK: - Weekday & Month Styles

extension Date.Style {
    /// A style that uses the weekday in calendar.
    ///
    /// For example, for English in the Gregorian calendar, returns one of these
    /// `"Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday",
    /// "Saturday"`.
    public static var weekdayName: Self { weekdayName(.wide) }

    /// A style that uses the month in calendar.
    ///
    /// For example, for English in the Gregorian calendar, returns one of these
    /// `"January", "February", "March", "April", "May", "June", "July", "August",
    /// "September", "October", "November", "December"`
    public static var monthName: Self { monthName(.wide) }

    /// A style that uses the ordinal month day in calendar (e.g., June 4th).
    public static var monthDayOrdinal: Self { monthDayOrdinal(.wide) }
}

// MARK: - Helper Date Format Style

extension Date.Style {
    /// For example, “1 day ago” or “yesterday” for a month and then outputs using
    /// `.abbreviated` style.
    public static var relative: Self { relative(until: .month) }

    /// For example, `June 4, 2020`
    public static var wide: Self { date(.long) }

    /// For example, `Jun 4, 2020`
    public static var medium: Self { date(.abbreviated) }

    /// For example, `Jun 4, 2020 at 9:41 AM`
    public static var mediumWithTime: Self { dateTime(.abbreviated, time: .shortened) }

    /// For example, `6/4/2020`
    public static var narrow: Self { date(.numeric) }

    /// For example, `6/4/2020, 9:41 AM`
    public static var narrowWithTime: Self { dateTime(.numeric, time: .shortened) }

    /// For example, `9:41 AM`
    public static var time: Self { time(.shortened) }
}
