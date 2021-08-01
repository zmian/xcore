//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//
// swiftlint:disable opening_brace

import Foundation

public struct FormatterCodingFormatStyle<Output>: CodingFormatStyle {
    private let formatter: Formatter

    fileprivate init(_ formatter: Formatter) {
        self.formatter = formatter
    }

    public func decode(_ value: String) throws -> Output {
        var obj: AnyObject?
        formatter.getObjectValue(&obj, for: value, errorDescription: nil)

        guard let value = obj as? Output else {
            throw CodingFormatStyleError.invalidValue
        }

        return value
    }

    public func encode(_ value: Output) throws -> String {
        guard let value = formatter.string(for: value) else {
            throw CodingFormatStyleError.invalidValue
        }

        return value
    }
}

// MARK: - Convenience

extension DecodingFormatStyle {
    public static func formatter<Output>(_ formatter: Formatter) -> Self
        where Self == FormatterCodingFormatStyle<Output>
    {
        Self(formatter)
    }
}

extension EncodingFormatStyle {
    public static func formatter<Output>(_ formatter: Formatter) -> Self
        where Self == FormatterCodingFormatStyle<Output>
    {
        Self(formatter)
    }
}
