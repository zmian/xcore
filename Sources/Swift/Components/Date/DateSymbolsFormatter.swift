//
// Xcore
// Copyright © 2018 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

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
    ///   - style: The lenght of the month name.
    ///   - calendar: The calendar to use when formatting name.
    func monthName(for month: Int, style: Date.Format.SymbolStyle, calendar: Calendar = .default) -> String {
        self.calendar = calendar

        let symbols: [String]

        switch style {
            case .full:
                symbols = formatter.monthSymbols
            case .short:
                symbols = formatter.shortMonthSymbols
            case .veryShort:
                symbols = formatter.veryShortMonthSymbols
        }

        return symbols[month - 1]
    }

    /// Calculates the weekday name in the calendar.
    ///
    /// - Parameters:
    ///   - weekday: The weekday number.
    ///   - style: The lenght of the weekday name.
    ///   - calendar: The calendar to use when formatting name.
    func weekdayName(for weekday: Int, style: Date.Format.SymbolStyle, calendar: Calendar = .default) -> String {
        self.calendar = calendar

        let symbols: [String]

        switch style {
            case .full:
                symbols = formatter.weekdaySymbols
            case .short:
                symbols = formatter.shortWeekdaySymbols
            case .veryShort:
                symbols = formatter.veryShortWeekdaySymbols
        }

        return symbols[weekday - 1]
    }
}
