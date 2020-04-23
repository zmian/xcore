//
// Xcore
// Copyright © 2018 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

// MARK: - Helpers

extension Date {
    /// Convenient initializer to create a `Date` object.
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

        self = calendar.date(from: dateComponent)!
    }

    /// Initializes a Date object from a given date string and format.
    ///
    /// - Parameters:
    ///   - string: String that represents a date.
    ///   - format: Format of the date that's represented with string.
    ///   - calendar: The calendar to use when parsing the date.
    ///   - isLenient: A Boolean flag to indicate to use heuristics when parsing the
    ///                date.
    public init?(
        from string: String,
        format: Format.Custom,
        calendar: Calendar = .default,
        isLenient: Bool = true
    ) {
        guard !string.isEmpty else {
            return nil
        }

        let formatter = Self._cache.dateFormatter(
            format: format.rawValue,
            calendar: calendar,
            isLenient: isLenient
        )

        guard let date = formatter.date(from: string) else {
            return nil
        }

        self = date
    }

    /// Converts a date object to string representation based on given calendar.
    ///
    /// - Parameters:
    ///   - format: The format to use when parsing the date.
    ///   - doesRelativeDateFormatting: A Boolean flag to indicate if parsing should
    ///   happen in relative format. Note: The relative formatting only supports
    ///   Date and Time styles and not custom formats.
    ///   - calendar: The calendar to use when parsing the date.
    public func string(
        format: Format,
        doesRelativeDateFormatting: Bool = false,
        calendar: Calendar = .default
    ) -> String {
        let cache = Self._cache
        let formatter: DateFormatter

        switch format {
            case .date(let dateStyle):
                formatter = cache.dateFormatter(
                    dateStyle: dateStyle,
                    doesRelativeDateFormatting: doesRelativeDateFormatting,
                    calendar: calendar
                )
            case .time(let timeStyle):
                formatter = cache.dateFormatter(
                    timeStyle: timeStyle,
                    doesRelativeDateFormatting: doesRelativeDateFormatting,
                    calendar: calendar
                )
            case .dateTime(let style):
                formatter = cache.dateFormatter(
                    dateStyle: style,
                    timeStyle: style,
                    doesRelativeDateFormatting: doesRelativeDateFormatting,
                    calendar: calendar
                )
            case .custom(let customFormat):
                var ordinalDay: String {
                    cache.numberFormatter.locale = calendar.locale
                    let day = NSNumber(value: component(.day, in: calendar))
                    return cache.numberFormatter.string(from: day) ?? ""
                }

                switch customFormat {
                    case .monthDayOrdinal:
                        return "\(monthName(calendar: calendar)) \(ordinalDay)"
                    case .monthShortDayOrdinal:
                        return "\(monthName(isShort: true, calendar: calendar)) \(ordinalDay)"
                    case .monthShortPeriodDayOrdinal:
                        let longMonthName = monthName(calendar: calendar)
                        let shortMonthName = monthName(isShort: true, calendar: calendar)
                        // This ensures we don't append `.` to the month that has same short and long
                        // name (e.g., May 4 shouldn't have period but Jun. 4 should).
                        let separator = longMonthName == shortMonthName ? "" : "."
                        return "\(shortMonthName)\(separator) \(ordinalDay)"
                    default:
                        formatter = cache.dateFormatter(
                            format: customFormat.rawValue,
                            doesRelativeDateFormatting: doesRelativeDateFormatting,
                            calendar: calendar
                        )
                }
        }

        return formatter.string(from: self)
    }

    /// Converts a date object to string representation based on given calendar.
    ///
    /// - Parameters:
    ///   - format: The custom format to use when parsing the date.
    ///   - calendar: The calendar to use when parsing the date.
    public func string(
        format: Format.Custom,
        calendar: Calendar = .default
    ) -> String {
        string(format: .custom(format), calendar: calendar)
    }

    /// Adjusts the receiver's given component and along with all smaller units to
    /// their start using the calendar.
    ///
    /// - Parameters:
    ///   - component: Component and along with all smaller units to adjust to their
    ///                start.
    ///   - calendar: The calendar to use for adjustment.
    public func startOf(_ component: Calendar.Component, calendar: Calendar = .default) -> Date {
        var start: NSDate?
        var interval: TimeInterval = 0

        guard
            (calendar as NSCalendar).range(of: component._nsCalendarUnit, start: &start, interval: &interval, for: self),
            let startDate = start
        else {
            return self
        }

        return startDate as Date
    }

    /// Adjusts the receiver's given component and along with all smaller units to
    /// their end using the calendar.
    ///
    /// - Parameters:
    ///   - component: Component and along with all smaller units to adjust to their
    ///                end.
    ///   - calendar: The calendar to use for adjustment.
    public func endOf(_ component: Calendar.Component, calendar: Calendar = .default) -> Date {
        var start: NSDate?
        var interval: TimeInterval = 0

        guard
            (calendar as NSCalendar).range(of: component._nsCalendarUnit, start: &start, interval: &interval, for: self),
            let startDate = start
        else {
            return self
        }

        let startOfNextComponent = startDate.addingTimeInterval(interval)
        return Date(timeInterval: -0.001, since: startOfNextComponent as Date)
    }

    /// Adjusts the receiver's given component by the given offset in set calendar.
    ///
    /// - Parameters:
    ///   - component: Component to adjust.
    ///   - offset: Offset to use for adjustment.
    ///   - calendar: The calendar to use for adjustment.
    public func adjusting(_ component: Calendar.Component, by offset: Int, in calendar: Calendar = .default) -> Date {
        var dateComponent = DateComponents()

        switch component {
            case .nanosecond:
                dateComponent.nanosecond = offset
            case .second:
                dateComponent.second = offset
            case .minute:
                dateComponent.minute = offset
            case .hour:
                dateComponent.hour = offset
            case .day:
                dateComponent.day = offset
            case .weekday:
                dateComponent.weekday = offset
            case .weekdayOrdinal:
                dateComponent.weekdayOrdinal = offset
            case .weekOfYear:
                dateComponent.weekOfYear = offset
            case .month:
                dateComponent.month = offset
            case .year:
                dateComponent.year = offset
            case .era:
                dateComponent.era = offset
            case .quarter:
                dateComponent.quarter = offset
            case .weekOfMonth:
                dateComponent.weekOfMonth = offset
            case .yearForWeekOfYear:
                dateComponent.yearForWeekOfYear = offset
            case .calendar, .timeZone:
                fatalError("Unsupported type \(component)")
            @unknown default:
                fatalError("Unsupported type \(component)")
        }

        return adjusting(components: dateComponent, calendar: calendar)
    }

    /// Adjusts the receiver by given date components.
    ///
    /// - Parameters:
    ///   - components: DateComponents object that contains adjustment values.
    ///   - calendar: The calendar to use for adjustment.
    public func adjusting(components: DateComponents, calendar: Calendar = .default) -> Date  {
        calendar.date(byAdding: components, to: self)!
    }

    /// Retrieves the receiver's given component value.
    ///
    /// - Parameters:
    ///   - component: Component to get the value for.
    ///   - calendar: The calendar to use for retrieval.
    ///
    /// **Example**
    ///
    /// ```swift
    /// let date = Date(year: 2020, month: 2, day: 1, hour: 3, minute: 41, second: 22)
    ///
    /// // Example in default calendar
    /// let year = date.component(.year)
    /// let month = date.component(.month)
    /// let day = date.component(.day)
    ///
    /// print(year)  // 2020
    /// print(month) // 2
    /// print(day)   // 1
    ///
    /// // Example in different calendar
    /// let year = date.component(.year, in: .usEastern)
    /// let month = date.component(.month, in: .usEastern)
    /// let day = date.component(.day, in: .usEastern)
    /// let hour = date.component(.hour, in: .usEastern)
    ///
    /// print(year)  // 2020
    /// print(month) // 1
    /// print(day)   // 31
    /// print(hour)  // 22
    /// ```
    public func component(_ component: Calendar.Component, in calendar: Calendar = .default) -> Int {
        calendar.component(component, from: self)
    }
}

