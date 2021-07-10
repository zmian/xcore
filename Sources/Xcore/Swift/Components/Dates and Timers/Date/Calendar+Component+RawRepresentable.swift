//
// Xcore
// Copyright © 2019 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

extension Calendar.Component: RawRepresentable {
    public init?(rawValue: String) {
        switch rawValue {
            case Self.era.rawValue:
                self = .era
            case Self.year.rawValue:
                self = .year
            case Self.month.rawValue:
                self = .month
            case Self.day.rawValue:
                self = .day
            case Self.hour.rawValue:
                self = .hour
            case Self.minute.rawValue:
                self = .minute
            case Self.second.rawValue:
                self = .second
            case Self.weekday.rawValue:
                self = .weekday
            case Self.weekdayOrdinal.rawValue:
                self = .weekdayOrdinal
            case Self.quarter.rawValue:
                self = .quarter
            case Self.weekOfMonth.rawValue:
                self = .weekOfMonth
            case Self.weekOfYear.rawValue:
                self = .weekOfYear
            case Self.yearForWeekOfYear.rawValue:
                self = .yearForWeekOfYear
            case Self.nanosecond.rawValue:
                self = .nanosecond
            case Self.calendar.rawValue:
                self = .calendar
            case Self.timeZone.rawValue:
                self = .timeZone
            default:
                return nil
        }
    }

    public var rawValue: String {
        switch self {
            case .era:
                return "era"
            case .year:
                return "year"
            case .month:
                return "month"
            case .day:
                return "day"
            case .hour:
                return "hour"
            case .minute:
                return "minute"
            case .second:
                return "second"
            case .weekday:
                return "weekday"
            case .weekdayOrdinal:
                return "weekdayOrdinal"
            case .quarter:
                return "quarter"
            case .weekOfMonth:
                return "weekOfMonth"
            case .weekOfYear:
                return "weekOfYear"
            case .yearForWeekOfYear:
                return "yearForWeekOfYear"
            case .nanosecond:
                return "nanosecond"
            case .calendar:
                return "calendar"
            case .timeZone:
                return "timeZone"
            @unknown default:
                return "unknown"
        }
    }
}
