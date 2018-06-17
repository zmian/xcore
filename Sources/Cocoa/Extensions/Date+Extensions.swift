//
// Date+Extensions.swift
//
// Copyright © 2014 Zeeshan Mian
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
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = style
        formatter.maximumUnitCount = 1
        formatter.allowedUnits = [.year, .month, .day, .hour, .minute, .second]

        guard let timeString = formatter.string(from: self, to: Date()) else {
            return nil
        }

        let formatString = NSLocalizedString(format, comment: "Used to say how much time has passed (e.g. '2 hours ago').")
        return String(format: formatString, timeString)
    }

    /// Reset time to beginning of the day (`12 AM`) of `self` without changing the timezone.
    public func stripTime() -> Date {
        let calendar = Calendar.current
        let components = (calendar as NSCalendar).components([.year, .month, .day], from: self)
        return calendar.date(from: components) ?? self
    }

    // MARK: UTC

    private static let utcDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = .utc
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter
    }()

    public var utc: Date {
        let dateString = Date.utcDateFormatter.string(from: self)
        Date.utcDateFormatter.timeZone = .current
        let date = Date.utcDateFormatter.date(from: dateString)!
        Date.utcDateFormatter.timeZone = .utc
        return date
    }
}

extension TimeZone {
    public static let utc = TimeZone(identifier: "UTC")!
}

extension Locale {
    public static let usa = Locale(identifier: "en_US")
}
