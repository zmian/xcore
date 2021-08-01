//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

public struct BoolCodingFormatStyle: CodingFormatStyle {
    private let encodeAsString: Bool

    fileprivate init(encodeAsString: Bool) {
        self.encodeAsString = encodeAsString
    }

    public func decode(_ value: AnyCodable) throws -> Bool {
        let value = value.value

        if let value = value as? Bool {
            return value
        } else if let value = value as? String {
            return value == "true"
        } else {
            return false
        }
    }

    public func encode(_ value: Bool) throws -> AnyCodable {
        if encodeAsString {
            return AnyCodable(value ? "true" : "false")
        }

        return AnyCodable(value)
    }
}

// MARK: - Convenience

extension DecodingFormatStyle where Self == BoolCodingFormatStyle {
    public static var bool: Self { Self(encodeAsString: false) }
}

extension EncodingFormatStyle where Self == BoolCodingFormatStyle {
    public static var bool: Self { Self(encodeAsString: false) }

    public static func bool(asString: Bool) -> Self {
        Self(encodeAsString: asString)
    }
}
