//
// Xcore
// Copyright © 2018 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

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
