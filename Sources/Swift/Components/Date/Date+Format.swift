//
// Xcore
// Copyright © 2014 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

extension Date {
    /// Format represents a date/time style that can be applied to `DateFormatter`.
    public enum Format {
        case date(DateFormatter.Style)
        case time(DateFormatter.Style)
        case dateTime(DateFormatter.Style)
        case iso8601(ISO8601DateFormatter.Options)
        case custom(Custom)
    }
}

// MARK: - Format.Custom

extension Date.Format {
    public struct Custom: RawRepresentable, Equatable {
        public let rawValue: String

        public init(rawValue: String) {
            self.rawValue = rawValue
        }
    }
}

extension Date.Format.Custom: ExpressibleByStringLiteral {
    public init(stringLiteral value: StringLiteralType) {
        self.init(rawValue: value)
    }
}

extension Date.Format.Custom: CustomStringConvertible {
    public var description: String {
        rawValue
    }
}

extension Date.Format.Custom: CustomPlaygroundDisplayConvertible {
    public var playgroundDescription: Any {
        rawValue
    }
}

// MARK: - Built-in Format.Custom

extension Date.Format.Custom {
    /// `yyyy-MM-dd'T'HH:mm:ss.SSSZ`
    public static let iso8601: Self = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"

    /// `yyyy-MM-dd'T'HH:mm:ss`
    public static let iso8601Local: Self = "yyyy-MM-dd'T'HH:mm:ss"

    /// `yyyy-MM-dd`
    public static let yearMonthDayDash: Self = "yyyy-MM-dd"

    /// yyyy-MM`
    public static let yearMonthDash: Self = "yyyy-MM"

    /// `M/dd`
    public static let monthDaySlash: Self = "M/dd"

    /// `MM/dd/yyyy`
    public static let monthDayYearSlash: Self = "MM/dd/yyyy"

    /// `MM/dd/yyyy - h:mma`
    public static let monthDayYearSlashTime: Self = "MM/dd/yyyy - h:mma"

    /// `yyyy`
    public static let year: Self = "yyyy"

    /// `yyyy MM dd`
    public static let yearMonthDaySpace: Self = "yyyy MM dd"

    /// `LLL dd`
    public static let monthDayShortSpace: Self = "LLL dd"

    /// `MMMM d, yyyy`
    public static let monthDayYearFull: Self = "MMMM d, yyyy"

    /// `MMMM d`
    public static let monthDaySpace: Self = "MMMM d"

    /// `MMM d`
    public static let monthDayAbbreviated: Self = "MMM d"

    /// `MMMM yyyy`
    public static let monthYearFull: Self = "MMMM yyyy"

    /// `yyyyMM`
    public static let yearMonthHash: Self = "yyyyMM"

    /// Used for ordinal days like `June 4th`
    public static var monthDayOrdinal: Self { .init(rawValue: "xcore_\(#function)") }

    /// Used for ordinal days with short months like `Jun 4th`
    public static var monthShortDayOrdinal: Self { .init(rawValue: "xcore_\(#function)") }

    /// Used for ordinal days with short months like `Jun. 4th`
    public static var monthShortPeriodDayOrdinal: Self { .init(rawValue: "xcore_\(#function)") }
}
