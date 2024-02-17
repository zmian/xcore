//
// Xcore
// Copyright © 2018 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

#warning("FIXME: Switch to Foundating date formatting styles.")

// MARK: - Formatted

extension Date {
    /// Creates a locale-aware string representation of date based on the given
    /// calendar.
    ///
    /// - Parameters:
    ///   - format: The custom format to use when formatting the date.
    ///   - calendar: The calendar to use when formatting the date.
    public func formatted(
        format: Style.Format,
        in calendar: Calendar = .default
    ) -> String {
        formatted(style: .format(format), in: calendar)
    }

    /// Creates a locale-aware string representation of date based on the given
    /// calendar.
    ///
    /// - Parameters:
    ///   - style: The style to use when formatting the date.
    ///   - doesRelativeDateFormatting: A Boolean value to indicate if formatting
    ///     should happen in relative format. Note: The relative formatting only
    ///     supports Date and Time styles and not custom formats.
    ///   - calendar: The calendar to use when formatting the date.
    public func formatted(
        style: Style,
        doesRelativeDateFormatting: Bool = false,
        in calendar: Calendar = .default
    ) -> String {
        let cache = Self._cache
        let formatter: DateFormatter

        switch style {
            case let .dateTime(dateStyle, timeStyle):
                formatter = cache.dateFormatter(
                    dateStyle: dateStyle,
                    timeStyle: timeStyle,
                    doesRelativeDateFormatting: doesRelativeDateFormatting,
                    calendar: calendar
                )
            case let .iso8601(options):
                return cache.dateFormatter(options: options, calendar: calendar)
                    .string(from: self)
            case let .relative(untilThreshold):
                return formattedRelative(until: untilThreshold, calendar: calendar)
            case let .weekdayName(width):
                return weekdayName(width, in: calendar)
            case let .monthName(width):
                return monthName(width, in: calendar)
            case let .monthDayOrdinal(width, withPeriod):
                var ordinalDay: String {
                    let day = component(.day, in: calendar)
                    cache.ordinalNumberFormatter.locale = calendar.locale
                    return cache.ordinalNumberFormatter.string(from: day) ?? ""
                }

                let monthNameString = monthName(width, in: calendar)

                guard withPeriod else {
                    return "\(monthNameString) \(ordinalDay)"
                }

                let fullMonthName = monthName(.wide, in: calendar)

                // This ensures we don't append `.` to the month that has same short and long
                // name (e.g., May 4 shouldn't have period but Jun. 4 should).
                let separator = fullMonthName == monthNameString ? "" : "."
                return "\(monthNameString)\(separator) \(ordinalDay)"

            case let .format(format):
                formatter = cache.dateFormatter(
                    format: format.rawValue,
                    doesRelativeDateFormatting: doesRelativeDateFormatting,
                    calendar: calendar
                )
        }

        return formatter.string(from: self)
    }
}

// MARK: - Weekday & Month Formatted

extension Date {
    /// Calculates the weekday name in the calendar.
    ///
    /// - Parameters:
    ///   - weekday: The weekday number.
    ///   - style: The style of the weekday name.
    ///   - calendar: The calendar to use when formatting name.
    public static func weekdayName(for weekday: Int, style: Style.Width = .wide, in calendar: Calendar = .default) -> String {
        _cache.symbolFormatter.weekdayName(for: weekday, style: style, calendar: calendar)
    }

    /// Calculates the weekday name on the receiver date based on calendar.
    ///
    /// - Parameters:
    ///   - style: The style of the weekday name.
    ///   - calendar: The calendar to use when formatting name.
    private func weekdayName(_ style: Style.Width, in calendar: Calendar) -> String {
        Self._cache.symbolFormatter.weekdayName(for: component(.weekday), style: style, calendar: calendar)
    }

    /// Calculates the month name on the receiver date based on calendar.
    ///
    /// - Parameters:
    ///   - style: The style of the month name.
    ///   - calendar: The calendar to use when formatting name.
    private func monthName(_ style: Style.Width, in calendar: Calendar) -> String {
        Self._cache.symbolFormatter.monthName(for: component(.month), style: style, calendar: calendar)
    }
}

// MARK: - Relative Formatted

extension Date {
    private func formattedRelative(until threshold: Calendar.Component, calendar: Calendar) -> String {
        if `is`(.next(.hour), in: calendar) {
            return formatted(.relative.calendar(calendar).capitalizationContext(.beginningOfSentence))
        }

        if `is`(.today, in: calendar) {
            return "Today"
        }

        if `is`(.current(threshold), in: calendar) {
            return formatted(.relative.calendar(calendar).capitalizationContext(.beginningOfSentence))
        }

        return formatted(style: .date(.medium))
    }
}
