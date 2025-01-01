//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

public struct DateCodingFormatStyle: CodingFormatStyle, Sendable {
    public static let formats: [Date.Style] = [
        .format(.iso8601),
        .format(.iso8601Local),
        // yyyy-MM-dd (e.g., 2020-06-04)
        .iso8601(.withFullDate)
    ]

    private let calendar: Calendar
    private let formats: [Date.Style]

    init(
        calendar: Calendar = .defaultCodable,
        formats: [Date.Style] = Self.formats
    ) {
        self.formats = formats
        self.calendar = calendar
    }

    public func decode(_ value: String) throws -> Date {
        for format in formats {
            if let date = Date(value, style: format, calendar: calendar) {
                return date
            }
        }

        throw CodingFormatStyleError.invalidValue
    }

    public func encode(_ value: Date) throws -> String {
        if let format = formats.first {
            return value.formatted(style: format, in: calendar)
        }

        throw CodingFormatStyleError.invalidValue
    }
}

// MARK: - Convenience

extension DecodingFormatStyle where Self == DateCodingFormatStyle {
    public static func date(
        calendar: Calendar = .defaultCodable,
        formats: [Date.Style] = Self.formats
    ) -> Self {
        .init(calendar: calendar, formats: formats)
    }

    public static func date(
        calendar: Calendar = .defaultCodable,
        formats: Date.Style...
    ) -> Self {
        .init(calendar: calendar, formats: formats)
    }
}

extension EncodingFormatStyle where Self == DateCodingFormatStyle {
    public static func date(
        calendar: Calendar = .defaultCodable,
        formats: [Date.Style] = Self.formats
    ) -> Self {
        .init(calendar: calendar, formats: formats)
    }

    public static func date(
        calendar: Calendar = .defaultCodable,
        formats: Date.Style...
    ) -> Self {
        .init(calendar: calendar, formats: formats)
    }
}
