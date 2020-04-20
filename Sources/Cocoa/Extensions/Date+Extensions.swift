//
// Xcore
// Copyright © 2014 Xcore
// MIT license, see LICENSE file for details
//

import Foundation
import PromiseKit

// MARK: - Configuration
extension Date {
    public typealias Range = (start: Date, end: Date)

    public private(set) static var configuration: Configuration = .init()

    public static func configure(configuration: Configuration) {
        Self.configuration = configuration
        NotificationCenter.on.applicationDidBecomeActive {
            Self.syncServerDate()
        }
    }

    public static var defaultRegion: Region {
        configuration.region
    }

    public static var defaultCalendar: Calendar {
        defaultRegion.calendar
    }

    public static var defaultTimeZone: TimeZone {
        defaultRegion.timeZone
    }

    public static var defaultLocale: Locale {
        defaultRegion.locale
    }
}

extension Date {
    public struct Configuration {
        public let region: Region
        public let serverDateProvider: Promise<Date>
        public let serverDateExpirationTime: TimeInterval

        public init(
            region: Region = .ISO,
            serverDateProvider: Promise<Date> = .value(Date()),
            serverDateExpirationTime: TimeInterval = 3600
        ) {
            self.region = region
            self.serverDateProvider = serverDateProvider
            self.serverDateExpirationTime = serverDateExpirationTime
        }
    }
}

// MARK: - Server Date

extension Date {
    public static var serverDate: Date {
        storedServerDate ?? Date()
    }

    private static var storedServerDate: Date?
    private static var lastServerDateTimestamp: CFAbsoluteTime?

    public static var isServerDateExpired: Bool {
        guard let lastServerDateTimestamp = lastServerDateTimestamp else { return true }
        let distance = lastServerDateTimestamp.distance(to: CFAbsoluteTimeGetCurrent())
        return distance < 0 || distance > configuration.serverDateExpirationTime
    }

    @discardableResult
    public static func syncServerDate(force: Bool = false) -> Promise<Date> {
        let avoidCache = force || isServerDateExpired
        guard avoidCache else {
            return .value(serverDate)
        }

        return .init { seal in
            firstly {
                configuration.serverDateProvider
            }.done { date in
                storedServerDate = date
                lastServerDateTimestamp = CFAbsoluteTimeGetCurrent()
                seal.fulfill(date)
            }.catch { error in
                seal.reject(error)
            }
        }
    }
}

// MARK: - Region

extension Date {
    public struct Region {
        public var calendar: Calendar = .current
        public let locale: Locale
        public let timeZone: TimeZone

        public init(calendar identifier: Calendar.Identifier? = nil, locale: Locale, timeZone: TimeZone) {
            self.locale = locale
            self.timeZone = timeZone
            if let identifier = identifier {
                calendar = .init(identifier: identifier)
            }
            calendar.timeZone = timeZone
            calendar.locale = locale
        }
    }
}

extension Date.Region {
    public static var ISO: Self {
        .init(calendar: .gregorian, locale: .usPosix, timeZone: .utc)
    }

    public static var gregorianUtc: Self {
        .init(calendar: .gregorian, locale: .current, timeZone: .utc)
    }

    public static var current: Self {
        .init(calendar: .gregorian, locale: .current, timeZone: .current)
    }

    public static var usEastern: Self {
        .init(calendar: .gregorian, locale: .current, timeZone: .eastern)
    }
}

extension TimeZone {
    public static let eastern = TimeZone(identifier: "US/Eastern")!
    public static let utc = TimeZone(identifier: "UTC")!
}

// MARK: Formats

extension Date {
    /// Format represents a date/time style that can be applied to `Dateformatter`
    public enum Format {
        case custom(_: CustomFormat)
        case date(_: DateFormatter.Style)
        case time(_: DateFormatter.Style)
        case dateTime(_: DateFormatter.Style)
    }

