//
// Xcore
// Copyright © 2014 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

extension Date {
    /// Format represents a date/time style that can be applied to `DateFormatter`.
    public enum Format {
        case date(DateFormatter.Style)
        case time(DateFormatter.Style)
        case dateTime(DateFormatter.Style)
        case iso8601(ISO8601DateFormatter.Options)
        case custom(Custom)
    }
}

// MARK: - Format.SymbolStyle

extension Date.Format {
    public enum SymbolStyle: String {
        /// Formats full representation of the symbol in calendar.
        ///
        /// **Month Name Format**
        ///
        /// ```swift
        /// let monthName = Date().string(format: .monthName(.full))
        /// print(monthName)
        /// // For English in the Gregorian calendar, returns month name such as:
        /// // "January", "February", "March", "April", "May", "June", "July", "August",
        /// // "September", "October", "November", "December".
        /// ```
        ///
        /// **Weekday Name Format**
        ///
        /// ```swift
        /// let weekdayName = Date().string(format: .weekdayName(.full))
        /// print(weekdayName)
        /// // For English in the Gregorian calendar, returns weekday name such as:
        /// // "Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday",
        /// // "Saturday".
        /// ```
        case full

        /// Formats short representation of the symbol in calendar.
        ///
        /// **Month Name Format**
        ///
        /// ```swift
        /// let monthName = Date().string(format: .monthName(.short))
        /// print(monthName)
        /// // For English in the Gregorian calendar, returns shorter-named month such
        /// // as: "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct",
        /// // "Nov", "Dec".
        /// ```
        ///
        /// **Weekday Name Format**
        ///
        /// ```swift
        /// let weekdayName = Date().string(format: .weekdayName(.short))
        /// print(weekdayName)
        /// // For English in the Gregorian calendar, returns shorter-named weekday name
        /// // such as: "Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat".
        /// ```
        case short

        /// Formats very short representation of the symbol in calendar.
        ///
        /// **Month Name Format**
        ///
        /// ```swift
        /// let monthName = Date().string(format: .monthName(.veryShort))
        /// print(monthName)
        /// // For English in the Gregorian calendar, returns very-shortly-named month
        /// // name such as: "J", "F", "M", "A", "M", "J", "J", "A", "S", "O", "N", "D".
        /// ```
        ///
        /// **Weekday Name Format**
        ///
        /// ```swift
        /// let weekdayName = Date().string(format: .weekdayName(.veryShort))
        /// print(weekdayName)
        /// // For English in the Gregorian calendar, returns very-shortly-named weekday
        /// // name such as: "S", "M", "T", "W", "T", "F", "S".
        /// ```
        case veryShort
    }
}

// MARK: - Format.Custom

extension Date.Format {
    public struct Custom: RawRepresentable, Equatable {
        public let rawValue: String

        public init(rawValue: String) {
            self.rawValue = rawValue
        }
    }
}

extension Date.Format.Custom: ExpressibleByStringLiteral {
    public init(stringLiteral value: StringLiteralType) {
        self.init(rawValue: value)
    }
}

extension Date.Format.Custom: CustomStringConvertible {
    public var description: String {
        rawValue
    }
}

extension Date.Format.Custom: CustomPlaygroundDisplayConvertible {
    public var playgroundDescription: Any {
        rawValue
    }
}

// MARK: - Built-in Format.Custom

extension Date.Format.Custom {
    /// `yyyy-MM-dd'T'HH:mm:ss.SSSZ` (e.g., 2020-06-04T00:00:00.000+0000)
    public static let iso8601: Self = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"

    /// `yyyy-MM-dd'T'HH:mm:ss` (e.g., 2020-06-04T00:00:00)
    public static let iso8601Local: Self = "yyyy-MM-dd'T'HH:mm:ss"

    /// `yyyy-MM-dd` (e.g., 2020-06-04)
    public static let yearMonthDayDash: Self = "yyyy-MM-dd"

    /// yyyy-MM` (e.g., 2020-06)
    public static let yearMonthDash: Self = "yyyy-MM"

    /// `M/dd` (e.g., 6/04)
    public static let monthDaySlash: Self = "M/dd"

    /// `MM/dd/yyyy` (e.g., 06/04/2020)
    public static let monthDayYearSlash: Self = "MM/dd/yyyy"

    /// `MM/dd/yyyy - h:mma` (e.g., 06/04/2020 - 12:00AM)
    public static let monthDayYearSlashTime: Self = "MM/dd/yyyy - h:mma"

    /// `yyyy` (e.g., 2020)
    public static let year: Self = "yyyy"

    /// `yyyy MM dd` (e.g., 2020 06 04)
    public static let yearMonthDaySpace: Self = "yyyy MM dd"

    /// `LLL dd` (e.g., Jun 04)
    public static let monthDayShortSpace: Self = "LLL dd"

    /// `MMMM d, yyyy` (e.g., June 4, 2020)
    public static let monthDayYearFull: Self = "MMMM d, yyyy"

    /// `MMMM d` (e.g., June 4)
    public static let monthDaySpace: Self = "MMMM d"

    /// `MMM d` (e.g., Jun 4)
    public static let monthDayAbbreviated: Self = "MMM d"

    /// `MMMM yyyy` (e.g., June 2020)
    public static let monthYearFull: Self = "MMMM yyyy"
}

// MARK: - Month Name Format

extension Date.Format.Custom {
    /// Formats the month in calendar.
    ///
    /// For example, for English in the Gregorian calendar, returns one of these
    /// `"January", "February", "March", "April", "May", "June", "July", "August",
    /// "September", "October", "November", "December"`
    public static var monthName: Self { monthName(.full) }

    /// Formats the month in calendar.
    ///
    /// - Parameter style: The style of the month name.
    public static func monthName(_ style: Date.Format.SymbolStyle) -> Self {
        .init(rawValue: "xcore_monthName_\(style.rawValue)")
    }
}

// MARK: - Weekday Name Format

extension Date.Format.Custom {
    /// Formats the weekday in calendar.
    ///
    /// For example, for English in the Gregorian calendar, returns one of these
    /// `"Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday",
    /// "Saturday"`.
    public static var weekdayName: Self { weekdayName(.full) }

    /// Formats the weekday in calendar.
    ///
    /// - Parameter style: The style of the weekday name.
    public static func weekdayName(_ style: Date.Format.SymbolStyle) -> Self {
        .init(rawValue: "xcore_weekdayName_\(style.rawValue)")
    }
}

// MARK: - Ordinal Format

extension Date.Format.Custom {
    /// Used for ordinal days like `June 4th`
    public static var monthDayOrdinal: Self { .init(rawValue: "xcore_\(#function)") }

    /// Used for ordinal days with short months like `Jun 4th`
    public static var monthShortDayOrdinal: Self { .init(rawValue: "xcore_\(#function)") }

    /// Used for ordinal days with short months like `Jun. 4th`
    public static var monthShortPeriodDayOrdinal: Self { .init(rawValue: "xcore_\(#function)") }
}
