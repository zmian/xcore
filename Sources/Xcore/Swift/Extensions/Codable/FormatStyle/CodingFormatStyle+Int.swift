//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

public struct IntCodingFormatStyle: CodingFormatStyle, Sendable {
    private let encodeAsString: Bool

    fileprivate init(encodeAsString: Bool) {
        self.encodeAsString = encodeAsString
    }

    public func decode(_ value: AnyCodable) throws -> Int {
        let value = value.value

        if let value = value as? Int {
            return value
        }

        guard let value = value as? String else {
            throw CodingFormatStyleError.invalidValue
        }

        return try Int(value, format: .number.locale(.usPosix))
    }

    public func encode(_ value: Int) throws -> AnyCodable {
        AnyCodable.from(encodeAsString ? String(format: "%i", value) : value)
    }
}

// MARK: - Convenience

extension DecodingFormatStyle where Self == IntCodingFormatStyle {
    public static var int: Self {
        .init(encodeAsString: false)
    }
}

extension EncodingFormatStyle where Self == IntCodingFormatStyle {
    public static var int: Self {
        .init(encodeAsString: false)
    }

    public static func int(asString: Bool) -> Self {
        .init(encodeAsString: asString)
    }
}
