//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

public struct DecimalCodingFormatStyle: CodingFormatStyle {
    public static var defaultEncodeAsString = false

    private static let numberFormatter = NumberFormatter().apply {
        $0.locale = .us
        $0.maximumFractionDigits = Int.maxFractionDigits
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

        if
            let value = value as? String ?? (value as? LosslessStringConvertible)?.description,
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
    public static var decimal: Self {
        .init(encodeAsString: Self.defaultEncodeAsString)
    }
}

extension EncodingFormatStyle where Self == DecimalCodingFormatStyle {
    public static var decimal: Self {
        .init(encodeAsString: Self.defaultEncodeAsString)
    }

    public static func decimal(asString: Bool) -> Self {
        .init(encodeAsString: asString)
    }
}
