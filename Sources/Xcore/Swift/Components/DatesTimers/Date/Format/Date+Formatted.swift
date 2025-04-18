//
// Xcore
// Copyright © 2018 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

// MARK: - Formatted

extension Date {
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
        switch style {
            case let .dateTime(dateStyle, timeStyle):
                if dateStyle == .omitted && timeStyle == .omitted {
                    return ""
                } else if doesRelativeDateFormatting {
                    // Date.FormatStyle does not support "doesRelativeDateFormatting" with time component.
                    // e.g., "Today at 9:41 AM" or "Today"
                    return formatted(
                        .legacy
                        .calendar(calendar)
                        .doesRelativeDateFormatting(doesRelativeDateFormatting)
                        .date(dateStyle)
                        .time(timeStyle)
                    )
                } else {
                    let formatStyle = FormatStyle(
                        date: dateStyle,
                        time: timeStyle
                    )
                    .calendarTimeZoneLocale(calendar)
                    return formatted(formatStyle)
                }

            case let .relative(untilThreshold):
                return formattedRelative(until: untilThreshold, calendar: calendar)
            case let .weekdayName(width):
                return weekdayName(width, in: calendar)
            case let .monthName(width):
                return monthName(width, in: calendar)
            case let .monthDayOrdinal(width):
                var ordinalDay: String {
                    let cache = Self._cache
                    let day = component(.day, in: calendar)
                    cache.ordinalNumberFormatter.locale = calendar.locale
                    return cache.ordinalNumberFormatter.string(from: day) ?? ""
                }

                return "\(monthName(width, in: calendar)) \(ordinalDay)"
        }
    }
}

// MARK: - Weekday & Month Formatted

extension Date {
    /// Calculates the weekday name for a given weekday number in the specified
    /// calendar.
    ///
    /// - Parameters:
    ///   - weekday: The weekday number (1 for Sunday, 7 for Saturday in the
    ///     Gregorian calendar).
    ///   - format: The desired width of the weekday name (e.g., `.short`, `.wide`).
    ///   - calendar: The calendar to use for formatting the weekday name.
    /// - Returns: The formatted weekday name as a `String`.
    public static func weekdayName(
        for weekday: Int,
        format: Date.FormatStyle.Symbol.Weekday = .wide,
        in calendar: Calendar = .default
    ) -> String {
        guard
            (1...7).contains(weekday),
            let date = calendar.date(from: DateComponents(weekday: weekday))
        else {
            fatalError("Invalid weekday: \(weekday). Must be between 1 and 7.")
        }

        return date.weekdayName(format, in: calendar)
    }

    /// Calculates the weekday name for the receiver date in the specified calendar.
    ///
    /// - Parameters:
    ///   - format: The desired width of the weekday name (e.g., `.short`, `.wide`).
    ///   - calendar: The calendar to use for formatting the weekday name.
    /// - Returns: The formatted weekday name as a `String`.
    private func weekdayName(
        _ format: Date.FormatStyle.Symbol.Weekday,
        in calendar: Calendar
    ) -> String {
        formatted(
            .dateTime
            .weekday(format)
            .calendarTimeZoneLocale(calendar)
        )
    }

    /// Calculates the month name for the receiver date in the specified calendar.
    ///
    /// - Parameters:
    ///   - format: The desired width of the month name (e.g., `.short`, `.wide`).
    ///   - calendar: The calendar to use for formatting the month name.
    /// - Returns: The formatted month name as a `String`.
    private func monthName(
        _ format: Date.FormatStyle.Symbol.Month,
        in calendar: Calendar
    ) -> String {
        formatted(
            .dateTime
            .month(format)
            .calendarTimeZoneLocale(calendar)
        )
    }
}

// MARK: - Relative Formatted

extension Date {
    private func formattedRelative(
        until threshold: Calendar.Component,
        calendar: Calendar
    ) -> String {
        let isNextHour = `is`(.next(.hour), in: calendar)
        let isToday = `is`(.today, in: calendar)
        let isCurrentThreshold = `is`(.current(threshold), in: calendar)

        var formatStyle = RelativeFormatStyle
            .relative
            .calendar(calendar)
            .capitalizationContext(.beginningOfSentence)

        if isToday && !isNextHour {
            if #available(iOS 18, *) {
                formatStyle.allowedFields = [.day]
            } else {
                return "Today"
            }
        }

        if isToday || isCurrentThreshold {
            return formatted(formatStyle)
        }

        return formatted(style: .date(.abbreviated))
    }
}
