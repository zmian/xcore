//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

extension TextFieldConfiguration {
    public struct Date: Sendable, Hashable {
        public let min: Foundation.Date?
        public let max: Foundation.Date?
        public let selection: Foundation.Date

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
    public static var pastDate: Self {
        .init(
            min: nil,
            max: .now,
            selection: .now
        )
    }

    public static var futureDate: Self {
        .init(
            min: .now,
            max: nil,
            selection: .now
        )
    }

    public static var minimumAge18: Self {
        .init(
            min: Calendar.current.date(byAdding: .year, value: -150, to: .now),
            max: Calendar.current.date(byAdding: .year, value: -18, to: .now)
        )
    }

    public static var aYearFromToday: Self {
        now(toYear: 1)
    }

    public static func now(toYear year: Int) -> Self {
        now(byAdding: .year, value: year)
    }

    public static func now(toMonth month: Int) -> Self {
        now(byAdding: .month, value: month)
    }

    /// Returns a new Date representing the date calculated by adding an amount of
    /// a specific component to today.
    ///
    /// - Parameters:
    ///   - component: A single component to add.
    ///   - value: The value of the specified component to add.
    /// - Returns: A new date.
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
    /// Date of Birth
    public static var birthday: Self {
        date(.minimumAge18).applying {
            $0.id = "birthday"
        }
    }

    public static func date(_ configuration: Date) -> Self {
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
