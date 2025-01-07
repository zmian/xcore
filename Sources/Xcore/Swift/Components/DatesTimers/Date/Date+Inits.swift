//
// Xcore
// Copyright © 2018 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

extension Date {
    /// Creates a `Date` object using the given date components.
    ///
    /// - Parameters:
    ///   - year: The year to set on the Date.
    ///   - month: The month to set on the Date.
    ///   - day: The day to set on the Date.
    ///   - hour: The hour to set on the Date.
    ///   - minute: The minute to set on the Date.
    ///   - second: The second to set on the Date.
    ///   - calendar: The calendar to set on the Date.
    public init(
        year: Int,
        month: Int,
        day: Int,
        hour: Int? = nil,
        minute: Int? = nil,
        second: Int? = nil,
        calendar: Calendar = .default
    ) {
        let dateComponent = DateComponents(
            calendar: calendar,
            timeZone: calendar.timeZone,
            year: year,
            month: month,
            day: day,
            hour: hour,
            minute: minute,
            second: second
        )

        self = dateComponent.date!
    }
}
