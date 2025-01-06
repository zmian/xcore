//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

public struct DateCodingFormatStyle: CodingFormatStyle, Sendable {
    public typealias Format = Date.ISO8601FormatStyle

    public static let formats: [Format] = [
        // "2000-01-01T09:41:10.000+0000"
        .iso8601.date().time(includingFractionalSeconds: true),
        // "2000-01-01T09:41:10"
        .iso8601.date().time(includingFractionalSeconds: false),
        // yyyy-MM-dd (e.g., 2020-06-04)
        .iso8601.date()
    ]

    private let calendar: Calendar
    private let formats: [Format]

    init(
        calendar: Calendar = .defaultCodable,
        formats: [Format] = Self.formats
    ) {
        self.formats = formats
        self.calendar = calendar
    }

    public func decode(_ value: String) throws -> Date {
        for format in formats {
            if let date = try? Date(value, strategy: format.timeZone(calendar.timeZone)) {
                return date
            }
        }

        throw CodingFormatStyleError.invalidValue
    }

    public func encode(_ value: Date) throws -> String {
        if let format = formats.first {
            return value.formatted(format.timeZone(calendar.timeZone))
        }

        throw CodingFormatStyleError.invalidValue
    }
}

// MARK: - Convenience

extension DecodingFormatStyle where Self == DateCodingFormatStyle {
    public static func date(
        calendar: Calendar = .defaultCodable,
        formats: [Self.Format] = Self.formats
    ) -> Self {
        .init(calendar: calendar, formats: formats)
    }

    public static func date(
        calendar: Calendar = .defaultCodable,
        formats: Self.Format...
    ) -> Self {
        .init(calendar: calendar, formats: formats)
    }
}

extension EncodingFormatStyle where Self == DateCodingFormatStyle {
    public static func date(
        calendar: Calendar = .defaultCodable,
        formats: [Self.Format] = Self.formats
    ) -> Self {
        .init(calendar: calendar, formats: formats)
    }

    public static func date(
        calendar: Calendar = .defaultCodable,
        formats: Self.Format...
    ) -> Self {
        .init(calendar: calendar, formats: formats)
    }
}
