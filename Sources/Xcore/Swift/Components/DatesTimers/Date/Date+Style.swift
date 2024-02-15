//
// Xcore
// Copyright © 2014 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

extension Date {
    /// An enumeration representing date and time style of a date object.
    public enum Style: Sendable, Hashable {
        /// A style that uses ISO 8601 representation.
        case iso8601(ISO8601DateFormatter.Options)

        /// A style that uses the date and time styles.
        case dateTime(DateFormatter.Style, time: DateFormatter.Style)

        /// A style that uses the same style for date and time.
        public static func dateTime(_ style: DateFormatter.Style) -> Self {
            dateTime(style, time: style)
        }

        /// A style that uses the date style.
        public static func date(_ style: DateFormatter.Style) -> Self {
            dateTime(style, time: .none)
        }

        /// A style that uses the time style.
        public static func time(_ style: DateFormatter.Style) -> Self {
            dateTime(.none, time: style)
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
        case weekdayName(Width)

        /// A style that uses the month in calendar.
        ///
        /// - Parameter width: The width of the month name.
        case monthName(Width)

        /// A style that uses the ordinal month day in calendar (e.g., June 4th).
        ///
        /// ```swift
        /// Date().formatted(style: .monthDayOrdinal(.wide)) // June 4th
        /// Date().formatted(style: .monthDayOrdinal(.abbreviated)) // Jun 4th
        /// Date().formatted(style: .monthDayOrdinal(.narrow)) // J 4th
        ///
        /// // With Period
        /// Date().formatted(style: .monthDayOrdinal(.wide, withPeriod: true)) // June 4th
        /// Date().formatted(style: .monthDayOrdinal(.abbreviated, withPeriod: true)) // Jun. 4th
        /// Date().formatted(style: .monthDayOrdinal(.narrow, withPeriod: true)) // J. 4th
        /// ```
        ///
        /// - Parameter width: The width of the month name.
        case monthDayOrdinal(Width, withPeriod: Bool = false)

        case format(Format)
    }
}

// MARK: - Style.Width

extension Date.Style {
    public enum Width: String, Sendable, Hashable {
        /// A style that uses full representation of units.
        ///
        /// **Month Name**
        ///
        /// ```swift
        /// let monthName = Date().formatted(style: .monthName(.wide))
        /// print(monthName)
        /// // For English in the Gregorian calendar, returns month name such as:
        /// // "January", "February", "March", "April", "May", "June", "July", "August",
        /// // "September", "October", "November", "December".
        /// ```
        ///
        /// **Weekday Name**
        ///
        /// ```swift
        /// let weekdayName = Date().formatted(style: .weekdayName(.wide))
        /// print(weekdayName)
        /// // For English in the Gregorian calendar, returns weekday name such as:
        /// // "Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday",
        /// // "Saturday".
        /// ```
        case wide

        /// A style that uses abbreviated units.
        ///
        /// **Month Name**
        ///
        /// ```swift
        /// let monthName = Date().formatted(style: .monthName(.abbreviated))
        /// print(monthName)
        /// // For English in the Gregorian calendar, returns shorter-named month such
        /// // as:
        /// // "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct",
        /// // "Nov", "Dec".
        /// ```
        ///
        /// **Weekday Name**
        ///
        /// ```swift
        /// let weekdayName = Date().formatted(style: .weekdayName(.abbreviated))
        /// print(weekdayName)
        /// // For English in the Gregorian calendar, returns shorter-named weekday name
        /// // such as:
        /// // "Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat".
        /// ```
        case abbreviated

