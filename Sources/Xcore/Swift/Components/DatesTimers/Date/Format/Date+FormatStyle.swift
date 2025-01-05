//
// Xcore
// Copyright © 2022 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

extension FormatStyle where Self == Date.RelativeFormatStyle {
    /// Returns a relative date format style based on the named presentation and
    /// wide unit style.
    public static var relative: Self {
        .relative(presentation: .named)
    }
}

extension Date.RelativeFormatStyle {
    /// The capitalization context to use when formatting the relative dates.
    ///
    /// Setting the capitalization context to `beginningOfSentence` sets the first
    /// word of the relative date string to upper-case. A capitalization context set
    /// to `middleOfSentence` keeps all words in the string lower-cased.
    public func capitalizationContext(_ context: FormatStyleCapitalizationContext) -> Self {
        applying {
            $0.capitalizationContext = context
        }
    }

    public func calendar(_ calendar: Calendar) -> Self {
        applying {
            $0.calendar = calendar
        }
    }

    private func applying(_ configure: (inout Self) throws -> Void) rethrows -> Self {
        var copy = self
        try configure(&copy)
        return copy
    }
}

// MARK: - Helpers

extension Date.FormatStyle {
    func setCalendar(_ newCalendar: Calendar) -> Self {
        var copy = self
        copy.calendar = newCalendar
        copy.timeZone = newCalendar.timeZone
        newCalendar.locale.map {
            copy.locale = $0
        }
        return copy
    }
}

extension Date.ISO8601FormatStyle {
    /// Configures the ISO 8601 date format style to include the date components
    /// (year, month, and day) in the formatted output.
    ///
    /// **Usage**
    ///
    /// ```swift
    /// let date = Date()
    /// let formattedDate = date.formatted(.iso8601.date())
    /// print(formattedDate) // Output: "2025-01-04"
    /// ```
    ///
    /// - Returns: An ISO 8601 date format style modified to include the date.
    public func date() -> Self {
        year().month().day()
    }

    /// Configures the ISO 8601 date format style with a specific time zone.
    ///
    /// This method allows you to explicitly set the time zone for date formatting
    /// and parsing. This ensures consistent date and time representation across
    /// different locales and environments.
    ///
    /// **Usage**
    ///
    /// ```swift
    /// let date = Date()
    /// let formattedDate = date.formatted(.iso8601.timeZone(.utc))
    /// print(formattedDate) // Output: "2025-01-04T00:00:00Z"
    /// ```
    ///
    /// - Parameter timeZone: The time zone to use for formatting and parsing
    ///   the date.
    /// - Returns: A modified ISO 8601 format style with the specified time zone.
    public func timeZone(_ timeZone: TimeZone) -> Self {
        var copy = self
        copy.timeZone = timeZone
        return copy
    }
}
