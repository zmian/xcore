//
// Xcore
// Copyright © 2014 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

extension Date {
    /// An enumeration representing date and time style of a date object.
    public enum Style: Hashable, Sendable {
        case date(DateFormatter.Style)
        case time(DateFormatter.Style)
        case dateTime(DateFormatter.Style)
        case iso8601(ISO8601DateFormatter.Options)

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
    public enum Width: String, Hashable, Sendable {
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

    /// `yyyy-MM-dd` (e.g., 2020-06-04)
    public static let yearMonthDayDash: Self = "yyyy-MM-dd"

    /// `M/d/yyyy` (e.g., 6/4/2020)
    public static let monthDayYearSlash: Self = "M/d/yyyy"

    /// `M/d/yyyy - h:mm a` (e.g., 6/4/2020 - 9:41 AM)
    public static let monthDayYearSlashTime: Self = "M/d/yyyy - h:mm a"

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