// MARK: - Comparison

extension Date {
    /// Compares whether the receiver is before, after or equal to `date` based on
    /// their components down to a given unit granularity.
    ///
    /// - Parameters:
    ///   - date: Reference date.
    ///   - granularity: Smallest unit that must, along with all larger units, be
    ///                  less for the given date.
    ///   - calendar: The calendar to use when comparing.
    public func compare(to date: Date, granularity: Calendar.Component, calendar: Calendar = .default) -> ComparisonResult {
        calendar.compare(self, to: date, toGranularity: granularity)
    }

    /// Compares equality of two given dates based on their components down to a
    /// given unit granularity.
    ///
    /// - Parameters:
    ///   - date: The date to compare.
    ///   - granularity: The smallest unit that must, along with all larger units,
    ///                  be equal for the given dates to be considered the same.
    ///   - calendar: The calendar to use when comparing.
    ///
    /// - Returns: `true` if the dates are the same down to the given granularity,
    ///            otherwise `false`.
    public func isSame(_ date: Date, granularity: Calendar.Component, calendar: Calendar = .default) -> Bool {
        compare(to: date, granularity: granularity, calendar: calendar) == .orderedSame
    }

    /// Compares whether the receiver is before/before equal `date` based on their
    /// components down to a given unit granularity.
    ///
    /// - Parameters:
    ///   - date: The date to compare.
    ///   - orEqual: `true` to also check for equality.
    ///   - granularity: Smallest unit that must, along with all larger units, be
    ///                  less for the given dates.
    ///   - calendar: The calendar to use when comparing.
    public func isBefore(
        _ date: Date,
        orEqual: Bool = false,
        granularity: Calendar.Component,
        calendar: Calendar = .default
    ) -> Bool {
        let result = compare(to: date, granularity: granularity, calendar: calendar)
        return (orEqual ? (result == .orderedSame || result == .orderedAscending) : result == .orderedAscending)
    }

