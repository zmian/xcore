//
// Xcore
// Copyright © 2018 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

// MARK: - ComparisonOperator

extension Date {
    public enum ComparisonOperator {
        /// Receiver must be today with granularity matching at least down to the `day`.
        /// For example, the receiver year, month, day must match today.
        case today
        /// Receiver must be tomorrow with granularity matching at least down to the
        /// `day`. For example, the receiver year, month, day must match tomorrow.
        case tomorrow
        /// Receiver must be yesterday with granularity matching at least down to the
        /// `day`. For example, the receiver year, month, day must match yesterday.
        case yesterday
        /// Receiver component must be equal to given `component + 1`.
        case next(Calendar.Component)
        /// Receiver component must be equal to given `component - 1`.
        case previous(Calendar.Component)
        /// Receiver component must be `component - n` where `n <= 1`.
        case past(Calendar.Component)
        /// Receiver component must be same `component` as current.
        case current(Calendar.Component)
        /// Receiver component must be `component + n` where `n >= 1`.
        case future(Calendar.Component)
    }

    /// Compares the receiver with the given comparison operator.
    ///
    /// ```swift
    /// let date = Date(year: 2020, month: 2, day: 1, hour: 3, minute: 41, second: 22)
    ///
    /// date.is(.yesterday)
    /// date.is(.today)
    /// date.is(.tomorrow)
    ///
    /// // Granularity
    /// date.is(.next(.day))
    /// date.is(.previous(.day))
    ///
    /// date.is(.next(.weekday))
    /// date.is(.previous(.weekday))
    ///
    /// date.is(.next(.month))
    /// date.is(.previous(.month))
    ///
    /// date.is(.next(.year))
    /// date.is(.previous(.year))
    ///
    /// // Granularity
    /// date.is(.past(.month))
    /// date.is(.current(.month))
    /// date.is(.future(.month))
    /// ```
    ///
    /// - Parameters:
    ///   - comparison: The comparison operator to use to determine the comparison.
    ///   - calendar: The calendar to use when comparing.
    public func `is`(_ comparison: ComparisonOperator, in calendar: Calendar = .default) -> Bool {
        switch comparison {
            case .today:
                return `is`(.current(.day), in: calendar)
            case .tomorrow:
                return `is`(.next(.day), in: calendar)
            case .yesterday:
                return `is`(.previous(.day), in: calendar)
            case let .next(granularity):
                let next = Date().adjusting(granularity, by: 1, in: calendar)
                return isSame(next, granularity: granularity, in: calendar)
            case let .previous(granularity):
                let previous = Date().adjusting(granularity, by: -1, in: calendar)
                return isSame(previous, granularity: granularity, in: calendar)
            case let .past(granularity):
                return isBefore(Date(), granularity: granularity, in: calendar)
            case let .current(granularity):
                return isSame(Date(), granularity: granularity, in: calendar)
            case let .future(granularity):
                return isAfter(Date(), granularity: granularity, in: calendar)
        }
    }
}

extension Date {
    /// Compares whether the receiver is before, after or equal to `date` based on
    /// their components down to a given unit granularity.
    ///
    /// - Parameters:
    ///   - date: Reference date.
    ///   - granularity: Smallest unit that must, along with all larger units, be
    ///     less for the given date.
    ///   - calendar: The calendar to use when comparing.
    public func compare(to date: Date, granularity: Calendar.Component, in calendar: Calendar = .default) -> ComparisonResult {
        calendar.compare(self, to: date, toGranularity: granularity)
    }

    /// Compares equality of two given dates based on their components down to a
    /// given unit granularity.
    ///
    /// - Parameters:
    ///   - date: The date to compare.
    ///   - granularity: The smallest unit that must, along with all larger units,
    ///     be equal for the given dates to be considered the same.
    ///   - calendar: The calendar to use when comparing.
    /// - Returns: `true` if the dates are the same down to the given granularity,
    ///   otherwise `false`.
    public func isSame(_ date: Date, granularity: Calendar.Component, in calendar: Calendar = .default) -> Bool {
        compare(to: date, granularity: granularity, in: calendar) == .orderedSame
    }

    /// Compares whether the receiver is before/before equal `date` based on their
    /// components down to a given unit granularity.
    ///
    /// - Parameters:
    ///   - date: The date to compare.
    ///   - orEqual: `true` to also check for equality.
    ///   - granularity: Smallest unit that must, along with all larger units, be
    ///     less for the given dates.
    ///   - calendar: The calendar to use when comparing.
    public func isBefore(
        _ date: Date,
        orEqual: Bool = false,
        granularity: Calendar.Component,
        in calendar: Calendar = .default
    ) -> Bool {
        let result = compare(to: date, granularity: granularity, in: calendar)
        return (orEqual ? (result == .orderedSame || result == .orderedAscending) : result == .orderedAscending)
    }

    /// Compares whether the receiver is after `date` based on their components down
    /// to a given unit granularity.
    ///
    /// - Parameters:
    ///   - date: The date to compare.
    ///   - orEqual: `true` to also check for equality.
    ///   - granularity: Smallest unit that must, along with all larger units, be
    ///     greater for the given dates.
    ///   - calendar: The calendar to use when comparing.
    public func isAfter(
        _ date: Date,
        orEqual: Bool = false,
        granularity: Calendar.Component,
        in calendar: Calendar = .default
    ) -> Bool {
        let result = compare(to: date, granularity: granularity, in: calendar)
        return (orEqual ? (result == .orderedSame || result == .orderedDescending) : result == .orderedDescending)
    }

    /// Returns `true` if receiver date is contained in the specified interval.
    ///
    /// - Parameters:
    ///   - interval: The date interval.
    ///   - orEqual: `true` to also check for equality on the given interval.
    ///   - granularity: Smallest unit that must, along with all larger units, be
    ///     greater for the given dates.
    ///   - calendar: The calendar to use when comparing.
    public func isBetween(
        _ interval: DateInterval,
        orEqual: Bool = false,
        granularity: Calendar.Component = .nanosecond,
        in calendar: Calendar = .default
    ) -> Bool {
        isAfter(interval.start, orEqual: orEqual, granularity: granularity, in: calendar) &&
            isBefore(interval.end, orEqual: orEqual, granularity: granularity, in: calendar)
    }
}
