//
// Xcore
// Copyright © 2018 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

extension Date {
    /// Creates a `Date` object using the given date components.
    ///
    /// - Parameters:
    ///   - year: The year to set on the Date.
    ///   - month: The month to set on the Date.
    ///   - day: The day to set on the Date.
    ///   - hour: The hour to set on the Date.
    ///   - minute: The minute to set on the Date.
    ///   - second: The second to set on the Date.
    ///   - calendar: The calendar to set on the Date.
    public init(
        year: Int,
        month: Int,
        day: Int,
        hour: Int? = nil,
        minute: Int? = nil,
        second: Int? = nil,
        calendar: Calendar = .default
    ) {
        let dateComponent = DateComponents(
            calendar: calendar,
            timeZone: calendar.timeZone,
            year: year,
            month: month,
            day: day,
            hour: hour,
            minute: minute,
            second: second
        )

        self = dateComponent.date!
    }

    /// Creates a `Date` object using the given date string and format.
    ///
    /// - Parameters:
    ///   - string: The string that represents a date.
    ///   - format: The format of the date that's represented with the string.
    ///   - calendar: The calendar to use when parsing the date.
    ///   - isLenient: A Boolean value indicating whether to use heuristics when
    ///     parsing the date.
    public init?(
        _ string: String,
        format: Style.Format,
        calendar: Calendar = .default,
        isLenient: Bool = true
    ) {
        self.init(string, style: .format(format), calendar: calendar, isLenient: isLenient)
    }

    /// Creates a `Date` object using the given date string and style.
    ///
    /// - Parameters:
    ///   - string: The string that represents a date.
    ///   - style: The style of the date that's represented with the string.
    ///   - calendar: The calendar to use when parsing the date.
    ///   - isLenient: A Boolean value indicating whether to use heuristics when
    ///     parsing the date.
    public init?(
        _ string: String,
        style: Style,
        calendar: Calendar = .default,
        isLenient: Bool = true
    ) {
        guard !string.isEmpty else {
            return nil
        }

        let cache = Self._cache
        let date: Date?

        switch style {
            case let .iso8601(options):
                date = cache
                    .dateFormatter(options: options, calendar: calendar)
                    .date(from: string)
            case let .format(format):
                date = cache
                    .dateFormatter(
                        format: format.rawValue,
                        calendar: calendar,
                        isLenient: isLenient
                    )
                    .date(from: string)
            default:
                return nil
        }

        guard let date else {
            return nil
        }

        self = date
    }
}
