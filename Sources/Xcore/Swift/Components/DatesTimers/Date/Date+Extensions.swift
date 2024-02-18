//
// Xcore
// Copyright © 2014 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

extension Date {
    /// Temporarily changes the `default` calendar to the given calendar for the
    /// scope of work.
    ///
    /// This method allows you to perform date-related operations within a specific
    /// calendar without permanently changing the `default` calendar.
    ///
    /// - Parameters:
    ///   - new: The calendar to set as the temporary `default`.
    ///   - work: A closure representing the scope of work to be performed with the
    ///     temporary `default` calendar.
    /// - Returns: The result of the work closure.
    ///
    /// **Usage**
    ///
    /// ```swift
    /// let result = Date.calendar(.gregorian) {
    ///     // Perform date-related operations using the .gregorian calendar
    ///     let currentDate = Date()
    ///     let formattedDate = currentDate.format(.monthYear(.abbreviated)):
    ///     print("Formatted Date: \(formattedDate)")
    ///
    ///     // Additional date-related operations within the .gregorian calendar
    ///     // ...
    ///
    ///     // The .gregorian calendar is automatically restored to the original
    ///     // default after this scope.
    /// }
    /// ```
    ///
    /// - Note: The `default` calendar is restored to its original state after the
    ///   work closure completes, even if an error occurs within the closure.
    public static func calendar<R>(_ new: Calendar, work: () throws -> R) rethrows -> R {
        let current = Calendar.default
        Calendar.default = new
        defer { Calendar.default = current }
        return try work()
    }
}

// MARK: - Transform

extension Date {
    /// Represents the epoch timestamp in milliseconds.
    ///
    /// The epoch, also known as Unix timestamps, is the number of seconds (not
    /// milliseconds) that have elapsed since `January 1, 1970` at `00:00:00 UTC`
    /// (`1970-01-01 00:00:00 UTC`). This property returns the equivalent epoch
    /// timestamp in milliseconds.
    ///
    /// **Usage**
    ///
    /// ```swift
    /// let currentDate = Date()
    /// let epochMilliseconds = currentDate.milliseconds
    /// print("Epoch Timestamp (in milliseconds): \(epochMilliseconds)")
    /// ```
    public var milliseconds: Int64 {
        Int64(timeIntervalSince1970 * 1000)
    }

    /// Retrieves the value of a specified date component from the receiver.
    ///
    /// **Usage**
    ///
    /// ```swift
    /// let date = Date(year: 2020, month: 2, day: 1, hour: 3, minute: 41, second: 22)
    ///
    /// // Example in the default calendar
    /// let year = date.component(.year)
    /// let month = date.component(.month)
    /// let day = date.component(.day)
    ///
    /// print(year)  // 2020
    /// print(month) // 2
    /// print(day)   // 1
    ///
    /// // Example in a different calendar (e.g., US Eastern)
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
    ///
    /// - Parameters:
    ///   - component: The date component for which to retrieve the value.
    ///   - calendar: The calendar to use for retrieval.
    public func component(_ component: Calendar.Component, in calendar: Calendar = .default) -> Int {
        calendar.component(component, from: self)
    }

    /// Creates a date interval by adjusting the specified date component.
    ///
    /// **Usage**
    ///
    /// ```swift
    /// let date = Date()
    ///
    /// // Create an interval by adjusting the day component
    /// let dayInterval = date.interval(for: .day, adjustedBy: 5)
    ///
    /// print(dayInterval.start) // Adjusted start date
    /// print(dayInterval.end)   // Adjusted end date
    /// ```
    ///
    /// - Parameters:
    ///   - component: The date component to adjust for the interval.
    ///   - adjustment: The offset to adjust the specified component.
    ///   - calendar: The calendar to use for adjustment.
    /// - Returns: A `DateInterval` instance representing the adjusted interval.
    public func interval(
        for component: Calendar.Component,
        adjustedBy adjustment: Int = 0,
        in calendar: Calendar = .default
    ) -> DateInterval {
        let date = startOf(component, in: calendar)
            .adjusting(component, by: adjustment, in: calendar)

        return .init(start: date, end: date.endOf(component, in: calendar))
    }
}

// MARK: - Adjustments

extension Date {
    /// Adjusts the receiver by adding the specified date components.
    ///
    /// **Usage**
    ///
    /// ```swift
    /// let currentDate = Date()
    /// var dateComponent = DateComponents()
    /// dateComponent.day = 7
    /// let futureDate = currentDate.adjusting(dateComponent)
    ///
    /// print(futureDate) // A date representing 7 days in the future.
    /// ```
    ///
    /// - Parameters:
    ///   - components: A `DateComponents` object that contains adjustment values.
    ///   - calendar: The calendar to use for the adjustment.
    /// - Returns: A new `Date` object representing the adjusted date.
    public func adjusting(_ components: DateComponents, in calendar: Calendar = .default) -> Date {
        calendar.date(byAdding: components, to: self)!
    }

