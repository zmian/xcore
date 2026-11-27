//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

public struct DecimalCodingFormatStyle: CodingFormatStyle, Sendable {
    private let encodeAsString: Bool

    fileprivate init(encodeAsString: Bool) {
        self.encodeAsString = encodeAsString
    }

    public func decode(_ value: AnyCodable) throws -> Decimal {
        let value = value.value

        if let value = value as? Decimal {
            return value
        }

        if
            let value = value as? String ?? (value as? LosslessStringConvertible)?.description,
            let decimal = Decimal(string: value, locale: .us)
        {
            return decimal
        }

        throw CodingFormatStyleError.invalidValue
    }

    public func encode(_ value: Decimal) throws -> AnyCodable {
        AnyCodable.from(encodeAsString ? value.stringValue : value)
    }
}

// MARK: - Convenience

extension DecodingFormatStyle where Self == DecimalCodingFormatStyle {
    public static var decimal: Self {
        .init(encodeAsString: CodingFormatStyleDefaults.defaultEncodeAsString)
    }
}

extension EncodingFormatStyle where Self == DecimalCodingFormatStyle {
    public static var decimal: Self {
        .init(encodeAsString: CodingFormatStyleDefaults.defaultEncodeAsString)
    }

    public static func decimal(asString: Bool) -> Self {
        .init(encodeAsString: asString)
    }
}

extension DecimalCodingFormatStyle {
    /// Forwards to ``CodingFormatStyleDefaults/defaultEncodeAsString``.
    public static var defaultEncodeAsString: Bool {
        get { CodingFormatStyleDefaults.defaultEncodeAsString }
        set { CodingFormatStyleDefaults.defaultEncodeAsString = newValue }
    }
}
