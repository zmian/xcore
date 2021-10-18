//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

public struct DecimalCodingFormatStyle: CodingFormatStyle {
    private static let numberFormatter = NumberFormatter().apply {
        $0.locale = .us
    }

    private let encodeAsString: Bool

    fileprivate init(encodeAsString: Bool) {
        self.encodeAsString = encodeAsString
    }

    public func decode(_ value: AnyCodable) throws -> Decimal {
        let value = value.value

        if let value = value as? Decimal {
            return value
        }

        if let value = value as? Int {
            return Decimal(value)
        }

        if
            let value = value as? String,
            let decimal = Self.numberFormatter.number(from: value)?.decimalValue
        {
            return decimal
        }

        throw CodingFormatStyleError.invalidValue
    }

    public func encode(_ value: Decimal) throws -> AnyCodable {
        AnyCodable.from(encodeAsString ? "\(value)" : value)
    }
}

// MARK: - Convenience

extension DecodingFormatStyle where Self == DecimalCodingFormatStyle {
    public static var decimal: Self { Self(encodeAsString: false) }
}

extension EncodingFormatStyle where Self == DecimalCodingFormatStyle {
    public static var decimal: Self { Self(encodeAsString: false) }

    public static func decimal(asString: Bool) -> Self {
        Self(encodeAsString: asString)
    }
}