        /// A style that uses the shortest units.
        ///
        /// **Month Name**
        ///
        /// ```swift
        /// let monthName = Date().formatted(style: .monthName(.narrow))
        /// print(monthName)
        /// // For English in the Gregorian calendar, returns very-shortly-named month
        /// // name such as:
        /// // "J", "F", "M", "A", "M", "J", "J", "A", "S", "O", "N", "D".
        /// ```
        ///
        /// **Weekday Name**
        ///
        /// ```swift
        /// let weekdayName = Date().formatted(style: .weekdayName(.narrow))
        /// print(weekdayName)
        /// // For English in the Gregorian calendar, returns very-shortly-named weekday
        /// // name such as:
        /// // "S", "M", "T", "W", "T", "F", "S".
        /// ```
        case narrow
    }
}

// MARK: - Style.Format

extension Date.Style {
    public typealias Format = Identifier<Self>
}

// MARK: - Built-in Style.Format

extension Date.Style.Format {
    /// `yyyy-MM-dd'T'HH:mm:ss.SSSZ` (e.g., 2020-06-04T00:00:00.000+0000)
    public static let iso8601: Self = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"

    /// `yyyy-MM-dd'T'HH:mm:ss` (e.g., 2020-06-04T00:00:00)
    public static let iso8601Local: Self = "yyyy-MM-dd'T'HH:mm:ss"

    /// `yyyy` (e.g., 2020)
    public static let year: Self = "yyyy"

    /// `MMMM d, yyyy` (e.g., June 4, 2020) // wide
    public static var monthDayYear: Self { monthDayYear(.wide) }

    /// `MMMM d` (e.g., June 4) // wide
    public static var monthDay: Self { monthDay(.wide) }

    /// `MMMM yyyy` (e.g., June 2020) // wide
    public static var monthYear: Self { monthYear(.wide) }

    /// ```swift
    /// `MMMM d, yyyy` (e.g., June 4, 2020) // wide
    /// `MMM d, yyyy` (e.g., Jun 4, 2020) // abbreviated
    /// `M/d/yy` (e.g., 6/4/20) // narrow
    /// ```
    public static func monthDayYear(_ width: Date.Style.Width, withTime: Bool = false) -> Self {
        let format: String
        let suffix = withTime ? " - h:mm a" : ""

        switch width {
            case .wide:
                format = "MMMM d, yyyy"
            case .abbreviated:
                format = "MMM d, yyyy"
            case .narrow:
                format = "M/d/yy"
        }

        return .init(rawValue: "\(format)\(suffix)")
    }

    /// ```swift
    /// `MMMM d` (e.g., June 4) // wide
    /// `MMM d` (e.g., Jun 4) // abbreviated
    /// `M/d` (e.g., 6/4) // narrow
    /// ```
    public static func monthDay(_ width: Date.Style.Width, withTime: Bool = false) -> Self {
        let format: String
        let suffix = withTime ? " - h:mm a" : ""

        switch width {
            case .wide:
                format = "MMMM d"
            case .abbreviated:
                format = "MMM d"
            case .narrow:
                format = "M/d"
        }

        return .init(rawValue: "\(format)\(suffix)")
    }

    /// ```swift
    /// `MMMM yyyy` (e.g., June 2020) // wide
    /// `MMM yyyy` (e.g., Jun 2020) // abbreviated
    /// `M/yy` (e.g., 6/20) // narrow
    /// ```
    public static func monthYear(_ width: Date.Style.Width, withTime: Bool = false) -> Self {
        let format: String
        let suffix = withTime ? " - h:mm a" : ""

        switch width {
            case .wide:
                format = "MMMM yyyy"
            case .abbreviated:
                format = "MMM yyyy"
            case .narrow:
                format = "M/yy"
        }

        return .init(rawValue: "\(format)\(suffix)")
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
    public static var abbreviated: Self { date(.medium) }

    /// For example, `Jun 4, 2020 at 9:41 AM`
    public static var abbreviatedTime: Self { dateTime(.medium, time: .short) }

    /// For example, `6/4/20`
    public static var narrow: Self { date(.short) }

    /// For example, `6/4/20, 9:41 AM`
    public static var narrowTime: Self { dateTime(.short) }

    /// For example, `9:41 AM`
    public static var time: Self { time(.short) }
}
