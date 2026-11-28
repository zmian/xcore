//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

public struct DoubleCodingFormatStyle: CodingFormatStyle, Sendable {
    private let encodeAsString: Bool

    fileprivate init(encodeAsString: Bool) {
        self.encodeAsString = encodeAsString
    }

    public func decode(_ value: AnyCodable) throws -> Double {
        let value = value.value

        if let value = value as? Double {
            return value
        }

        if let value = value as? Int {
            return Double(value)
        }

        guard let value = value as? String else {
            throw CodingFormatStyleError.invalidValue
        }

        return try Double(value, format: .number
            .locale(.usPosix)
            .precision(.fractionLength(.maxFractionDigits))
        )
    }

    public func encode(_ value: Double) throws -> AnyCodable {
        AnyCodable.from(encodeAsString ? value.stringValue : value)
    }
}

// MARK: - Convenience

extension DecodingFormatStyle where Self == DoubleCodingFormatStyle {
    public static var double: Self {
        .init(encodeAsString: CodingFormatStyleDefaults.defaultEncodeAsString)
    }
}

extension EncodingFormatStyle where Self == DoubleCodingFormatStyle {
    public static var double: Self {
        .init(encodeAsString: CodingFormatStyleDefaults.defaultEncodeAsString)
    }

    public static func double(asString: Bool) -> Self {
        .init(encodeAsString: asString)
    }
}

extension DoubleCodingFormatStyle {
    /// Forwards to ``CodingFormatStyleDefaults/defaultEncodeAsString``.
    public static var defaultEncodeAsString: Bool {
        get { CodingFormatStyleDefaults.defaultEncodeAsString }
        set { CodingFormatStyleDefaults.defaultEncodeAsString = newValue }
    }
}
