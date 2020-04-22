//
// Xcore
// Copyright © 2014 Xcore
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
    ///   - region: Region to set on the Date.
    public init(
        year: Int,
        month: Int,
        day: Int,
        hour: Int? = nil,
        minute: Int? = nil,
        second: Int? = nil,
        region: Region = .default
    ) {
        let dateComponent = DateComponents(
            calendar: region.calendar,
            timeZone: region.timeZone,
            year: year,
            month: month,
            day: day,
            hour: hour,
            minute: minute,
            second: second
        )

        self = region.calendar.date(from: dateComponent)!
    }

    /// Initializes a Date object from a given date string and format.
    ///
    /// - Parameters:
    ///   - string: String that represents a date.
    ///   - format: Format of the date that's represented with string.
    ///   - region: Region to use when parsing the date.
    ///   - isLenient: A Boolean flag to indicate to use heuristics when parsing the
    ///                date.
    public init?(
        from string: String,
        format: CustomFormat,
        region: Region = .default,
        isLenient: Bool = true
    ) {
        guard !string.isEmpty else {
            return nil
        }

        let formatter = Self._cache.dateFormatter(
            format: format.rawValue,
            region: region,
            isLenient: isLenient
        )

        guard let date = formatter.date(from: string) else {
            return nil
        }

        self = date
    }

    /// Converts a date object to string representation based on given region.
    ///
    /// - Parameters:
    ///   - format: The format to use when parsing the date.
    ///   - doesRelativeDateFormatting: A Boolean flag to indicate if parsing should
    ///   happen in relative format. Note: The relative formatting only supports
    ///   Date and Time styles and not custom formats.
    ///   - region: The `Region` to use when parsing the date.
    public func toString(
        format: Format,
        doesRelativeDateFormatting: Bool = false,
        region: Region = .default
    ) -> String {
        let cache = Self._cache
        let formatter: DateFormatter

        switch format {
            case .date(let dateStyle):
                formatter = cache.dateFormatter(
                    dateStyle: dateStyle,
                    doesRelativeDateFormatting: doesRelativeDateFormatting,
                    region: region
                )
            case .time(let timeStyle):
                formatter = cache.dateFormatter(
                    timeStyle: timeStyle,
                    doesRelativeDateFormatting: doesRelativeDateFormatting,
                    region: region
                )
            case .dateTime(let style):
                formatter = cache.dateFormatter(
                    dateStyle: style,
                    timeStyle: style,
                    doesRelativeDateFormatting: doesRelativeDateFormatting,
                    region: region
                )
            case .custom(let customFormat):
                if customFormat == .monthDayOrdinal {
                    return "\(monthName()) \(cache.numberFormatter.string(from: NSNumber(value: get(component: .day))) ?? "")"
                }

                if customFormat == .monthShortPeriodDayOrdinal {
                    let longMonthName = monthName()
                    let shortMonthName = monthName(isShort: true)
                    let separator = longMonthName == shortMonthName ? "" : "."
                    return "\(shortMonthName)\(separator) \(get(component: .day))"
                }

                formatter = cache.dateFormatter(
                    format: customFormat.rawValue,
                    doesRelativeDateFormatting: doesRelativeDateFormatting,
                    region: region
                )
        }

        return formatter.string(from: self)
    }

    /// Adjusts the receiver's given component and along with all smaller units to
    /// their start using the region.
    ///
    /// - Parameters:
    ///   - component: Component and along with all smaller units to adjust to their
    ///                start.
    ///   - region: The region to use for adjustment.
    public func startOf(_ component: Calendar.Component, region: Region = .default) -> Date {
        var start: NSDate?
        var interval: TimeInterval = 0

        guard
            (region.calendar as NSCalendar).range(of: component._nsCalendarUnit, start: &start, interval: &interval, for: self),
            let startDate = start
        else {
            return self
        }

        return startDate as Date
    }

    /// Adjusts the receiver's given component and along with all smaller units to
    /// their end using the region.
    ///
    /// - Parameters:
    ///   - component: Component and along with all smaller units to adjust to their
    ///                end.
    ///   - region: The region to use for adjustment.
    public func endOf(_ component: Calendar.Component, region: Region = .default) -> Date {
        var start: NSDate?
        var interval: TimeInterval = 0

        guard
            (region.calendar as NSCalendar).range(of: component._nsCalendarUnit, start: &start, interval: &interval, for: self),
            let startDate = start
        else {
            return self
        }

        let startOfNextComponent = startDate.addingTimeInterval(interval)
        return Date(timeInterval: -0.001, since: startOfNextComponent as Date)
    }

    /// Adjusts the receiver's given component by the given offset in set region.
    ///
    /// - Parameters:
    ///   - component: Component to adjust.
    ///   - offset: Offset to use for adjustment.
    ///   - region: The region to use for adjustment.
    public func adjusting(_ component: Calendar.Component, by offset: Int, in region: Region = .default) -> Date {
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

        return adjusting(components: dateComponent, region: region)
    }

    /// Adjusts the receiver by given date components.
    ///
    /// - Parameters:
    ///   - components: DateComponents object that contains adjustment values.
    ///   - region: The region to use for adjustment.
    public func adjusting(components: DateComponents, region: Region = .default) -> Date  {
        region.calendar.date(byAdding: components, to: self)!
    }

    /// Retrieves the receiver's given component value.
    ///
    /// - Parameters:
    ///   - component: Component to get the value for.
    ///   - region: The region to use for retrieval.
    ///
    /// **Example**
    ///
    /// ```swift
    /// let date = Date(year: 2020, month: 2, day: 1, hour: 3, minute: 41, second: 22)
    ///
    /// // Example in default region
    /// let year = date.get(component: .year)
    /// let month = date.get(component: .month)
    /// let day = date.get(component: .day)
    ///
    /// print(year)  // 2020
    /// print(month) // 2
    /// print(day)   // 1
    ///
    /// // Example in different region
    /// let year = date.get(component: .year, in: .usEastern)
    /// let month = date.get(component: .month, in: .usEastern)
    /// let day = date.get(component: .day, in: .usEastern)
    /// let hour = date.get(component: .hout, in: .usEastern)
    ///
    /// print(year)  // 2020
    /// print(month) // 1
    /// print(day)   // 31
    /// print(hour)  // 22
    /// ```
    public func get(component: Calendar.Component, in region: Region = .default) -> Int {
        region.calendar.component(component, from: self)
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
    ///   - region: The region to use when comparing.
    public func compare(to date: Date, granularity: Calendar.Component, region: Region = .default) -> ComparisonResult {
        region.calendar.compare(self, to: date, toGranularity: granularity)
    }

    /// Compares equality of two given dates based on their components down to a
    /// given unit granularity.
    ///
    /// - Parameters:
    ///   - date: The date to compare.
    ///   - granularity: The smallest unit that must, along with all larger units,
    ///                  be equal for the given dates to be considered the same.
    ///   - region: The region to use when comparing.
    ///
    /// - Returns: `true` if the dates are the same down to the given granularity,
    ///            otherwise `false`.
    public func isSame(_ date: Date, granularity: Calendar.Component, region: Region = .default) -> Bool {
        compare(to: date, granularity: granularity, region: region) == .orderedSame
    }

    /// Compares whether the receiver is before/before equal `date` based on their
    /// components down to a given unit granularity.
    ///
    /// - Parameters:
    ///   - date: The date to compare.
    ///   - orEqual: `true` to also check for equality.
    ///   - granularity: Smallest unit that must, along with all larger units, be
    ///                  less for the given dates.
    ///   - region: The region to use when comparing.
    public func isBefore(
        _ date: Date,
        orEqual: Bool = false,
        granularity: Calendar.Component,
        region: Region = .default
    ) -> Bool {
        let result = compare(to: date, granularity: granularity, region: region)
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
    ///   - region: The region to use when comparing.
    public func isAfter(
        _ date: Date,
        orEqual: Bool = false,
        granularity: Calendar.Component,
        region: Region = .default
    ) -> Bool {
        let result = compare(to: date, granularity: granularity, region: region)
        return (orEqual ? (result == .orderedSame || result == .orderedDescending) : result == .orderedDescending)
    }

    /// Returns `true` if receiver date is contained in the specified interval.
    ///
    /// - Parameters:
    ///   - interval: The date interval.
    ///   - orEqual: `true` to also check for equality on the given interval.
    ///   - granularity: Smallest unit that must, along with all larger units, be
    ///                  greater for the given dates.
    ///   - region: The region to use when comparing.
    public func isInBetween(
        _ interval: DateInterval,
        orEqual: Bool = false,
        granularity: Calendar.Component = .nanosecond,
        region: Region = .default
    ) -> Bool {
        isAfter(interval.start, orEqual: orEqual, granularity: granularity, region: region) &&
        isBefore(interval.end, orEqual: orEqual, granularity: granularity, region: region)
    }
}

// MARK: - Counts

extension Date {
    /// Returns the total number of units until the given date.
    ///
    /// - Parameters:
    ///   - component: The component to calculate.
    ///   - date: A component to calculate until date.
    ///   - region: The region to calculate the number.
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
    public func numberOf(_ component: Calendar.Component, until date: Date, region: Region = .default) -> Int {
        let calendar = region.calendar

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
        Date.Region.default.calendar.range(of: .day, in: .month, for: self)!.count
    }

    /// Returns the time zone offset of a region from GMT.
    ///
    /// - Parameter region: Region to calculate time zone.
    ///
    /// **Example**
    ///
    /// ```swift
    /// let result = Date.timeZoneOffset(region: .usEastern)
    /// print(result) // -4; Eastern time zone is 4 hours behind GMT.
    /// ```
    public static func timeZoneOffset(region: Region = .default) -> Int {
        region.timeZone.secondsFromGMT() / 3600
    }
}

extension Date {
    /// Calculates the month name on the receiver date based on region.
    ///
    /// - Parameters:
    ///   - isShort: Boolean to indicate if the name should be shortened
    ///   - region: The region to use when generating name.
    public func monthName(isShort: Bool = false, region: Region = .default) -> String {
        let symbols = isShort ?
            Self._cache.dateFormatter(dateStyle: .full, region: region).shortMonthSymbols :
            Self._cache.dateFormatter(dateStyle: .full, region: region).monthSymbols

        return symbols?.at(get(component: .month) - 1) ?? ""
    }

    /// Calculates the week day name on the receiver date based on region.
    ///
    /// - Parameters:
    ///   - isShort: Boolean to indicate if the name should be shortened.
    ///   - region: The region to use when generating name.
    public func weekdayName(isShort: Bool = false, region: Region = .default) -> String {
        let symbols = isShort ?
            Self._cache.dateFormatter(dateStyle: .full, region: region).shortWeekdaySymbols :
            Self._cache.dateFormatter(dateStyle: .full, region: region).weekdaySymbols

        return symbols?.at(get(component: .weekday) - 1) ?? ""
    }

    /// Calculates the week day name for given index based on region and locale.
    ///
    /// - Parameters:
    ///   - weekDay: The day's index in a week
    ///   - isShort: Boolean to indicate if the name should be shortened.
    ///   - region: The region to use when generating name.
    public static func weekdayName(for weekDay: Int, isShort: Bool = false, region: Region = .default) -> String {
        let symbols = isShort ?
            _cache.dateFormatter(region: region).shortWeekdaySymbols :
            _cache.dateFormatter(region: region).weekdaySymbols

        return symbols?.at(weekDay) ?? ""
    }
}

extension Date {
    /// Creates a date interval from given date by adjusting its components.
    ///
    /// - Parameters:
    ///   - component: Component to adjust for the interval.
    ///   - adjustment: The offset to adjust the component.
    ///   - region: The region to use for adjustment.
    public func interval(
        for component: Calendar.Component,
        adjustedBy adjustment: Int = 0,
        region: Region = .default
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
            picker.timeZone = Date.Region.default.timeZone
            picker.calendar = Date.Region.default.calendar
        }
    }
}
