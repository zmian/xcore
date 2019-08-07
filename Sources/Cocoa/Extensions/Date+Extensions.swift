//
// Date+Extensions.swift
//
// Copyright © 2014 Xcore
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

import UIKit

// MARK: Date Extension

extension Date {
    public func fromNow(style: DateComponentsFormatter.UnitsStyle = .abbreviated, format: String = "%@") -> String? {
        let formatter = DateComponentsFormatter().apply {
            $0.unitsStyle = style
            $0.maximumUnitCount = 1
            $0.allowedUnits = [.year, .month, .day, .hour, .minute, .second]
        }

        guard let timeString = formatter.string(from: self, to: Date()) else {
            return nil
        }

        let formatString = NSLocalizedString(format, comment: "Used to say how much time has passed (e.g. '2 hours ago').")
        return String(format: formatString, timeString)
    }

    /// Reset time to beginning of the day (`12 AM`) of `self` without changing the timezone.
    public func stripTime() -> Date {
        let components = Calendar.current.dateComponents([.year, .month, .day], from: self)
        return Calendar.current.date(from: components) ?? self
    }

    // MARK: UTC

    private static let utcDateFormatter = DateFormatter().apply {
        $0.timeZone = .utc
        $0.dateFormat = "yyyy-MM-dd"
    }

    public var utc: Date {
        let dateString = Date.utcDateFormatter.string(from: self)
        Date.utcDateFormatter.timeZone = .current
        let date = Date.utcDateFormatter.date(from: dateString)!
        Date.utcDateFormatter.timeZone = .utc
        return date
    }
}

extension Date {
    /// Epoch in milliseconds.
    ///
    /// Epoch, also known as Unix timestamps, is the number of seconds
    /// (not milliseconds) that have elapsed since January 1, 1970 at 00:00:00 GMT
    /// (1970-01-01 00:00:00 GMT).
    public var unixTimeMilliseconds: Int64 {
        return Int64(timeIntervalSince1970 * 1000)
    }

    public init(
        year: Int,
        month: Int,
        day: Int,
        hour: Int? = nil,
        minute: Int? = nil,
        second: Int? = nil
    ) {
        let dateComponent = DateComponents(
            year: year,
            month: month,
            day: day,
            hour: hour,
            minute: minute,
            second: second
        )

        self = Calendar.current.date(from: dateComponent)!
    }
}

extension TimeZone {
    public static let utc = TimeZone(identifier: "UTC")!
}

extension Locale {
    /// - Note:
    /// **For DateFormatter:**
    ///
    /// In most cases the best locale to choose is `"en_US_POSIX"`, a locale that's
    /// specifically designed to yield US English results regardless of both user
    /// and system preferences. `"en_US_POSIX"` is also invariant in time (if the
    /// US, at some point in the future, changes the way it formats dates, `"en_US"`
    /// will change to reflect the new behaviour, but `"en_US_POSIX"` will not), and
    /// between machines (`"en_US_POSIX"` works the same on iOS as it does on
    /// mac OS, and as it it does on other platforms).
    ///
    /// - SeeAlso: https://developer.apple.com/library/archive/qa/qa1480/_index.html
    public static let us = Locale(identifier: "en_US")

    /// - Note:
    /// **For DateFormatter:**
    ///
    /// In most cases the best locale to choose is `"en_US_POSIX"`, a locale that's
    /// specifically designed to yield US English results regardless of both user
    /// and system preferences. `"en_US_POSIX"` is also invariant in time (if the
    /// US, at some point in the future, changes the way it formats dates, `"en_US"`
    /// will change to reflect the new behaviour, but `"en_US_POSIX"` will not), and
    /// between machines (`"en_US_POSIX"` works the same on iOS as it does on
    /// mac OS, and as it it does on other platforms).
    ///
    /// - SeeAlso: https://developer.apple.com/library/archive/qa/qa1480/_index.html
    public static let usPosix = Locale(identifier: "en_US_POSIX")
}
