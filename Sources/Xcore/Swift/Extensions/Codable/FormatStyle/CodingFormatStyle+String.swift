//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

extension StringCodingFormatStyle {
    public struct Options: OptionSet {
        public let rawValue: Int

        public init(rawValue: Int) {
            self.rawValue = rawValue
        }

        /// Applies `String.trimmed()` function on the value.
        public static let trimmed = Options(rawValue: 1 << 0)
        /// Removes whitespaces from the value.
        public static let trimWhitespaces = Options(rawValue: 1 << 1)
        /// Converts the value to lowercase.
        public static let lowercase = Options(rawValue: 1 << 2)
        /// Converts the value to uppercase.
        public static let uppercase = Options(rawValue: 1 << 3)
        /// Converts the value to snake case.
        public static let snakecase = Options(rawValue: 1 << 4)
        /// Converts the value to camel case.
        public static let camelcase = Options(rawValue: 1 << 5)
        /// Converts the value to title case.
        public static let titlecase = Options(rawValue: 1 << 6)
        /// Throws if the string is blank.
        public static let blankThrows = Options(rawValue: 1 << 7)
    }
}

public struct StringCodingFormatStyle: CodingFormatStyle {
    private let options: Options

    init(options: Options) {
        self.options = options
    }

    public func decode(_ value: AnyCodable) throws -> String {
        let value = value.value
        let result: String

        if let value = value as? String {
            result = value
        } else if type(of: value) == Any?.self {
            throw CodingFormatStyleError.invalidValue
        } else {
            result = String(describing: value)
        }

        return try applyOptions(to: result)
    }

    public func encode(_ value: String) throws -> AnyCodable {
        AnyCodable(try applyOptions(to: value))
    }

    private func applyOptions(to value: String) throws -> String {
        var result = value

        guard !options.isEmpty else {
            return result
        }

        if options.contains(.trimmed) {
            result = result.trimmed()
        }

        if options.contains(.trimWhitespaces) {
            result = result.replaceWhitespaces(with: "")
        }

        if options.contains(.lowercase) {
            result = result.lowercased()
        }

        if options.contains(.uppercase) {
            result = result.uppercased()
        }

        if options.contains(.snakecase) {
            result = result.snakecased()
        }

        if options.contains(.camelcase) {
            result = result.camelcased()
        }

        if options.contains(.titlecase) {
            result = result.titlecased()
        }

        if options.contains(.blankThrows), result.isBlank {
            throw CodingFormatStyleError.invalidValue
        }

        return result
    }
}

// MARK: - Convenience

extension DecodingFormatStyle where Self == StringCodingFormatStyle {
    public static func string(options: Self.Options) -> Self {
        Self(options: options)
    }
}

extension EncodingFormatStyle where Self == StringCodingFormatStyle {
    public static func string(options: Self.Options) -> Self {
        Self(options: options)
    }
}
