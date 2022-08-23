//
// Xcore
// Copyright © 2018 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

extension Date {
    /// Create a `Date` object using the given date components.
    ///
    /// - Parameters:
    ///   - year: Year to set on the Date.
    ///   - month: Month to set on the Date.
    ///   - day: Date to set on the Date.
    ///   - hour: Hour to set on the Date.
    ///   - minute: Minute to set on the Date.
    ///   - second: Second to set on the Date.
    ///   - calendar: Calendar to set on the Date.
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

    /// Create a `Date` object using the given date string and format.
    ///
    /// - Parameters:
    ///   - string: String that represents a date.
    ///   - format: Format of the date that's represented with string.
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

    /// Create a `Date` object using the given date string and format.
    ///
    /// - Parameters:
    ///   - string: String that represents a date.
    ///   - style: Style of the date that's represented with string.
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
