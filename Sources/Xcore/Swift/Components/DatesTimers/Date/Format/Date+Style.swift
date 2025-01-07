//
// Xcore
// Copyright © 2014 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

extension Date {
    /// An enumeration representing the style of a date object for formatting purposes.
    ///
    /// The `Style` enum provides various predefined and customizable styles for
    /// formatting dates and times, such as relative dates, weekday names, month names,
    /// and more. Each style specifies how the date and/or time should be displayed.
    public enum Style: Sendable, Hashable {
        /// A style that uses both date and time formatting.
        ///
        /// - Parameters:
        ///   - date: The date style to use.
        ///   - time: The time style to use.
        case dateTime(FormatStyle.DateStyle, time: FormatStyle.TimeStyle)

        /// A style that omits time and uses only the date formatting.
        ///
        /// - Parameter style: The date style to use.
        public static func date(_ style: FormatStyle.DateStyle) -> Self {
            dateTime(style, time: .omitted)
        }

        /// A style that omits the date and uses only the time formatting.
        ///
        /// - Parameter style: The time style to use.
        public static func time(_ style: FormatStyle.TimeStyle) -> Self {
            dateTime(.omitted, time: style)
        }

        /// A style to use when describing a relative date, such as "1 day ago" or
        /// "yesterday".
        ///
        /// This style is useful for relative date formatting, where dates close to the
        /// current date are displayed as relative terms, while older dates are formatted
        /// using a predefined fallback style.
        ///
        /// **Example: Always Relative**
        ///
        /// ```swift
        /// let relative = Date.Style.relative(until: .era)
        ///
        /// let yesterday = Date().adjusting(.day, by: -1)
        /// print(yesterday.formatted(style: relative)) // Output: "Yesterday"
        ///
        /// let twoMonthsAgo = Date().adjusting(.month, by: -2)
        /// print(twoMonthsAgo.formatted(style: relative)) // Output: "2 months ago"
        /// ```
        ///
        /// **Example: Relative for 1 Month**
        ///
        /// ```swift
        /// // Relative until one month and then outputs using `.date(.abbreviated)`
        /// // style.
        /// let relative = Date.Style.relative(until: .month)
        ///
        /// let yesterday = Date().adjusting(.day, by: -1)
        /// print(yesterday.formatted(style: relative)) // Output: "Yesterday"
        ///
        /// let twoMonthsAgo = Date().adjusting(.month, by: -2)
        /// print(twoMonthsAgo.formatted(style: relative)) // Output: "Jun 4, 2022"
        /// ```
        ///
        /// - Parameter until: The calendar component threshold at which the date is
        ///   styled as a relative format. After this threshold, the
        ///   `.date(.abbreviated)` style is used (e.g., `Jun 4, 2022`).
        case relative(until: Calendar.Component)

        /// A style that formats the date using the weekday name.
        ///
        /// This style formats the date to display the name of the weekday. The name can
        /// vary in length depending on the `width` parameter, which specifies whether
        /// the `.wide`, `.abbreviated`, or `.narrow` form of the weekday name should be
        /// used.
        ///
        /// **Usage**
        ///
        /// ```swift
        /// let fullWeekday = Date().formatted(style: .weekdayName(.wide)) // "Sunday"
        /// let abbreviatedWeekday = Date().formatted(style: .weekdayName(.abbreviated)) // "Sun"
        /// let narrowWeekday = Date().formatted(style: .weekdayName(.narrow)) // "S"
        /// ```
        ///
        /// - Parameter width: The width of the weekday name.
        case weekdayName(FormatStyle.Symbol.Weekday)

        /// A style that formats the date using the month name.
        ///
        /// This style formats the date to display the name of the month. The name can
        /// vary in length depending on the `width` parameter, which specifies whether
        /// the `.wide`, `.abbreviated`, or `narrow` form of the month name should be
        /// used.
        ///
        /// **Usage**
        ///
        /// ```swift
        /// let fullMonth = Date().formatted(style: .monthName(.wide)) // "January"
        /// let abbreviatedMonth = Date().formatted(style: .monthName(.abbreviated)) // "Jan"
        /// let narrowMonth = Date().formatted(style: .monthName(.narrow)) // "J"
        /// ```
        ///
        /// - Parameter width: The width of the month name.
        case monthName(FormatStyle.Symbol.Month)

        /// A style that formats the date using the ordinal day and the month name.
        ///
        /// This style combines the name of the month with the ordinal representation of
        /// the day, such as "4th" or "21st". The format adapts based on the specified
        /// width of the month name, which can be `.wide`, `.abbreviated`, or `.narrow`.
        ///
        /// **Usage**
        ///
        /// ```swift
        /// let fullFormat = Date().formatted(style: .monthDayOrdinal(.wide))
        /// // Output: "June 4th"
        ///
        /// let abbreviatedFormat = Date().formatted(style: .monthDayOrdinal(.abbreviated))
        /// // Output: "Jun 4th"
        ///
        /// let narrowFormat = Date().formatted(style: .monthDayOrdinal(.narrow))
        /// // Output: "J 4th"
        /// ```
        ///
        /// - Parameter width: The width of the month name.
        case monthDayOrdinal(FormatStyle.Symbol.Month)
    }
}

// MARK: - Weekday & Month Styles

extension Date.Style {
    /// A style that formats the date using the full weekday name.
    ///
    /// For example, in English for the Gregorian calendar, this style returns:
    /// `"Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday",
    /// "Saturday"`.
    public static var weekdayName: Self { weekdayName(.wide) }

    /// A style that formats the date using the full month name.
    ///
    /// For example, in English for the Gregorian calendar, this style returns:
    /// `"January", "February", "March", "April", "May", "June", "July", "August",
    /// "September", "October", "November", "December"`.
    public static var monthName: Self { monthName(.wide) }

    /// A style that formats the date using the ordinal day and full month name
    /// (e.g., "June 4th").
    public static var monthDayOrdinal: Self { monthDayOrdinal(.wide) }
}

// MARK: - Helper Date Format Styles

extension Date.Style {
    /// A relative date style with a fallback to `.abbreviated` style after 1 month.
    ///
    /// For example:
    /// - `"1 day ago"`
    /// - `"Yesterday"`
    /// - `"Jun 4, 2020"`
    public static var relative: Self { relative(until: .month) }

    /// A wide date style.
    ///
    /// For example: `"June 4, 2020"`.
    public static var wide: Self { date(.long) }

    /// A medium date style.
    ///
    /// For example: `"Jun 4, 2020"`.
    public static var medium: Self { date(.abbreviated) }

    /// A medium date style with time included.
    ///
    /// For example: `"Jun 4, 2020 at 9:41 AM"`.
    public static var mediumWithTime: Self { dateTime(.abbreviated, time: .shortened) }

    /// A narrow date style.
    ///
    /// For example: `"6/4/2020"`.
    public static var narrow: Self { date(.numeric) }

    /// A narrow date style with time included.
    ///
    /// For example: `"6/4/2020, 9:41 AM"`.
    public static var narrowWithTime: Self { dateTime(.numeric, time: .shortened) }

    /// A style that formats only the time.
    ///
    /// For example: `"9:41 AM"`.
    public static var time: Self { time(.shortened) }
}
