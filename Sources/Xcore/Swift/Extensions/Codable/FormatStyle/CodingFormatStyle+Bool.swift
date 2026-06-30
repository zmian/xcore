//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

public struct BoolCodingFormatStyle: CodingFormatStyle, Sendable {
    private let encodeAsString: Bool

    fileprivate init(encodeAsString: Bool) {
        self.encodeAsString = encodeAsString
    }

    public func decode(_ value: JSONValue) throws -> Bool {
        let value = value.anyValue

        if let value = value as? Bool {
            return value
        } else if let value = value as? String {
            return value == "true"
        } else {
            return false
        }
    }

    public func encode(_ value: Bool) throws -> JSONValue {
        if encodeAsString {
            return JSONValue(value ? "true" : "false")
        }

        return JSONValue(value)
    }
}

// MARK: - Convenience

extension DecodingFormatStyle where Self == BoolCodingFormatStyle {
    public static var bool: Self {
        .init(encodeAsString: false)
    }
}

extension EncodingFormatStyle where Self == BoolCodingFormatStyle {
    public static var bool: Self {
        .init(encodeAsString: false)
    }

    public static func bool(asString: Bool) -> Self {
        .init(encodeAsString: asString)
    }
}
