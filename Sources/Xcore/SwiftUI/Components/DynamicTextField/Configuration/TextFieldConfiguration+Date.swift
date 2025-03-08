//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

extension TextFieldConfiguration {
    /// A configuration for a date-based text field, allowing constraints on
    /// selectable date ranges.
    public struct Date: Sendable, Hashable {
        /// The minimum allowable date.
        public let min: Foundation.Date?

        /// The maximum allowable date.
        public let max: Foundation.Date?

        /// The currently selected date.
        public let selection: Foundation.Date

        /// Initializes a date configuration with optional constraints.
        ///
        /// - Parameters:
        ///   - min: The earliest selectable date, or `nil` for no minimum.
        ///   - max: The latest selectable date, or `nil` for no maximum.
        ///   - selection: The initially selected date. Defaults to `January 1, 2000`.
        public init(
            min: Foundation.Date?,
            max: Foundation.Date?,
            selection: Foundation.Date = .init(year: 2000, month: 1, day: 1)
        ) {
            self.min = min
            self.max = max
            self.selection = selection
        }
    }
}

// MARK: - Built-in

extension TextFieldConfiguration.Date {
    /// A configuration allowing selection of past dates up to today.
    public static var pastDate: Self {
        .init(
            min: nil,
            max: .now,
            selection: .now
        )
    }

    /// A configuration allowing selection of future dates from today onward.
    public static var futureDate: Self {
        .init(
            min: .now,
            max: nil,
            selection: .now
        )
    }

    /// A configuration ensuring a minimum age of 18, with a maximum age limit of
    /// 150 years.
    public static var minimumAge18: Self {
        .init(
            min: Calendar.current.date(byAdding: .year, value: -150, to: .now),
            max: Calendar.current.date(byAdding: .year, value: -18, to: .now)
        )
    }

    /// A configuration allowing selection of dates up to one year from today.
    public static var aYearFromToday: Self {
        now(toYear: 1)
    }

    /// Creates a date configuration allowing selection up to a specified number of
    /// years from today.
    ///
    /// - Parameter year: The number of years to add.
    /// - Returns: A new date configuration.
    public static func now(toYear year: Int) -> Self {
        now(byAdding: .year, value: year)
    }

    /// Creates a date configuration allowing selection up to a specified number of
    /// months from today.
    ///
    /// - Parameter month: The number of months to add.
    /// - Returns: A new date configuration.
    public static func now(toMonth month: Int) -> Self {
        now(byAdding: .month, value: month)
    }

    /// Creates a date configuration by adding a specified time component to today.
    ///
    /// - Parameters:
    ///   - component: The calendar component to add (e.g., `.year`, `.month`).
    ///   - value: The amount of the component to add.
    /// - Returns: A new date configuration.
    public static func now(byAdding component: Calendar.Component, value: Int) -> Self {
        .init(
            min: .now,
            max: Calendar.current.date(byAdding: component, value: value, to: .now),
            selection: .now
        )
    }
}

// MARK: - Date

extension TextFieldConfiguration<PassthroughTextFieldFormatter> {
    /// A text field configuration for entering a date of birth.
    ///
    /// The date must be formatted as `yyyy/m/d` and ensures the entered birth date
    /// corresponds to a minimum age of 18 years and a maximum age of 150 years.
    public static var birthday: Self {
        .init(
            id: "birthday",
            autocapitalization: .never,
            spellChecking: .no,
            textContentType: .birthdate,
            validation: .textFieldDate(
                .minimumAge18,
                format: .dateTime
                    .month(.defaultDigits)
                    .day(.defaultDigits)
                    .year(.defaultDigits)
            ),
            formatter: .init()
        )
    }

    /// A text field configuration for entering a date and time value.
    public static var dateTime: Self {
        .init(
            id: "date",
            autocapitalization: .never,
            spellChecking: .no,
            textContentType: .dateTime,
            validation: .none,
            formatter: .init()
        )
    }
}

// MARK: - ValidationRule

extension ValidationRule<String> {
    /// A validation rule that checks whether the input date falls within the
    /// specified range.
    ///
    /// - Parameters:
    ///   - configuration: A `TextFieldConfiguration.Date` instance specifying the
    ///     minimum and maximum allowed dates.
    ///   - strategy: The parsing strategy used to convert the input string into a
    ///     `Date`.
    ///
    /// - Returns: A validation rule that evaluates to `true` if the date is within
    ///   the provided range; otherwise, `false`.
    public static func textFieldDate<T: ParseStrategy & Sendable>(
        _ configuration: TextFieldConfiguration<PassthroughTextFieldFormatter>.Date,
        format strategy: T
    ) -> Self where T.ParseInput == String, T.ParseOutput == Date {
        .init { input in
            guard let date = try? Date(input, strategy: strategy) else {
                return false
            }

            if let minDate = configuration.min, date < minDate {
                return false
            }

            if let maxDate = configuration.max, date > maxDate {
                return false
            }

            return true
        }
    }
}
