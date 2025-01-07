//
// Xcore
// Copyright © 2022 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

extension FormatStyle where Self == Date.RelativeFormatStyle {
    /// Returns a relative date format style based on the named presentation and
    /// wide unit style.
    ///
    /// This method provides a relative format style that uses named units
    /// (e.g., "yesterday," "tomorrow") and wide unit styles for a more natural
    /// and readable representation of relative dates.
    ///
    /// **Usage**
    ///
    /// ```swift
    /// let formattedDate = Date().formatted(.relative)
    /// print(formattedDate) // Output: "Today" (depending on the date)
    /// ```
    ///
    /// - Returns: A relative date format style configured for named presentation.
    public static var relative: Self {
        .relative(presentation: .named)
    }
}

extension Date.RelativeFormatStyle {
    /// Sets the capitalization context for formatting relative dates.
    ///
    /// Adjusts the capitalization of relative date strings based on the specified
    /// context. For example, setting the context to `beginningOfSentence` ensures
    /// the first word is capitalized, while `middleOfSentence` leaves all words
    /// lower-cased.
    ///
    /// **Usage**
    ///
    /// ```swift
    /// let formattedDate = Date().formatted(
    ///     .relative
    ///     .capitalizationContext(.beginningOfSentence)
    /// )
    /// print(formattedDate) // Output: "Today"
    /// ```
    ///
    /// - Parameter context: The capitalization context to apply.
    /// - Returns: A relative format style with the specified capitalization context.
    public func capitalizationContext(_ context: FormatStyleCapitalizationContext) -> Self {
        applying {
            $0.capitalizationContext = context
        }
    }

    /// Sets the calendar for formatting relative dates.
    ///
    /// Specifies the calendar to be used for formatting relative dates. By default,
    /// the `autoupdatingCurrent` calendar is used.
    ///
    /// **Usage**
    ///
    /// ```swift
    /// let calendar = Calendar(identifier: .gregorian)
    /// let formattedDate = Date().formatted(
    ///     .relative
    ///     .calendar(calendar)
    /// )
    /// print(formattedDate) // Output: "Today" (depending on the calendar)
    /// ```
    ///
    /// - Parameter calendar: The calendar to apply to the format style.
    /// - Returns: A relative format style with the specified calendar.
    public func calendar(_ calendar: Calendar) -> Self {
        applying {
            $0.calendar = calendar
        }
    }
}

// MARK: - Helpers

extension Date.FormatStyle {
    /// Configures the format style with the specified calendar, time zone, and
    /// locale.
    ///
    /// This method modifies the format style by applying the provided calendar.
    /// It also sets the calendar's associated time zone and locale, if available,
    /// to ensure consistent formatting across different regions.
    ///
    /// **Usage**
    ///
    /// ```swift
    /// let calendar = Calendar(identifier: .gregorian)
    /// let formattedDate = Date().formatted(
    ///     .dateTime
    ///     .calendarTimeZoneLocale(calendar)
    /// )
    /// print(formattedDate) // Output: "06/04/2022" (example output)
    /// ```
    ///
    /// - Parameter calendar: The calendar to use for formatting.
    /// - Returns: A date format style configured with the specified calendar, time zone,
    ///   and locale.
    func calendarTimeZoneLocale(_ calendar: Calendar) -> Self {
        applying { style in
            style.calendar = calendar
            style.timeZone = calendar.timeZone
            calendar.locale.map {
                style.locale = $0
            }
        }
    }
}

extension Date.ISO8601FormatStyle {
    /// Configures the ISO 8601 date format style to include the date components
    /// (year, month, and day) in the formatted output.
    ///
    /// **Usage**
    ///
    /// ```swift
    /// let formattedDate = Date().formatted(.iso8601.date())
    /// print(formattedDate) // Output: "2022-06-04"
    /// ```
    ///
    /// - Returns: An ISO 8601 date format style modified to include the date
    ///   components.
    public func date() -> Self {
        year().month().day()
    }

    /// Configures the ISO 8601 date format style with a specific time zone.
    ///
    /// This method allows you to explicitly set the time zone for date formatting
    /// and parsing. This ensures consistent date and time representation across
    /// different locales and environments.
    ///
    /// **Usage**
    ///
    /// ```swift
    /// let formattedDate = Date().formatted(.iso8601.timeZone(.utc))
    /// print(formattedDate) // Output: "2022-06-04T00:00:00Z"
    /// ```
    ///
    /// - Parameter timeZone: The time zone to use for formatting and parsing
    ///   the date.
    /// - Returns: A modified ISO 8601 format style with the specified time zone.
    public func timeZone(_ timeZone: TimeZone) -> Self {
        applying {
            $0.timeZone = timeZone
        }
    }
}
