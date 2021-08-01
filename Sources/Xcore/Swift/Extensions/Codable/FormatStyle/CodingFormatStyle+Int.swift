//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

public struct IntCodingFormatStyle: CodingFormatStyle {
    private static let numberFormatter = NumberFormatter().apply {
        $0.locale = .us
    }

    private let encodeAsString: Bool

    fileprivate init(encodeAsString: Bool) {
        self.encodeAsString = encodeAsString
    }

    public func decode(_ value: AnyCodable) throws -> Int {
        let value = value.value

        if let value = value as? Int {
            return value
        }

        if
            let value = value as? String,
            let int = Self.numberFormatter.number(from: value)?.intValue
        {
            return int
        }

        throw CodingFormatStyleError.invalidValue
    }

    public func encode(_ value: Int) throws -> AnyCodable {
        AnyCodable.from(encodeAsString ? String(format: "%i", value) : value)
    }
}

// MARK: - Convenience

extension DecodingFormatStyle where Self == IntCodingFormatStyle {
    public static var int: Self { Self(encodeAsString: false) }
}

extension EncodingFormatStyle where Self == IntCodingFormatStyle {
    public static var int: Self { Self(encodeAsString: false) }

    public static func int(asString: Bool) -> Self {
        Self(encodeAsString: asString)
    }
}