    /// Compares whether the receiver is after `date` based on their components down
    /// to a given unit granularity.
    ///
    /// - Parameters:
    ///   - date: The date to compare.
    ///   - orEqual: `true` to also check for equality.
    ///   - granularity: Smallest unit that must, along with all larger units, be
    ///                  greater for the given dates.
    ///   - calendar: The calendar to use when comparing.
    public func isAfter(
        _ date: Date,
        orEqual: Bool = false,
        granularity: Calendar.Component,
        calendar: Calendar = .default
    ) -> Bool {
        let result = compare(to: date, granularity: granularity, calendar: calendar)
        return (orEqual ? (result == .orderedSame || result == .orderedDescending) : result == .orderedDescending)
    }

    /// Returns `true` if receiver date is contained in the specified interval.
    ///
    /// - Parameters:
    ///   - interval: The date interval.
    ///   - orEqual: `true` to also check for equality on the given interval.
    ///   - granularity: Smallest unit that must, along with all larger units, be
    ///                  greater for the given dates.
    ///   - calendar: The calendar to use when comparing.
    public func isInBetween(
        _ interval: DateInterval,
        orEqual: Bool = false,
        granularity: Calendar.Component = .nanosecond,
        calendar: Calendar = .default
    ) -> Bool {
        isAfter(interval.start, orEqual: orEqual, granularity: granularity, calendar: calendar) &&
        isBefore(interval.end, orEqual: orEqual, granularity: granularity, calendar: calendar)
    }
}

// MARK: - Counts

