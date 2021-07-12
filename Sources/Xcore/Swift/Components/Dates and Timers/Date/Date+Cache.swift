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

        let numberFormatter = NumberFormatter().apply {
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
            """.sha256() ?? ""

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
            """.sha256() ?? ""

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
            """.sha256() ?? ""

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