    /// Adjusts the receiver by adding the specified offset to the given component
    /// in the set calendar.
    ///
    /// **Usage**
    ///
    /// ```swift
    /// let currentDate = Date()
    /// let futureDate = currentDate.adjusting(.day, by: 7)
    ///
    /// print(futureDate) // A date representing 7 days in the future.
    /// ```
    ///
    /// - Parameters:
    ///   - component: The calendar component to adjust.
    ///   - offset: The offset value to add to the specified component.
    ///   - calendar: The calendar to use for the adjustment.
    /// - Returns: A new `Date` object representing the adjusted date.
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
            case .calendar, .timeZone, .isLeapMonth:
                fatalError("Unsupported type \(component)")
            @unknown default:
                fatalError("Unsupported type \(component)")
        }

        return adjusting(dateComponent, in: calendar)
    }

    /// Adjusts the receiver, along with all smaller units, to the beginning of the
    /// specified component using the set calendar.
    ///
    /// **Usage**
    ///
    /// ```swift
    /// let currentDate = Date()
    /// let startOfDay = currentDate.startOf(.day)
    ///
    /// print(startOfDay) // A date representing the start of the current day.
    /// ```
    ///
    /// - Parameters:
    ///   - component: The calendar component to adjust along with its smaller units
    ///     to their start.
    ///   - calendar: The calendar to use for the adjustment.
    /// - Returns: A new `Date` object representing the adjusted date.
    public func startOf(_ component: Calendar.Component, in calendar: Calendar = .default) -> Date {
        #if DEBUG
        return calendar.dateInterval(of: component, for: self)!.start
        #else
        return calendar.dateInterval(of: component, for: self)?.start ?? self
        #endif
    }

    /// Adjusts the receiver, along with all smaller units, to the end of the
    /// specified component using the set calendar.
    ///
    /// **Usage**
    ///
    /// ```swift
    /// let currentDate = Date()
    /// let endOfDay = currentDate.endOf(.day)
    ///
    /// print(endOfDay) // A date representing the end of the current day.
    /// ```
    ///
    /// - Parameters:
    ///   - component: The calendar component to adjust along with its smaller units
    ///     to their end.
    ///   - calendar: The calendar to use for the adjustment.
    /// - Returns: A new `Date` object representing the adjusted date.
    public func endOf(_ component: Calendar.Component, in calendar: Calendar = .default) -> Date {
        #if DEBUG
        let date = calendar.dateInterval(of: component, for: self)!.end
        #else
        let date = calendar.dateInterval(of: component, for: self)?.end ?? self
        #endif

        return Date(timeInterval: -0.001, since: date)
    }

    /// Adjusts the receiver's date, along with all smaller units, to the middle of
    /// the specified component using the set calendar.
    ///
    /// **Usage**
    ///
    /// ```swift
    /// let currentDate = Date()
    /// let middleOfDay = currentDate.middleOf(.day)
    ///
    /// print(middleOfDay) // A date representing the middle of the current day.
    /// ```
    ///
    /// - Parameters:
    ///   - component: The calendar component to adjust along with its smaller units
    ///     to their middle.
    ///   - calendar: The calendar to use for the adjustment.
    /// - Returns: A new `Date` object representing the adjusted date.
    public func middleOf(_ component: Calendar.Component, in calendar: Calendar = .default) -> Date {
        #if DEBUG
        let date = calendar.dateInterval(of: component, for: self)!.middle
        #else
        let date = calendar.dateInterval(of: component, for: self)?.middle ?? self
        #endif

        return Date(timeInterval: -0.001, since: date)
    }
}

// MARK: - Counts

extension Date {
    /// Returns the time zone offset of a calendar from UTC.
    ///
    /// **Usage**
    ///
    /// ```swift
    /// let result = Date.timeZoneOffset(calendar: .usEastern)
    /// print(result) // -4; Eastern time zone is 4 hours behind UTC.
    /// ```
    ///
    /// - Parameter calendar: The calendar used to calculate the time zone offset.
    /// - Returns: The time zone offset in hours.
    public static func timeZoneOffset(calendar: Calendar = .default) -> Int {
        calendar.timeZone.secondsFromGMT() / 3600
    }

    /// Returns the total number of days in the month using the given calendar.
    ///
    /// **Usage**
    ///
    /// ```swift
    /// let date = Date(year: 2022, month: 2, day: 15)
    /// let daysInMonth = date.monthDays()
    ///
    /// print(daysInMonth) // 28; February in a non-leap year.
    /// ```
    ///
    /// - Parameter calendar: The calendar used to calculate the month days.
    /// - Returns: The total number of days in the month.
    public func monthDays(in calendar: Calendar = .default) -> Int {
        calendar.range(of: .day, in: .month, for: self)!.count
    }

    /// Returns the total number of units from the receiver to the specified date.
    ///
    /// **Usage**
    ///
    /// ```swift
    /// let date = Date(year: 2019, month: 3, day: 4, hour: 2, minute: 22, second: 44)
    /// let anotherDate = Date(year: 2020, month: 4, day: 5, hour: 1, minute: 45, second: 55)
    /// let result = date.numberOf(.year, to: anotherDate)
    ///
    /// print(result) // 1; There is only 1 year between 2019 and 2020.
    /// ```
    ///
    /// - Parameters:
    ///   - component: The component to calculate (e.g., year, month, day).
    ///   - date: The target date for the calculation.
    ///   - calendar: The calendar to use for the calculation.
    /// - Returns: The number of units between the receiver and the specified date.
    public func numberOf(_ component: Calendar.Component, to date: Date, in calendar: Calendar = .default) -> Int {
        #if DEBUG
        return calendar.dateComponents([component], from: self, to: date).value(for: component)!
        #else
        return calendar.dateComponents([component], from: self, to: date).value(for: component) ?? 0
        #endif
    }
}

// MARK: - Date Picker

extension XConfiguration where Type: UIDatePicker {
    public static func `default`(minimumDate: Date) -> Self {
        .init(id: "default") { picker in
            picker.minimumDate = minimumDate
            picker.calendar = .default
            picker.timeZone = Calendar.default.timeZone
        }
    }
}
