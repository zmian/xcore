//
// Xcore
// Copyright © 2018 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

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
        in calendar: Calendar = .default
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
            case .iso8601(let options):
                return cache.dateFormatter(options: options, calendar: calendar).string(from: self)
            case .custom(let customFormat):
                var ordinalDay: String {
                    cache.numberFormatter.locale = calendar.locale
                    let day = NSNumber(value: component(.day, in: calendar))
                    return cache.numberFormatter.string(from: day) ?? ""
                }

                switch customFormat {
                    case .monthName(.full):
                        return monthName(.full, in: calendar)
                    case .monthName(.short):
                        return monthName(.short, in: calendar)
                    case .monthName(.veryShort):
                        return monthName(.veryShort, in: calendar)
                    case .weekdayName(.full):
                        return weekdayName(.full, in: calendar)
                    case .weekdayName(.short):
                        return weekdayName(.short, in: calendar)
                    case .weekdayName(.veryShort):
                        return weekdayName(.veryShort, in: calendar)
                    case .monthDayOrdinal:
                        return "\(monthName(.full, in: calendar)) \(ordinalDay)"
                    case .monthShortDayOrdinal:
                        return "\(monthName(.short, in: calendar)) \(ordinalDay)"
                    case .monthShortPeriodDayOrdinal:
                        let longMonthName = monthName(.full, in: calendar)
                        let shortMonthName = monthName(.short, in: calendar)
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
        in calendar: Calendar = .default
    ) -> String {
        string(format: .custom(format), in: calendar)
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

        return adjusting(dateComponent, in: calendar)
    }

    /// Adjusts the receiver by given date components.
    ///
    /// - Parameters:
    ///   - components: DateComponents object that contains adjustment values.
    ///   - calendar: The calendar to use for adjustment.
    public func adjusting(_ components: DateComponents, in calendar: Calendar = .default) -> Date  {
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

    /// Adjusts the receiver's given component and along with all smaller units to
    /// their start using the calendar.
    ///
    /// - Parameters:
    ///   - component: Component and along with all smaller units to adjust to their
    ///                start.
    ///   - calendar: The calendar to use for adjustment.
    public func startOf(_ component: Calendar.Component, in calendar: Calendar = .default) -> Date {
        #if DEBUG
        return calendar.dateInterval(of: component, for: self)!.start
        #else
        return calendar.dateInterval(of: component, for: self)?.start ?? self
        #endif
    }

    /// Adjusts the receiver's given component and along with all smaller units to
    /// their end using the calendar.
    ///
    /// - Parameters:
    ///   - component: Component and along with all smaller units to adjust to their
    ///                end.
    ///   - calendar: The calendar to use for adjustment.
    public func endOf(_ component: Calendar.Component, in calendar: Calendar = .default) -> Date {
        #if DEBUG
        let date = calendar.dateInterval(of: component, for: self)!.end
        #else
        let date = calendar.dateInterval(of: component, for: self)?.end ?? self
        #endif

        return Date(timeInterval: -0.001, since: date)
    }
}

// MARK: - Counts

extension Date {
    /// Returns the total number of units to the given date.
    ///
    /// - Parameters:
    ///   - component: The component to calculate.
    ///   - date: A component to calculate to date.
    ///   - calendar: The calendar to calculate the number.
    ///
    /// **Example**
    ///
    /// ```swift
    /// let date = Date(year: 2019, month: 3, day: 4, hour: 2, minute: 22, second: 44)
    /// let anotherDate = Date(year: 2020, month: 4, day: 5, hour: 1, minute: 45, second: 55)
    /// let result = date.numberOf(.year, to: anotherDate)
    ///
    /// print(result) // 1; There is only 1 year between 2019 and 2020.
    /// ```
    public func numberOf(_ component: Calendar.Component, to date: Date, in calendar: Calendar = .default) -> Int {
        #if DEBUG
            return calendar.dateComponents([component], from: self, to: date).value(for: component)!
        #else
            return calendar.dateComponents([component], from: self, to: date).value(for: component) ?? 0
        #endif
    }

    /// Total number of days of month using the `.default` calendar.
    public var monthDays: Int {
        monthDays(in: .default)
    }

    /// Total number of days of month using the given calendar.
    ///
    /// - Parameter calendar: The calendar used to calculate month days.
    public func monthDays(in calendar: Calendar) -> Int {
        calendar.range(of: .day, in: .month, for: self)!.count
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
    ///   - style: The style of the month name.
    ///   - calendar: The calendar to use when formatting name.
    private func monthName(_ style: Format.SymbolStyle, in calendar: Calendar = .default) -> String {
        Self._cache.symbolFormatter.monthName(for: component(.month), style: style, calendar: calendar)
    }

    /// Calculates the weekday name on the receiver date based on calendar.
    ///
    /// - Parameters:
    ///   - style: The style of the weekday name.
    ///   - calendar: The calendar to use when formatting name.
    private func weekdayName(_ style: Format.SymbolStyle, in calendar: Calendar = .default) -> String {
        Self._cache.symbolFormatter.weekdayName(for: component(.weekday), style: style, calendar: calendar)
    }

    /// Calculates the weekday name in the calendar.
    ///
    /// - Parameters:
    ///   - weekday: The weekday number.
    ///   - style: The style of the weekday name.
    ///   - calendar: The calendar to use when formatting name.
    public static func weekdayName(for weekday: Int, style: Format.SymbolStyle = .full, in calendar: Calendar = .default) -> String {
        _cache.symbolFormatter.weekdayName(for: weekday, style: style, calendar: calendar)
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
        in calendar: Calendar = .default
    ) -> DateInterval {
        let date = startOf(component, in: calendar).adjusting(component, by: adjustment, in: calendar)
        return .init(
            start: date,
            end: date.endOf(component, in: calendar)
        )
    }
}

// MARK: - Date Picker

extension Configuration where Type: UIDatePicker {
    public static func `default`(minimumDate: Date) -> Self {
        .init(id: "default") { picker in
            picker.minimumDate = minimumDate
            picker.calendar = .default
            picker.timeZone = Calendar.default.timeZone
        }
    }
}
