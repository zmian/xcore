//
// Xcore
// Copyright © 2014 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

extension FormatStyle where Self == Date.LegacyFormatStyle {
    /// Returns a legacy date format style.
    ///
    /// **Usage**
    ///
    /// ```swift
    /// let formattedDate = Date().formatted(.legacy)
    /// print(formattedDate) // Output: "Oct 17, 2020" (depending on the date)
    /// ```
    ///
    /// - Returns: A legacy date format style.
    static var legacy: Self {
        Date.LegacyFormatStyle()
    }
}

extension Date {
    struct LegacyFormatStyle: Foundation.FormatStyle {
        private static let cache = FormatterCache()

        /// The date style of the receiver.
        var date: Date.FormatStyle.DateStyle

        /// The time style of the receiver.
        var time: Date.FormatStyle.TimeStyle

        /// A Boolean value that indicates whether the receiver uses heuristics when
        /// parsing a string.
        ///
        /// `true` if the receiver has been set to use heuristics when parsing a string
        /// to guess at the date which is intended, otherwise `false`.
        ///
        /// If a formatter is set to be lenient, when parsing a string it uses
        /// heuristics to guess at the date which is intended. As with any guessing, it
        /// may get the result date wrong (that is, a date other than that which was
        /// intended).
        var isLenient: Bool

        /// A Boolean value that indicates whether the receiver uses phrases such as
        /// “today” and “tomorrow” for the date component.
        ///
        /// `true` if the receiver uses relative date formatting, otherwise `false`.
        ///
        /// If a date formatter uses relative date formatting, where possible it
        /// replaces the date component of its output with a phrase—such as “today” or
        /// “tomorrow”—that indicates a relative date. The available phrases depend on
        /// the locale for the date formatter; whereas, for dates in the future, English
        /// may only allow “tomorrow,” French may allow “the day after the day after
        /// tomorrow,” as illustrated in the following example.
        var doesRelativeDateFormatting: Bool

        /// The calendar to use for date values.
        var calendar: Calendar

        init(
            date: Date.FormatStyle.DateStyle = .abbreviated,
            time: Date.FormatStyle.TimeStyle = .shortened,
            isLenient: Bool = true,
            doesRelativeDateFormatting: Bool = false,
            calendar: Calendar = .autoupdatingCurrent
        ) {
            self.date = date
            self.time = time
            self.isLenient = isLenient
            self.doesRelativeDateFormatting = doesRelativeDateFormatting
            self.calendar = calendar
        }

        /// The date style of the receiver.
        func date(_ style: Date.FormatStyle.DateStyle) -> Self {
            applying {
                $0.date = style
            }
        }

        /// The time style of the receiver.
        func time(_ style: Date.FormatStyle.TimeStyle) -> Self {
            applying {
                $0.time = style
            }
        }

        /// A Boolean value that indicates whether the receiver uses heuristics when
        /// parsing a string.
        ///
        /// `true` if the receiver has been set to use heuristics when parsing a string
        /// to guess at the date which is intended, otherwise `false`.
        ///
        /// If a formatter is set to be lenient, when parsing a string it uses
        /// heuristics to guess at the date which is intended. As with any guessing, it
        /// may get the result date wrong (that is, a date other than that which was
        /// intended).
        func isLenient(_ isLenient: Bool) -> Self {
            applying {
                $0.isLenient = isLenient
            }
        }

        /// A Boolean value that indicates whether the receiver uses phrases such as
        /// “today” and “tomorrow” for the date component.
        ///
        /// `true` if the receiver uses relative date formatting, otherwise `false`.
        ///
        /// If a date formatter uses relative date formatting, where possible it
        /// replaces the date component of its output with a phrase—such as “today” or
        /// “tomorrow”—that indicates a relative date. The available phrases depend on
        /// the locale for the date formatter; whereas, for dates in the future, English
        /// may only allow “tomorrow,” French may allow “the day after the day after
        /// tomorrow,” as illustrated in the following example.
        func doesRelativeDateFormatting(_ flag: Bool) -> Self {
            applying {
                $0.doesRelativeDateFormatting = flag
            }
        }

        /// Sets the calendar for formatting dates.
        ///
        /// Specifies the calendar to be used for formatting relative dates. By default,
        /// the `autoupdatingCurrent` calendar is used.
        ///
        /// **Usage**
        ///
        /// ```swift
        /// let calendar = Calendar(identifier: .gregorian)
        /// let formattedDate = Date().formatted(
        ///     .relative
        ///     .calendar(calendar)
        /// )
        /// print(formattedDate) // Output: "June 4, 2022" (depending on the calendar)
        /// ```
        ///
        /// - Parameter calendar: The calendar to apply to the format style.
        /// - Returns: A legacy format style with the specified calendar.
        func calendar(_ calendar: Calendar) -> Self {
            applying {
                $0.calendar = calendar
            }
        }

        func format(_ value: Date) -> String {
            Self.cache.dateFormatter(
                dateStyle: date.style,
                timeStyle: time.style,
                doesRelativeDateFormatting: doesRelativeDateFormatting,
                isLenient: isLenient,
                calendar: calendar
            )
            .string(from: value)
        }
    }
}

// MARK: - FormatterCache

extension Date {
    static let _cache = FormatterCache()

    final class FormatterCache: Sendable {
        private let lock = DispatchQueue(label: #function, attributes: .concurrent)
        nonisolated(unsafe) private let cache = NSCache<NSString, DateFormatter>()

        private func formatter(forKey key: String, _ makeFormatter: () -> DateFormatter) -> DateFormatter {
            let formatter = lock.sync {
                cache.object(forKey: key as NSString)
            }

            if let formatter {
                return formatter
            }

            let newFormatter = makeFormatter()

            lock.async(flags: .barrier) { [unowned self] in
                self.cache.setObject(newFormatter, forKey: key as NSString)
            }

            return newFormatter
        }

        let ordinalNumberFormatter = NumberFormatter().apply {
            $0.numberStyle = .ordinal
        }

        func dateFormatter(
            dateStyle: DateFormatter.Style,
            timeStyle: DateFormatter.Style,
            doesRelativeDateFormatting: Bool,
            isLenient: Bool,
            calendar: Calendar
        ) -> DateFormatter {
            let key = """
            \(dateStyle.rawValue)
            \(timeStyle.rawValue)
            \(doesRelativeDateFormatting)
            \(calendar.identifier)
            \(calendar.timeZone.identifier)
            \(calendar.locale?.identifier ?? "")
            \(isLenient)
            """.sha256()

            return formatter(forKey: key) {
                DateFormatter().apply {
                    $0.dateStyle = dateStyle
                    $0.timeStyle = timeStyle
                    // If/when "Date.FormatStyle" supports "doesRelativeDateFormatting" flag then
                    // Date.LegacyFormatStyle can be removed completely.
                    $0.doesRelativeDateFormatting = doesRelativeDateFormatting
                    $0.calendar = calendar
                    $0.timeZone = calendar.timeZone
                    $0.locale = calendar.locale
                    $0.isLenient = isLenient
                }
            }
        }
    }
}

// MARK: - Helpers

extension Date.FormatStyle.DateStyle {
    fileprivate var style: DateFormatter.Style {
        switch self {
            case .omitted: .none
            case .numeric: .short
            case .abbreviated: .medium
            case .long: .long
            case .complete: .full
            default: .full
        }
    }
}

extension Date.FormatStyle.TimeStyle {
    fileprivate var style: DateFormatter.Style {
        switch self {
            case .omitted: .none
            case .shortened: .short
            case .standard: .medium
            case .complete: .long
            default: .full
        }
    }
}