extension Date {
    /// Returns the total number of units until the given date.
    ///
    /// - Parameters:
    ///   - component: The component to calculate.
    ///   - date: A component to calculate until date.
    ///   - calendar: The calendar to calculate the number.
    ///
    /// **Example**
    ///
    /// ```swift
    /// let date = Date(year: 2019, month: 3, day: 4, hour: 2, minute: 22, second: 44)
    /// let untilDate = Date(year: 2020, month: 4, day: 5, hour: 1, minute: 45, second: 55)
    /// let result = date.numberOf(.year, until: untilDate)
    ///
    /// print(result) // 1; There is only 1 year between 2019 and 2020.
    /// ```
    public func numberOf(_ component: Calendar.Component, until date: Date, calendar: Calendar = .default) -> Int {
        guard let start = calendar.ordinality(of: component, in: .era, for: self) else {
            return 0
        }

        guard let end = calendar.ordinality(of: component, in: .era, for: date) else {
            return 0
        }

        return end - start
    }

    /// Total number of days of month using the Date's default configuration.
    public var totalDaysInCurrentMonth: Int {
        Calendar.default.range(of: .day, in: .month, for: self)!.count
    }

    /// Returns the time zone offset of a calendar from GMT.
    ///
    /// - Parameter calendar: The calendar used to calculate time zone.
    ///
    /// **Example**
    ///
    /// ```swift
    /// let result = Date.timeZoneOffset(calendar: .usEastern)
    /// print(result) // -4; Eastern time zone is 4 hours behind GMT.
    /// ```
    public static func timeZoneOffset(calendar: Calendar = .default) -> Int {
        calendar.timeZone.secondsFromGMT() / 3600
    }
}

extension Date {
    /// Calculates the month name on the receiver date based on calendar.
    ///
    /// - Parameters:
    ///   - isShort: Boolean to indicate if the name should be shortened.
    ///   - calendar: The calendar to use when generating name.
    public func monthName(isShort: Bool = false, calendar: Calendar = .default) -> String {
        let symbols = isShort ?
            Self._cache.dateFormatter(dateStyle: .full, calendar: calendar).shortMonthSymbols :
            Self._cache.dateFormatter(dateStyle: .full, calendar: calendar).monthSymbols

        return symbols?.at(component(.month) - 1) ?? ""
    }

    /// Calculates the week day name on the receiver date based on calendar.
    ///
    /// - Parameters:
    ///   - isShort: Boolean to indicate if the name should be shortened.
    ///   - calendar: The calendar to use when generating name.
    public func weekdayName(isShort: Bool = false, calendar: Calendar = .default) -> String {
        let symbols = isShort ?
            Self._cache.dateFormatter(dateStyle: .full, calendar: calendar).shortWeekdaySymbols :
            Self._cache.dateFormatter(dateStyle: .full, calendar: calendar).weekdaySymbols

        return symbols?.at(component(.weekday) - 1) ?? ""
    }

    /// Calculates the week day name for given index based on calendar and locale.
    ///
    /// - Parameters:
    ///   - weekday: The day's index in a week
    ///   - isShort: Boolean to indicate if the name should be shortened.
    ///   - calendar: The calendar to use when generating name.
    public static func weekdayName(for weekday: Int, isShort: Bool = false, calendar: Calendar = .default) -> String {
        let symbols = isShort ?
            _cache.dateFormatter(calendar: calendar).shortWeekdaySymbols :
            _cache.dateFormatter(calendar: calendar).weekdaySymbols

        return symbols?.at(weekday) ?? ""
    }
}

extension Date {
    /// Creates a date interval from given date by adjusting its components.
    ///
    /// - Parameters:
    ///   - component: Component to adjust for the interval.
    ///   - adjustment: The offset to adjust the component.
    ///   - calendar: The calendar to use for adjustment.
    public func interval(
        for component: Calendar.Component,
        adjustedBy adjustment: Int = 0,
        calendar: Calendar = .default
    ) -> DateInterval {
        let date = startOf(component)
        return .init(
            start: date.adjusting(component, by: adjustment),
            end: date.endOf(component)
        )
    }
}

// MARK: - Date Picker

extension Configuration where Type: UIDatePicker {
    public static func `default`(minimumDate: Date?) -> Self {
        .init(id: "default") { picker in
            picker.minimumDate = minimumDate ?? Date.serverDate
            picker.calendar = .default
            picker.timeZone = Calendar.default.timeZone
        }
    }
}