    /// Custom format to pass in `Format`
    public struct CustomFormat: RawRepresentable, Equatable {
        public private(set) var rawValue: String
        public init(rawValue: String) {
            self.rawValue = rawValue
        }
    }
}
extension Date.CustomFormat {
    /// yyyy-MM-dd'T'HH:mm:ss.SSSZ
    public static let iso8601: Self = .init(rawValue: "yyyy-MM-dd'T'HH:mm:ss.SSSZ")
    /// yyyy-MM-dd'T'HH:mm:ss
    public static let iso8601Local: Self = .init(rawValue: "yyyy-MM-dd'T'HH:mm:ss")
    /// yyyy-MM-dd
    public static let yearMonthDayDash: Self = .init(rawValue: "yyyy-MM-dd")
    /// yyyy-MM
    public static let yearMonthDash: Self = .init(rawValue: "yyyy-MM")
    /// M/dd
    public static let monthDaySlash: Self = .init(rawValue: "M/dd")
    /// yyyy
    public static let year: Self = .init(rawValue: "yyyy")
    /// yyyy MM dd
    public static let yearMonthDaySpace: Self = .init(rawValue: "yyyy MM dd")
    /// LLL dd
    public static let monthDayShortSpace: Self = .init(rawValue: "LLL dd")
    /// MMMM d, yyyy
    public static let monthDayYearFull: Self = .init(rawValue: "MMMM d, yyyy")
    /// MMMM d
    public static let monthDaySpace: Self = .init(rawValue: "MMMM d")
    /// Used for ordinal days like `June 4th`
    public static let monthDayOrdinal: Self = .init(rawValue: #function)
    /// Used for ordinal days with short months like `Jun. 4th`
    public static let monthShortPeriodDayOrdinal: Self = .init(rawValue: #function)
    /// MMM d
    public static let monthDayAbbreviated: Self = .init(rawValue: "MMM d")
    /// MMMM yyyy
    public static let monthYearFull: Self = .init(rawValue: "MMMM yyyy")
    /// MM/dd/yyyy - h:mma
    public static let monthDayYearSlashTime: Self = .init(rawValue: "MM/dd/yyyy - h:mma")
    /// yyyyMM
    public static let yearMonthHash: Self = .init(rawValue: "yyyyMM")
}

// MARK: - Helpers

extension Date {
    /// Convenient initializer to cretate a `Date` object
    /// - Parameters:
    ///   - year: Year to set on the Date
    ///   - month: Month to set on the Date
    ///   - day: Date to set on the Date
    ///   - hour: Hour to set on the Date
    ///   - minute: Minute to set on the Date
    ///   - second: Second to set on the Date
    ///   - region: Region to set on the Date. It defaults to Date's configuration region.
    public init(
        year: Int,
        month: Int,
        day: Int,
        hour: Int? = nil,
        minute: Int? = nil,
        second: Int? = nil,
        region: Region = defaultRegion
    ) {
        let dateComponent = DateComponents(
            calendar: region.calendar,
            timeZone: region.timeZone,
            year: year,
            month: month,
            day: day,
            hour: hour,
            minute: minute,
            second: second
        )

        self = region.calendar.date(from: dateComponent)!
    }

    /// Initializes a Date object from a given date string and format.
    /// - Parameters:
    ///   - string: String that represents a date.
    ///   - format: Format of the date that's represented with string.
    ///   - region: Region to use when parsing the date.
    ///   - isLenient: Boolean flag to indicate to use heuristics when parsing the date.
    public init?(
        from string: String,
        format: CustomFormat,
        region: Region = defaultRegion,
        isLenient: Bool = true
    ) {
        guard !string.isEmpty else {
            return nil
        }

        let formatter = Self.cachedDateFormatters.cachedFormatter(
            format: format.rawValue,
            region: region,
            isLenient: isLenient
        )
        guard let date = formatter.date(from: string) else {
            return nil
        }

        self = date
    }

    /// Converts a date object to string based on `Region`
    /// - Parameters:
    ///   - format: Format to use when parsing the date
    ///   - doesRelativeDateFormatting: Boolean flag to indicate if parsing should happen in relative format.
    ///   The relativeFormatting only works with Date and Time styles but not with custom formats
    ///   - region: Region to use when parsing the date
    public func toString(format: Format, doesRelativeDateFormatting: Bool = false, region: Region = defaultRegion) -> String {
        let formatter: DateFormatter
        switch format {
            case .custom(let customFormat):
                if customFormat == .monthDayOrdinal {
                    return "\(monthName()) \(Date.numberFormatter.string(from: NSNumber(value: get(component: .day))) ?? "")"
                }

                if customFormat == .monthShortPeriodDayOrdinal {
                    let longMonthName = monthName()
                    let shortMonthName = monthName(isShort: true)
                    let separator = longMonthName == shortMonthName ? "" : "."
                    return "\(shortMonthName)\(separator) \(get(component: .day))"
                }

                formatter = Self.cachedDateFormatters.cachedFormatter(
                    format: customFormat.rawValue,
                    doesRelativeDateFormatting: doesRelativeDateFormatting,
                    region: region
            )
            case .date(let dateStyle):
                formatter = Self.cachedDateFormatters.cachedFormatter(
                    dateStyle: dateStyle,
                    doesRelativeDateFormatting: doesRelativeDateFormatting,
                    region: region
            )

            case .time(let timeStyle):
                formatter = Self.cachedDateFormatters.cachedFormatter(
                    timeStyle: timeStyle,
                    doesRelativeDateFormatting: doesRelativeDateFormatting,
                    region: region
            )
            case .dateTime(let style):
                formatter = Self.cachedDateFormatters.cachedFormatter(
                    dateStyle: style,
                    timeStyle: style,
                    doesRelativeDateFormatting: doesRelativeDateFormatting,
                    region: region
            )
        }

        return formatter.string(from: self)
    }

    /// Adjusts the receiver's given component and along with all smaller units to their start using the region.
    /// - Parameters:
    ///   - component: Component and along with all smaller units to adjust to their start
    ///   - region: Region to use for adjustment. Defaults to Date's configuration region.
    public func dateAtStartOf(component: Calendar.Component, region: Region = defaultRegion) -> Date {
        var start: NSDate?
        var interval: TimeInterval = 0
        guard
            (region.calendar as NSCalendar).range(of: component.nsCalendarUnit, start: &start, interval: &interval, for: self),
            let startDate = start
            else {
                return self
        }
        return startDate as Date
    }

    /// Adjusts the receiver's given component and along with all smaller units to their end using the region.
    /// - Parameters:
    ///   - component: Component and along with all smaller units to adjust to their end
    ///   - region: Region to use for adjustment. Defaults to Date's configuration region
    public func dateAtEndOf(component: Calendar.Component, region: Region = defaultRegion) -> Date {
        var start: NSDate?
        var interval: TimeInterval = 0
        guard
            (region.calendar as NSCalendar).range(of: component.nsCalendarUnit, start: &start, interval: &interval, for: self),
            let startDate = start
            else {
                return self
        }

        let startOfNextComponent = startDate.addingTimeInterval(interval)
        return Date(timeInterval: -0.001, since: startOfNextComponent as Date)
    }

    /// Adjusts the receiver's given component by the given offset in set region
    /// - Parameters:
    ///   - component: Component to adjust
    ///   - offset: Offset to use for adjustment
    ///   - region: Region to use for adjustment. Defaults to Date's configuration region
    public func adjusting(_ component: Calendar.Component, by offset: Int, in region: Region = defaultRegion) -> Date {
        var dateComponent = DateComponents()
        switch component {
            case .nanosecond:
                dateComponent.nanosecond = offset
            case .second:
                dateComponent.second = offset
            case .minute:
                dateComponent.minute = offset
            case .hour:
                dateComponent.hour = offset
            case .day:
                dateComponent.day = offset
            case .weekday:
                dateComponent.weekday = offset
            case .weekdayOrdinal:
                dateComponent.weekdayOrdinal = offset
            case .weekOfYear:
                dateComponent.weekOfYear = offset
            case .month:
                dateComponent.month = offset
            case .year:
                dateComponent.year = offset
            case .era:
                dateComponent.era = offset
            case .quarter:
                dateComponent.quarter = offset
            case .weekOfMonth:
                dateComponent.weekOfMonth = offset
            case .yearForWeekOfYear:
                dateComponent.yearForWeekOfYear = offset
            case .calendar, .timeZone:
                fatalError("Unsupported type \(component)")
            @unknown default:
                fatalError("Unsupported type \(component)")
        }
        return adjusting(components: dateComponent, region: region)
    }

    /// Adjusts the receiver by given date components
    /// - Parameters:
    ///   - components: DateComponents object that contains adjustment values
    ///   - region: Region to use for adjustment. Defaults to Date's configuration region
    public func adjusting(components: DateComponents, region: Region = defaultRegion) -> Date  {
        region.calendar.date(byAdding: components, to: self)!
    }

    /// Retrieves the receiver's given component value.
    /// - Parameters:
    ///   - component: Component to get the value for.
    ///   - region: Region to use for retrieval. Defaults to Date's configuration region
    ///
    /// **Example**
    ///
    /// ```
    /// // Example in default region
    /// let date = Date(year: 2020, month: 2, day: 1, hour: 3, minute: 41, second: 22)
    /// let year = date.get(component: .year)
    /// let month = date.get(component: .month)
    /// let day = date.get(component: .day)
    /// // The value year would print 2020, month 2, and day 1
    ///
    ///// Example in different region
    /// let date = Date(year: 2020, month: 2, day: 1, hour: 3, minute: 41, second: 22)
    /// let year = date.get(component: .year, in: .usEastern)
    /// let month = date.get(component: .month, in: .usEastern)
    /// let day = date.get(component: .day, in: .usEastern)
    /// let hour = date.get(component: .hout, in: .usEastern)
    /// // The value year would print 2020, month 1, day 31 and hour 22
    ///
    public func get(component: Calendar.Component, in region: Region = defaultRegion) -> Int {
        region.calendar.component(component, from: self)
    }

    /// Compares whether the receiver is before, after or equal to `date` based on their components down to a given unit granularity
    /// - Parameters:
    ///   - date: Reference date
    ///   - granularity: Smallest unit that must, along with all larger units, be less for the given dates
    ///   - region: The region to use when comparing. Defaults to Date's default region
    public func compare(to date: Date, granularity: Calendar.Component, region: Region = defaultRegion) -> ComparisonResult {
        region.calendar.compare(self, to: date, toGranularity: granularity)
    }

    /// Compares whether the receiver is before/before equal `date` based on their components down to a given unit granularity.
    ///
    /// - Parameters:
    ///   - date: Reference date
    ///   - orEqual: `true` to also check for equality
    ///   - granularity: Smallest unit that must, along with all larger units, be less for the given dates
    ///   - region: The region to use when comparing. Defaults to Date's default region
    public func isBefore(date: Date, orEqual: Bool = false, granularity: Calendar.Component, region: Region = defaultRegion) -> Bool {
        let result = compare(to: date, granularity: granularity, region: region)
        return (orEqual ? (result == .orderedSame || result == .orderedAscending) : result == .orderedAscending)
    }

    /// Compares whether the receiver is after `date` based on their components down to a given unit granularity.
    ///
    /// - Parameters:
    ///   - date: reference date
    ///   - orEqual: `true` to also check for equality
    ///   - granularity: Smallest unit that must, along with all larger units, be greater for the given dates.
    ///   - region: The region to use when comparing. Defaults to Date's default region
    public func isAfter(date: Date, orEqual: Bool = false, granularity: Calendar.Component, region: Region = defaultRegion) -> Bool {
        let result = compare(to: date, granularity: granularity, region: region)
        return (orEqual ? (result == .orderedSame || result == .orderedDescending) : result == .orderedDescending)
    }

    /// Return true if receiver date is contained in the range specified by two dates.
    ///
    /// - Parameters:
    ///   - startDate: Range upper bound date
    ///   - endDate: Range lower bound date
    ///   - orEqual: `true` to also check for equality on date and date2
    ///   - granularity: Smallest unit that must, along with all larger units, be greater for the given dates.
    ///   - region: The region to use when comparing. Defaults to Date's default region
    public func isInBetween(
        date startDate: Date,
        and endDate: Date,
        orEqual: Bool = false,
        granularity: Calendar.Component = .nanosecond,
        region: Region = defaultRegion
    ) -> Bool {
        isAfter(date: startDate, orEqual: orEqual, granularity: granularity, region: region) &&
            isBefore(date: endDate, orEqual: orEqual, granularity: granularity, region: region)
    }

    /// Compares equality of two given dates based on their components down to a given unit
    /// granularity.
    ///
    /// - Parameters:
    ///   - date: date to compare
    ///   - granularity: The smallest unit that must, along with all larger units, be equal for the given
    ///   dates to be considered the same.
    ///   - region: The region to use when comparing. Defaults to Date's default region
    ///
    /// - returns: `true` if the dates are the same down to the given granularity, otherwise `false`
    public func isSame(date: Date, granularity: Calendar.Component, region: Region = defaultRegion) -> Bool {
        compare(to: date, granularity: granularity, region: region) == .orderedSame
    }

    /// Calculates the month name on the receiver date based on region
    /// - Parameters:
    ///   - isShort: Boolean to indicate if the name should be shortened
    ///   - region: The region to use when generating name. Defaults to Date's default region
    public func monthName(isShort: Bool = false, region: Region = defaultRegion) -> String {
        let symbols = isShort ?
            Self.cachedDateFormatters.cachedFormatter(dateStyle: .full, region: region).shortMonthSymbols :
            Self.cachedDateFormatters.cachedFormatter(dateStyle: .full, region: region).monthSymbols

        return symbols?.at(get(component: .month) - 1) ?? ""
    }

    /// Calculates the week day name on the receiver date based on region.
    /// - Parameters:
    ///   - isShort: Boolean to indicate if the name should be shortened.
    ///   - region: The region to use when generating name. Defaults to Date's default region.
    public func weekdayName(isShort: Bool = false, region: Region = defaultRegion) -> String {
        let symbols = isShort ?
            Self.cachedDateFormatters.cachedFormatter(dateStyle: .full, region: region).shortWeekdaySymbols :
            Self.cachedDateFormatters.cachedFormatter(dateStyle: .full, region: region).weekdaySymbols

        return symbols?.at(get(component: .weekday) - 1) ?? ""
    }

    /// Calculates the week day name for given index based on region and locale.
    /// - Parameters:
    ///   - weekDay: The day's index in a week
    ///   - isShort: Boolean to indicate if the name should be shortened.
    ///   - region: The region to use when generating name. Defaults to Date's default region
    public static func weekdayName(for weekDay: Int, isShort: Bool = false, region: Region = defaultRegion) -> String {
        let symbols = isShort ?
            Self.cachedDateFormatters.cachedFormatter(region: region).shortWeekdaySymbols :
            Self.cachedDateFormatters.cachedFormatter(region: region).weekdaySymbols

        return symbols?.at(weekDay) ?? ""
    }

    /// Returns the total number units until the provided date
    /// - Parameters:
    ///   - component: Component to calculate
    ///   - date: Component to calculate until date
    ///   - region: Region to calculate the number. Defaults to Date's configuration's region
    /// - Note:
    /// **Example**
    ///
    /// ```
    /// let date = Date(year: 2019, month: 3, day: 4, hour: 2, minute: 22, second: 44)
    /// let untilDate = Date(year: 2020, month: 4, day: 5, hour: 1, minute: 45, second: 55)
    /// let result = date.numberOf(.year, until: untilDate)
    ///```
    /// In the above example. The result would be 1 becaue there is only 1 year between 2019 and 2020
    ///
    public func numberOf(_ component: Calendar.Component, until date: Date, region: Region = defaultRegion) -> Int {
        let currentCalendar = region.calendar
        guard let start = currentCalendar.ordinality(of: component, in: .era, for: self) else { return 0 }
        guard let end = currentCalendar.ordinality(of: component, in: .era, for: date) else { return 0 }
        return end - start
    }

    /// Total number of days of month using the Date's default configuration
    public var totalDaysInCurrentMonth: Int {
        Date.defaultCalendar.range(of: .day, in: .month, for: self)!.count
    }

    /// Returns the timezone offset of a region from GMT.
    /// - Parameter region: Region to calculate timezone, defaults to Date's configuration region
    ///
    /// **Example**
    /// `let result = Date.timeZoneOffset(region: .usEastern)`
    /// The above result would be -4 as Eastern timeZone is 4 hours behind GMT.
    public static func timeZoneOffset(region: Region = defaultRegion) -> Int {
        region.timeZone.secondsFromGMT() / 3600
    }
}

extension Date {
    /// Creates a date range from given date by adjusting its components
    /// - Parameters:
    ///   - component: Component to adjust for the range
    ///   - adjustment: The offset to adjust the component
    ///   - referenceDate: Date to adjust from. Default is `Date()`
    ///   - region: Region to use for adjustment. Defaults to Date's configuration region
    public static func range(
        for component: Calendar.Component,
        adjustedBy adjustment: Int = 0,
        referenceDate: Date = Date(),
        region: Region = defaultRegion
    ) -> Date.Range {
        let date = referenceDate.dateAtStartOf(component: component)
        let startDate = date.adjusting(component, by: adjustment)
        let endDate = date.dateAtEndOf(component: component)
        return (startDate, endDate)
    }
}

// MARK: Internal use

extension Date {
    fileprivate static let numberFormatter = NumberFormatter().apply {
        $0.numberStyle = .ordinal
    }

    fileprivate static var cachedDateFormatters = FormatterCache()
}

fileprivate class FormatterCache {
    private static let cachedDateFormattersQueue = DispatchQueue(
        label: #function,
        attributes: .concurrent
    )

    private static var cachedDateFormatters = [String: DateFormatter]()

    private func register(formatter: DateFormatter, with key: String) {
        Self.cachedDateFormattersQueue.async(flags: .barrier) {
            Self.cachedDateFormatters.updateValue(formatter, forKey: key)
        }
    }

    private func get(key: String) -> DateFormatter? {
        let dateFormatter = Self.cachedDateFormattersQueue.sync { () -> DateFormatter? in
            guard let result = Self.cachedDateFormatters[key] else { return nil }
            return result
        }
        return dateFormatter
    }

    fileprivate func cachedFormatter(
        format: String,
        doesRelativeDateFormatting: Bool = false,
        region: Date.Region = Date.configuration.region,
        isLenient: Bool = true
    ) -> DateFormatter {
        let key = """
            \(format)
            \(doesRelativeDateFormatting.hashValue)
            \(region.calendar.hashValue)
            \(region.timeZone.hashValue)
            \(region.locale.hashValue)
            \(isLenient.hashValue)
            """.sha256() ?? ""

        guard let formatter = Date.cachedDateFormatters.get(key: key) else {
            let formatter = DateFormatter()
            formatter.dateFormat = format
            formatter.calendar = region.calendar
            formatter.timeZone = region.timeZone
            formatter.locale = region.locale
            formatter.isLenient = isLenient
            formatter.doesRelativeDateFormatting = doesRelativeDateFormatting
            Date.cachedDateFormatters.register(formatter: formatter, with: key)
            return formatter
        }

        return formatter
    }

    fileprivate func cachedFormatter(
        dateStyle: DateFormatter.Style = .none,
        timeStyle: DateFormatter.Style = .none,
        doesRelativeDateFormatting: Bool = false,
        region: Date.Region,
        isLenient: Bool = true
    ) -> DateFormatter {
        let key = """
            \(dateStyle.hashValue)
            \(timeStyle.hashValue)
            \(doesRelativeDateFormatting.hashValue)
            \(region.calendar.identifier)
            \(region.timeZone.identifier)
            \(region.locale.identifier)
            \(isLenient.hashValue)
            """.sha256() ?? ""

        guard let formatter = Date.cachedDateFormatters.get(key: key) else {
            let formatter = DateFormatter()
            formatter.dateStyle = dateStyle
            formatter.timeStyle = timeStyle
            formatter.doesRelativeDateFormatting = doesRelativeDateFormatting
            formatter.calendar = region.calendar
            formatter.timeZone = region.timeZone
            formatter.locale = region.locale
            formatter.isLenient = isLenient
            Date.cachedDateFormatters.register(formatter: formatter, with: key)
            return formatter
        }

        return formatter
    }
}

extension Calendar.Component {
    fileprivate var nsCalendarUnit: NSCalendar.Unit {
        switch self {
            case .era:
                return NSCalendar.Unit.era
            case .year:
                return NSCalendar.Unit.year
            case .month:
                return NSCalendar.Unit.month
            case .day:
                return NSCalendar.Unit.day
            case .hour:
                return NSCalendar.Unit.hour
            case .minute:
                return NSCalendar.Unit.minute
            case .second:
                return NSCalendar.Unit.second
            case .weekday:
                return NSCalendar.Unit.weekday
            case .weekdayOrdinal:
                return NSCalendar.Unit.weekdayOrdinal
            case .quarter:
                return NSCalendar.Unit.quarter
            case .weekOfMonth:
                return NSCalendar.Unit.weekOfMonth
            case .weekOfYear:
                return NSCalendar.Unit.weekOfYear
            case .yearForWeekOfYear:
                return NSCalendar.Unit.yearForWeekOfYear
            case .nanosecond:
                return NSCalendar.Unit.nanosecond
            case .calendar:
                return NSCalendar.Unit.calendar
            case .timeZone:
                return NSCalendar.Unit.timeZone
            @unknown default:
                fatalError("Unsupported type \(self)")
        }
    }
}

// MARK: Date Extension

extension Date {
    public func fromNow(style: DateComponentsFormatter.UnitsStyle = .abbreviated, format: String = "%@", region: Region = defaultRegion) -> String? {
        let formatter = DateComponentsFormatter().apply {
            $0.unitsStyle = style
            $0.maximumUnitCount = 1
            $0.allowedUnits = [.year, .month, .day, .hour, .minute, .second]
            $0.calendar = region.calendar
        }

        guard let timeString = formatter.string(from: self, to: Date()) else {
            return nil
        }

        let formatString = NSLocalizedString(format, comment: "Used to say how much time has passed (e.g. '2 hours ago').")
        return String(format: formatString, timeString)
    }

    /// Reset time to beginning of the day (`12 AM`) of `self`.
    /// - Parameter region: Region to use for the date. Defaults to Date's configuration region
    public func stripTime(region: Region = defaultRegion) -> Date {
        let components = region.calendar.dateComponents([.year, .month, .day], from: self)
        return region.calendar.date(from: components) ?? self
    }
}

extension Date {
    /// Epoch in milliseconds.
    ///
    /// Epoch, also known as Unix timestamps, is the number of seconds
    /// (not milliseconds) that have elapsed since January 1, 1970 at 00:00:00 GMT
    /// (1970-01-01 00:00:00 GMT).
    public var unixTimeMilliseconds: Int64 {
        Int64(timeIntervalSince1970 * 1000)
    }
}

// MARK: - Date Picker

extension Configuration where Type: UIDatePicker {
    public static func `default`(minimumDate: Date?) -> Self {
        .init(id: "default") { picker in
            picker.minimumDate = minimumDate ?? Date.serverDate
            picker.timeZone = Date.defaultTimeZone
            picker.calendar = Date.defaultCalendar
        }
    }
}
