//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

public struct DoubleCodingFormatStyle: CodingFormatStyle {
    public static var defaultEncodeAsString = false

    private static let numberFormatter = NumberFormatter().apply {
        $0.locale = .us
        $0.maximumFractionDigits = Int.maxFractionDigits
    }

    private let encodeAsString: Bool

    fileprivate init(encodeAsString: Bool) {
        self.encodeAsString = encodeAsString
    }

    public func decode(_ value: AnyCodable, file: StaticString = #fileID, line: UInt = #line) throws -> Double {
        let value = value.value

        if let value = value as? Double {
            return value
        }

        if let value = value as? Int {
            return Double(value)
        }

        if
            let value = value as? String,
            let double = Self.numberFormatter.number(from: value)?.doubleValue
        {
            return double
        }

        throw CodingFormatStyleError.invalidValue(value, file: file, line: line)
    }

    public func encode(_ value: Double, file: StaticString = #fileID, line: UInt = #line) throws -> AnyCodable {
        AnyCodable.from(encodeAsString ? String(format: "%d", value) : value)
    }
}

// MARK: - Convenience

extension DecodingFormatStyle where Self == DoubleCodingFormatStyle {
    public static var double: Self {
        .init(encodeAsString: Self.defaultEncodeAsString)
    }
}

extension EncodingFormatStyle where Self == DoubleCodingFormatStyle {
    public static var double: Self {
        .init(encodeAsString: Self.defaultEncodeAsString)
    }

    public static func double(asString: Bool) -> Self {
        .init(encodeAsString: asString)
    }
}
