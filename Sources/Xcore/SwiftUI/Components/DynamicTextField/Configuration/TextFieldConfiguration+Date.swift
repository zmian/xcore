//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

extension TextFieldConfiguration {
    public struct Date {
        public let minimum: Foundation.Date?
        public let maximum: Foundation.Date?
        public let selection: Foundation.Date

        public init(
            minimum: Foundation.Date?,
            maximum: Foundation.Date?,
            selection: Foundation.Date = .init(year: 2000, month: 1, day: 1)
        ) {
            self.minimum = minimum
            self.maximum = maximum
            self.selection = selection
        }
    }
}

// MARK: - Built-in

extension TextFieldConfiguration.Date {
    public static var pastDate: Self {
        .init(
            minimum: nil,
            maximum: Date(),
            selection: Date()
        )
    }

    public static var futureDate: Self {
        .init(
            minimum: Date(),
            maximum: nil,
            selection: Date()
        )
    }

    public static var minimumAge18: Self {
        .init(
            minimum: Calendar.current.date(byAdding: .year, value: -150, to: Date()),
            maximum: Calendar.current.date(byAdding: .year, value: -18, to: Date())
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
            minimum: Date(),
            maximum: Calendar.current.date(byAdding: component, value: value, to: Date()),
            selection: Date()
        )
    }
}

// MARK: - Date

extension TextFieldConfiguration where Formatter == PassthroughTextFieldFormatter {
    /// Date of Birth
    public static var birthday: Self {
        date(.minimumAge18).applying {
            $0.id = "birthday"
        }
    }

    public static func date(_ configuration: Date) -> Self {
        var textContentType: UITextContentType? {
            if #available(iOS 15.0, *) {
                return .dateTime
            }

            return nil
        }

        return .init(
            id: "date",
            autocapitalization: .none,
            autocorrection: .no,
            spellChecking: .no,
            keyboard: .default,
            textContentType: textContentType,
            validation: .none,
            formatter: Formatter()
        )
    }
}
