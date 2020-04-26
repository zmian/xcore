//
// Xcore
// Copyright © 2014 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

extension Date {
    /// Epoch in milliseconds.
    ///
    /// Epoch, also known as Unix timestamps, is the number of seconds (not
    /// milliseconds) that have elapsed since `January 1, 1970` at `00:00:00 GMT`
    /// (`1970-01-01 00:00:00 GMT`).
    public var unixTimeMilliseconds: Int64 {
        Int64(timeIntervalSince1970 * 1000)
    }
}

extension Date {
    public func fromNow(
        style: DateComponentsFormatter.UnitsStyle = .abbreviated,
        format: String = "%@",
        in calendar: Calendar = .default
    ) -> String? {
        let formatter = DateComponentsFormatter().apply {
            $0.unitsStyle = style
            $0.maximumUnitCount = 1
            $0.allowedUnits = [.year, .month, .day, .hour, .minute, .second]
            $0.calendar = calendar
        }

        guard let timeString = formatter.string(from: self, to: Date()) else {
            return nil
        }

        let formatString = NSLocalizedString(format, comment: "Used to say how much time has passed (e.g., '2 hours ago').")
        return String(format: formatString, timeString)
    }

    /// Reset time to beginning of the day (`12 AM`) of `self`.
    ///
    /// - Parameter calendar: The calendar to use for the date.
    public func stripTime(calendar: Calendar = .default) -> Date {
        let components = calendar.dateComponents([.year, .month, .day], from: self)
        return calendar.date(from: components) ?? self
    }
}
