//
// Xcore
// Copyright © 2014 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

// MARK: - Internal use

extension Date {
    static let _cache = _FormatterCache()
}

extension Date {
    final class _FormatterCache {
        private let queue = DispatchQueue(label: #function, attributes: .concurrent)
        private var cache = [String: DateFormatter]()

        private func register(formatter: DateFormatter, with key: String) {
            queue.async(flags: .barrier) { [unowned self] in
                self.cache.updateValue(formatter, forKey: key)
            }
        }

        private func get(key: String) -> DateFormatter? {
            queue.sync {
                cache[key]
            }
        }

        let numberFormatter = NumberFormatter().apply {
            $0.numberStyle = .ordinal
        }

        func dateFormatter(
            format: String,
            doesRelativeDateFormatting: Bool = false,
            region: Date.Region = .default,
            isLenient: Bool = true
        ) -> DateFormatter {
            let key = """
                \(format)
                \(doesRelativeDateFormatting.hashValue)
                \(region.calendar.hashValue)
                \(region.timeZone.hashValue)
                \(region.locale.hashValue)
                \(isLenient.hashValue)
                """.sha256() ?? ""

            if let formatter = get(key: key) {
                return formatter
            }

            let formatter = DateFormatter().apply {
                $0.dateFormat = format
                $0.calendar = region.calendar
                $0.timeZone = region.timeZone
                $0.locale = region.locale
                $0.isLenient = isLenient
                $0.doesRelativeDateFormatting = doesRelativeDateFormatting
            }
            register(formatter: formatter, with: key)
            return formatter
        }

        func dateFormatter(
            dateStyle: DateFormatter.Style = .none,
            timeStyle: DateFormatter.Style = .none,
            doesRelativeDateFormatting: Bool = false,
            region: Date.Region,
            isLenient: Bool = true
        ) -> DateFormatter {
            let key = """
                \(dateStyle.hashValue)
                \(timeStyle.hashValue)
                \(doesRelativeDateFormatting.hashValue)
                \(region.calendar.identifier)
                \(region.timeZone.identifier)
                \(region.locale.identifier)
                \(isLenient.hashValue)
                """.sha256() ?? ""

            if let formatter = get(key: key) {
                return formatter
            }

            let formatter = DateFormatter().apply {
                $0.dateStyle = dateStyle
                $0.timeStyle = timeStyle
                $0.doesRelativeDateFormatting = doesRelativeDateFormatting
                $0.calendar = region.calendar
                $0.timeZone = region.timeZone
                $0.locale = region.locale
                $0.isLenient = isLenient
            }
            register(formatter: formatter, with: key)
            return formatter
        }
    }
}

extension Calendar.Component {
    var _nsCalendarUnit: NSCalendar.Unit {
        switch self {
            case .era:
                return NSCalendar.Unit.era
            case .year:
                return NSCalendar.Unit.year
            case .month:
                return NSCalendar.Unit.month
            case .day:
                return NSCalendar.Unit.day
            case .hour:
                return NSCalendar.Unit.hour
            case .minute:
                return NSCalendar.Unit.minute
            case .second:
                return NSCalendar.Unit.second
            case .weekday:
                return NSCalendar.Unit.weekday
            case .weekdayOrdinal:
                return NSCalendar.Unit.weekdayOrdinal
            case .quarter:
                return NSCalendar.Unit.quarter
            case .weekOfMonth:
                return NSCalendar.Unit.weekOfMonth
            case .weekOfYear:
                return NSCalendar.Unit.weekOfYear
            case .yearForWeekOfYear:
                return NSCalendar.Unit.yearForWeekOfYear
            case .nanosecond:
                return NSCalendar.Unit.nanosecond
            case .calendar:
                return NSCalendar.Unit.calendar
            case .timeZone:
                return NSCalendar.Unit.timeZone
            @unknown default:
                fatalError("Unsupported type \(self)")
        }
    }
}
