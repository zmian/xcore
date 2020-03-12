//
// Date+Extensions.swift
// Copyright © 2014 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

// MARK: Date Extension

extension Date {
    public func fromNow(style: DateComponentsFormatter.UnitsStyle = .abbreviated, format: String = "%@") -> String? {
        let formatter = DateComponentsFormatter().apply {
            $0.unitsStyle = style
            $0.maximumUnitCount = 1
            $0.allowedUnits = [.year, .month, .day, .hour, .minute, .second]
        }

        guard let timeString = formatter.string(from: self, to: Date()) else {
            return nil
        }

        let formatString = NSLocalizedString(format, comment: "Used to say how much time has passed (e.g. '2 hours ago').")
        return String(format: formatString, timeString)
    }

    /// Reset time to beginning of the day (`12 AM`) of `self` without changing the timezone.
    public func stripTime() -> Date {
        let components = Calendar.current.dateComponents([.year, .month, .day], from: self)
        return Calendar.current.date(from: components) ?? self
    }

    // MARK: UTC

    private static let utcDateFormatter = DateFormatter().apply {
        $0.timeZone = .utc
        $0.dateFormat = "yyyy-MM-dd"
    }

    public var utc: Date {
        let dateString = Date.utcDateFormatter.string(from: self)
        Date.utcDateFormatter.timeZone = .current
        let date = Date.utcDateFormatter.date(from: dateString)!
        Date.utcDateFormatter.timeZone = .utc
        return date
    }
}

extension Date {
    /// Epoch in milliseconds.
    ///
    /// Epoch, also known as Unix timestamps, is the number of seconds
    /// (not milliseconds) that have elapsed since January 1, 1970 at 00:00:00 GMT
    /// (1970-01-01 00:00:00 GMT).
    public var unixTimeMilliseconds: Int64 {
        Int64(timeIntervalSince1970 * 1000)
    }

    public init(
        year: Int,
        month: Int,
        day: Int,
        hour: Int? = nil,
        minute: Int? = nil,
        second: Int? = nil
    ) {
        let dateComponent = DateComponents(
            year: year,
            month: month,
            day: day,
            hour: hour,
            minute: minute,
            second: second
        )

        self = Calendar.current.date(from: dateComponent)!
    }
}

extension TimeZone {
    public static let utc = TimeZone(identifier: "UTC")!
}
