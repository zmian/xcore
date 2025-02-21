//
// Xcore
// Copyright © 2014 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

extension FormatStyle where Self == Date.LegacyFormatStyle {
    /// A legacy date format style.
    ///
    /// This static property provides an instance of `LegacyFormatStyle`, enabling
    /// date and time formatting with legacy behaviors like relative date phrases
    /// and leniency.
    ///
    /// **Usage**
    ///
    /// ```swift
    /// let formattedDate = Date().formatted(.legacy)
    /// print(formattedDate) // Output: "Jun 4, 2022" (depending on the date)
    /// ```
    ///
    /// - Returns: A `LegacyFormatStyle` instance.
    static var legacy: Self {
        Date.LegacyFormatStyle()
    }
}

extension Date {
    /// A format style that provides legacy date and time formatting capabilities.
    ///
    /// This format style extends `Foundation.FormatStyle` and allows customization
    /// of date and time styles, leniency, relative date formatting, and calendar
    /// configurations.
    struct LegacyFormatStyle: Foundation.FormatStyle {
        private static let cache = FormatterCache()

        /// The date style of the format style.
        var date: Date.FormatStyle.DateStyle

        /// The time style of the format style.
        var time: Date.FormatStyle.TimeStyle

        /// Indicates whether the format style uses heuristics when parsing a date string.
        ///
        /// If set to `true`, the formatter guesses the intended date when parsing
        /// a string. However, this can lead to incorrect results in some cases.
        var isLenient: Bool

        /// Indicates whether the format style uses relative date phrases.
        ///
        /// If set to `true`, the formatter replaces the date component with phrases
        /// like "today" or "tomorrow" where applicable. Phrases vary by locale.
        var doesRelativeDateFormatting: Bool

        /// The calendar to use for formatting dates.
        var calendar: Calendar

        /// Initializes a `LegacyFormatStyle` with the specified settings.
        ///
        /// - Parameters:
        ///   - date: The date style to use. Defaults to `.abbreviated`.
        ///   - time: The time style to use. Defaults to `.shortened`.
        ///   - isLenient: Whether to use lenient parsing. Defaults to `true`.
        ///   - doesRelativeDateFormatting: Whether to use relative date formatting.
        ///     Defaults to `false`.
        ///   - calendar: The calendar to use for formatting. Defaults to `.autoupdatingCurrent`.
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

        /// Updates the date style for the format style.
        ///
        /// **Usage**
        ///
        /// ```swift
        /// let formattedDate = Date().formatted(
        ///     .legacy
        ///     .date(.abbreviated)
        /// )
        /// ```
        ///
        /// - Parameter style: The desired date style.
        /// - Returns: A new `LegacyFormatStyle` instance with the updated date style.
        func date(_ style: Date.FormatStyle.DateStyle) -> Self {
            applying {
                $0.date = style
            }
        }

        /// Updates the time style for the format style.
        ///
        /// **Usage**
        ///
        /// ```swift
        /// let formattedDate = Date().formatted(
        ///     .legacy
        ///     .time(.shortened)
        /// )
        /// ```
        ///
        /// - Parameter style: The desired time style.
        /// - Returns: A new `LegacyFormatStyle` instance with the updated time style.
        func time(_ style: Date.FormatStyle.TimeStyle) -> Self {
            applying {
                $0.time = style
            }
        }

        /// Configures whether the formatter uses heuristics when parsing dates.
        ///
        /// **Usage**
        ///
        /// **Usage**
        ///
        /// ```swift
        /// let formattedDate = Date().formatted(
        ///     .legacy
        ///     .isLenient(true)
        /// )
        /// ```
        ///
        /// - Parameter isLenient: A Boolean value indicating whether leniency is enabled.
        /// - Returns: A new `LegacyFormatStyle` instance with the updated leniency setting.
        func isLenient(_ isLenient: Bool) -> Self {
            applying {
                $0.isLenient = isLenient
            }
        }

        /// Configures whether the formatter uses relative date phrases such as “today”
        /// and “tomorrow” for the date component.
        ///
        /// **Usage**
        ///
        /// ```swift
        /// let formattedDate = Date().formatted(
        ///     .legacy
        ///     .doesRelativeDateFormatting(true)
        /// )
        /// ```
        ///
        /// - Parameter flag: A Boolean value indicating whether relative date formatting is enabled.
        /// - Returns: A new `LegacyFormatStyle` instance with the updated setting.
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
        ///     .legacy
        ///     .calendar(calendar)
        /// )
        /// print(formattedDate) // Output: "Jun 4, 2022" (depending on the calendar)
        /// ```
        ///
        /// - Parameter calendar: The calendar to apply to the format style.
        /// - Returns: A new `LegacyFormatStyle` instance with the updated calendar.
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
        private let cache = Cache<String, DateFormatter>()

        private func formatter(forKey key: String, _ makeFormatter: () -> DateFormatter) -> DateFormatter {
            let formatter = lock.sync {
                cache[key]
            }

            if let formatter {
                return formatter
            }

            let newFormatter = makeFormatter()

            lock.async(flags: .barrier) { [unowned self] in
                self.cache[key] = newFormatter
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
