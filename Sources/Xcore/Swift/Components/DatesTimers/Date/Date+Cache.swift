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
        private let cache = NSCache<NSString, Formatter>()

        private func register(formatter: Formatter, with key: String) {
            queue.async(flags: .barrier) { [unowned self] in
                self.cache.setObject(formatter, forKey: key as NSString)
            }
        }

        private func get(key: String) -> Formatter? {
            queue.sync {
                cache.object(forKey: key as NSString)
            }
        }

        let ordinalNumberFormatter = NumberFormatter().apply {
            $0.numberStyle = .ordinal
        }

        let symbolFormatter = SymbolDateFormatter()

        func dateFormatter(
            format: String,
            doesRelativeDateFormatting: Bool = false,
            calendar: Calendar = .default,
            isLenient: Bool = true
        ) -> DateFormatter {
            let key = """
            \(format)
            \(doesRelativeDateFormatting)
            \(calendar.identifier)
            \(calendar.timeZone.identifier)
            \(calendar.locale?.identifier ?? "")
            \(isLenient)
            """.sha256()

            if let formatter = get(key: key) as? DateFormatter {
                return formatter
            }

            let formatter = DateFormatter().apply {
                $0.dateFormat = format
                $0.calendar = calendar
                $0.timeZone = calendar.timeZone
                $0.locale = calendar.locale
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
            calendar: Calendar,
            isLenient: Bool = true
        ) -> DateFormatter {
            let key = """
            \(dateStyle.rawValue)
            \(timeStyle.rawValue)
            \(doesRelativeDateFormatting)
            \(calendar.identifier)
            \(calendar.timeZone.identifier)
            \(calendar.locale?.identifier ?? "")
            \(isLenient.hashValue)
            """.sha256()

            if let formatter = get(key: key) as? DateFormatter {
                return formatter
            }

            let formatter = DateFormatter().apply {
                $0.dateStyle = dateStyle
                $0.timeStyle = timeStyle
                $0.doesRelativeDateFormatting = doesRelativeDateFormatting
                $0.calendar = calendar
                $0.timeZone = calendar.timeZone
                $0.locale = calendar.locale
                $0.isLenient = isLenient
            }
            register(formatter: formatter, with: key)
            return formatter
        }

        func dateFormatter(
            options: ISO8601DateFormatter.Options,
            calendar: Calendar
        ) -> ISO8601DateFormatter {
            let key = """
            \(options.rawValue)
            \(calendar.timeZone.identifier)
            """.sha256()

            if let formatter = get(key: key) as? ISO8601DateFormatter {
                return formatter
            }

            let formatter = ISO8601DateFormatter().apply {
                $0.timeZone = calendar.timeZone
                $0.formatOptions = options
            }
            register(formatter: formatter, with: key)
            return formatter
        }
    }
}

extension Date {
    final class SymbolDateFormatter {
        private let formatter = DateFormatter().apply {
            $0.calendar = .default
            $0.timeZone = $0.calendar.timeZone
            $0.locale = $0.calendar.locale
        }

        var calendar: Calendar {
            get { formatter.calendar }
            set {
                formatter.calendar = newValue
                formatter.timeZone = newValue.timeZone
                formatter.locale = newValue.locale
            }
        }

        /// Calculates the month name in the calendar.
        ///
        /// - Parameters:
        ///   - month: The month number in year.
        ///   - style: The length of the month name.
        ///   - calendar: The calendar to use when formatting name.
        func monthName(for month: Int, style: Date.Style.Width, calendar: Calendar = .default) -> String {
            self.calendar = calendar

            let symbols: [String]

            switch style {
                case .wide:
                    symbols = formatter.monthSymbols
                case .abbreviated:
                    symbols = formatter.shortMonthSymbols
                case .narrow:
                    symbols = formatter.veryShortMonthSymbols
            }

            return symbols[month - 1]
        }

        /// Calculates the weekday name in the calendar.
        ///
        /// - Parameters:
        ///   - weekday: The weekday number.
        ///   - style: The length of the weekday name.
        ///   - calendar: The calendar to use when formatting name.
        func weekdayName(for weekday: Int, style: Date.Style.Width, calendar: Calendar = .default) -> String {
            self.calendar = calendar

            let symbols: [String]

            switch style {
                case .wide:
                    symbols = formatter.weekdaySymbols
                case .abbreviated:
                    symbols = formatter.shortWeekdaySymbols
                case .narrow:
                    symbols = formatter.veryShortWeekdaySymbols
            }

            return symbols[weekday - 1]
        }
    }
}
