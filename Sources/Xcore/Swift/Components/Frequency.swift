//
// Xcore
// Copyright © 2018 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

public struct Frequency: UserInfoContainer, MutableAppliable, CustomAnalyticsValueConvertible {
    public typealias Identifier = Xcore.Identifier<Self>

    /// A unique id for the frequency.
    public let id: Identifier

    /// The title for the frequency.
    public let title: String

    /// The analytics value for the frequency.
    public let analyticsValue: String

    /// The data interval associated with this frequency.
    public var dateInterval: DateInterval

    /// Additional info which may be used to describe the frequency further.
    public var userInfo: UserInfo

    public init(
        id: Identifier = #function,
        title: String,
        analyticsValue: String? = nil,
        dateInterval: DateInterval,
        userInfo: UserInfo = [:]
    ) {
        self.id = id
        self.title = title
        self.analyticsValue = analyticsValue ?? id.rawValue.snakecased()
        self.dateInterval = dateInterval
        self.userInfo = userInfo
    }
}

// MARK: - CustomStringConvertible

extension Frequency: CustomStringConvertible {
    public var description: String {
        title
    }
}

// MARK: - Equatable

extension Frequency: Equatable {
    public static func ==(lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: - Hashable

extension Frequency: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

// MARK: - Built-in

extension Frequency {
    /// A list of frequencies representing all months until today's date.
    public static func thisYearMonthsUntilNow(in calendar: Calendar = .default) -> [Self] {
        let year = Date().component(.year, in: calendar)
        let month = Date().component(.month, in: calendar)

        let firstMonth = Date(year: year, month: 1, day: 1, calendar: calendar)
        let currentMonth = Date(year: year, month: month, day: 1, calendar: calendar)

        return months(from: firstMonth, to: currentMonth, in: calendar)
    }

    private static func months(from startDate: Date, to endDate: Date, in calendar: Calendar = .default) -> [Self] {
        let startYear = startDate.component(.year, in: calendar)
        let endYear = endDate.component(.year, in: calendar)
        var year = "\(startYear)"

        if startYear != endYear {
            year += "-\(endYear)"
        }

        let numberOfMonths = startDate.numberOf(.month, to: endDate, in: calendar)

        var result: [Self] = []

        for i in 0..<numberOfMonths + 1 {
            let interval = startDate.interval(for: .month, adjustedBy: i, in: calendar)
            let monthId = "month_\(i + 1)"

            result.append(Self(
                id: .init(rawValue: "\(year)_\(monthId)"),
                title: interval.start.string(format: .monthName, in: calendar),
                analyticsValue: monthId,
                dateInterval: interval
            ))
        }

        return result
    }
}
