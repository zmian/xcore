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
                if dateStyle == .none && timeStyle == .none {
                    return ""
                } else if doesRelativeDateFormatting {
                    // Date.FormatStyle does not support "RelativeDateFormatting" with time component.
                    formatter = cache.dateFormatter(
                        dateStyle: dateStyle,
                        timeStyle: timeStyle,
                        doesRelativeDateFormatting: doesRelativeDateFormatting,
                        calendar: calendar
                    )
                } else {
                    let dateFormat: Date.FormatStyle.DateStyle
                    let timeFormat: Date.FormatStyle.TimeStyle

                    switch dateStyle {
                        case .none: dateFormat = .omitted
                        case .short: dateFormat = .numeric
                        case .medium: dateFormat = .abbreviated
                        case .long:  dateFormat = .long
                        default: dateFormat = .complete
                    }

                    switch timeStyle {
                        case .none: timeFormat = .omitted
                        case .short:  timeFormat = .shortened
                        case .medium, .long: timeFormat = .standard
                        default: timeFormat = .complete
                    }

                    let formatStyle = FormatStyle(
                        date: dateFormat,
                        time: timeFormat
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
                    let day = component(.day, in: calendar)
                    cache.ordinalNumberFormatter.locale = calendar.locale
                    return cache.ordinalNumberFormatter.string(from: day) ?? ""
                }

                return "\(monthName(width, in: calendar)) \(ordinalDay)"

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
    /// Calculates the weekday name for a given weekday number in the specified
    /// calendar.
    ///
    /// - Parameters:
    ///   - weekday: The weekday number (1 for Sunday, 7 for Saturday in the
    ///     Gregorian calendar).
    ///   - style: The desired width of the weekday name (e.g., `.short`, `.wide`).
    ///   - calendar: The calendar to use for formatting the weekday name.
    /// - Returns: The formatted weekday name as a `String`.
    public static func weekdayName(
        for weekday: Int,
        style: Date.FormatStyle.Symbol.Weekday = .wide,
        in calendar: Calendar = .default
    ) -> String {
        guard
            (1...7).contains(weekday),
            let date = calendar.date(from: DateComponents(weekday: weekday))
        else {
            fatalError("Invalid weekday: \(weekday). Must be between 1 and 7.")
        }

        return date.weekdayName(style, in: calendar)
    }

    /// Calculates the weekday name for the receiver date in the specified calendar.
    ///
    /// - Parameters:
    ///   - style: The desired width of the weekday name (e.g., `.short`, `.wide`).
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
    ///   - style: The desired width of the month name (e.g., `.short`, `.wide`).
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

        return formatted(style: .date(.medium))
    }
}
